//
//  SecondViewController.m
//  TwoWeekClear
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 Maybe There. All rights reserved.
//

#import "SecondViewController.h"
#import <sqlite3.h>

@interface SecondViewController ()

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
        const char *creatSQL = "CREATE TABLE IF NOT EXISTS PLAN (content TEXT,doNum INTEGER,createAtDate TEXT,onOff INTEGER)";
        char *errorMsg;
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

   
    
    UITextField *content;
    int doNum = 0 ;
    NSDate *date = [NSDate date];
    
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO PLAN (content,doNum,createAtDate,onOff) VALUES ('%@','%d','%@',%d)", content.text,doNum,date,1];
    
    char *errorMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
    if (SQLITE_OK != ret) {
        NSLog(@"Error (%d) on intsert data : %s", ret, errorMsg);
    }

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.firstOtherButtonIndex){
        
           }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	data = [NSMutableArray array];
    [self openDB];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self closeDB];
}

@end
