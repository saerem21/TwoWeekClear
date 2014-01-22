//
//  SecondViewController.m
//  TwoWeekClear
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 Maybe There. All rights reserved.
//

#import "SecondViewController.h"
#import <sqlite3.h>
#import "ViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *dateView;

@end

@implementation SecondViewController
{
    NSArray *_result;
    NSInteger *orderNum;
    sqlite3 *db;
    NSMutableArray *data;
}

- (void)openDB
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbFilePath = [docPath stringByAppendingPathComponent:@"db.sqlite"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existFile = [fm fileExistsAtPath:dbFilePath];
    
    int ret = sqlite3_open([dbFilePath UTF8String], &db);
    NSAssert1(SQLITE_OK == ret, @"Error on opening Database:%s", sqlite3_errmsg(db));
    NSLog(@"Success");
    
    if (existFile == NO) {
        const char *creatSQL = "CREATE TABLE IF NOT EXISTS PLAN (content TEXT,doNum INTEGER,createAtDate TEXT,onOff INTEGER,year TEXT,month TEXT,day TEXT)";
        char *errorMsg;
        ret = sqlite3_exec(db, creatSQL, NULL, NULL, &errorMsg);
        if (SQLITE_OK != ret) {
            [fm removeItemAtPath:dbFilePath error:nil];
            NSAssert1(SQLITE_OK == ret, @"Error on creating table : %s", errorMsg);
            NSLog(@"creating table with ret : %d", ret);
        }
        creatSQL = "CREATE TABLE IF NOT EXISTS DOIT (content TEXT,year TEXT,month TEXT,day TEXT,cellNum)";
        ret = sqlite3_exec(db, creatSQL, NULL, NULL, &errorMsg);
        if (SQLITE_OK != ret) {
            [fm removeItemAtPath:dbFilePath error:nil];
            NSAssert1(SQLITE_OK == ret, @"Error on creating table : %s", errorMsg);
            NSLog(@"creating table with ret : %d", ret);
        }
    }
}


- (void)closeDB
{
    sqlite3_close(db);
}


- (IBAction)addCell:(id)sender {

   
    
    UITextView *content = self.contentText;
    int doNum = 0 ;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    dateFormatter.dateFormat = @"yyyy";
    NSString *year = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:now]];
    dateFormatter.dateFormat = @"MM";
    NSString *month = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:now]];
    dateFormatter.dateFormat = @"dd";
    NSString *day = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:now]];
   
    
    NSString *makedate = [NSString stringWithFormat:@"%@ year %@ month %@ day",year,month,day];
    
    
    
    
    
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO PLAN (content,doNum,createAtDate,onOff,year,month,day) VALUES ('%@','%d','%@',%d,'%@','%@','%@')", content.text,doNum,makedate,0,year,month,day];
    
    char *errorMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
    if (SQLITE_OK != ret) {
        NSLog(@"Error (%d) on intsert data : %s", ret, errorMsg);
    }

    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	data = [NSMutableArray array];
    [self openDB];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy년 MM월 dd일";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *makedate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:now]];
    self.dateView.text = makedate;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self closeDB];
}

@end
