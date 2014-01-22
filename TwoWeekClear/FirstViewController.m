//
//  FirstViewController.m
//  TwoWeekClear
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 Maybe There. All rights reserved.
//

#import "FirstViewController.h"
#import "OrderCell.h"
#import "Plan.h"
#import <sqlite3.h>

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_result;
    NSInteger *orderNum;
    sqlite3 *db;
    NSMutableArray *data;
}
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation FirstViewController


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
        const char *creatSQL = "CREATE TABLE IF NOT EXISTS PLAN (content TEXT,doNum TEXT,createAtDate TEXT,onOff INTEGER)";
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


- (void)resolveData
{
    
    [data removeAllObjects];
    NSString *queryStr = @"SELECT rowid,content,doNum,createAtDate,onOff FROM PLAN";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    NSAssert2(SQLITE_OK == ret, @"Error(%d) on resolving data : %s", ret,sqlite3_errmsg(db));
    
    while (SQLITE_ROW == sqlite3_step(stmt)) {
        int rowID = sqlite3_column_int(stmt, 0);
        char *content = (char *)sqlite3_column_text(stmt, 1);
        int doNum = (int)sqlite3_column_int(stmt, 2);
        char *createAtDate = (char *)sqlite3_column_text(stmt, 3);
        int onOff = (int)sqlite3_column_int(stmt, 4);
        
        Plan *one = [[Plan alloc] init];
        
        one.rowID = rowID;
        one.textContent = content;
        one.numberText =doNum;
        one.createAtDate = createAtDate;
        
        if(onOff == 1){
            one.onOff = YES;
        }
        else{
            one.onOff = NO;
        }
        
        [data addObject:one];
    }
    
    sqlite3_finalize(stmt);
    
    [self.table reloadData];
}




/////////////////////////////////
//테이블뷰
///////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count %d", data.count);
    return data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    //cell =[data objectAtIndex:indexPath.row];
    NSLog(@"%@",[data objectAtIndex:indexPath.row]);
    
    cell.textContent.text = @"a";
    cell.numberText.text =@"11";
    cell.onOff.on = NO;
    return cell;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	data = [NSMutableArray array];
    [self openDB];
    [self resolveData];
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [super viewDidUnload];
    [self closeDB];
}

@end
