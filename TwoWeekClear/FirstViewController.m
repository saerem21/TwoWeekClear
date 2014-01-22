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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        Plan *one = [data objectAtIndex:indexPath.row];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM PLAN WHERE rowid = %d", one.rowID];
        
        char *errorMsg;
        int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
        
        if (SQLITE_OK != ret) {
            NSLog(@"Error (%d) on deleting data : %s", ret, errorMsg);
        }
        [self resolveData];
    }
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

- (IBAction)test:(id)sender {
    
    Plan *one=[data objectAtIndex:0];
    NSLog(@"%d", one.numberText);
}

- (BOOL)isEnd{
    NSString *queryStr = @"SELECT rowid FROM PLAN WHERE rowid = ";
    sqlite3_stmt *stmt;
    int ret = sqlite3_prepare_v2(db, [queryStr UTF8String], -1, &stmt, NULL);
    
    return YES;
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
        int year = (int)sqlite3_column_int(stmt, 5);
        int month = (int)sqlite3_column_int(stmt, 6);
        int day = (int)sqlite3_column_int(stmt, 7);
        Plan *one = [[Plan alloc] init];
        
        one.year =year;
        one.month = month;
        one.day =day;
        
        one.rowID = rowID;
        NSString *arr = [NSString stringWithFormat:@"%s",content];
        
        one.textContent = arr;
        one.numberText =doNum;
        
        NSLog(@"table %s",createAtDate);
        NSString *arre = [NSString stringWithFormat:@"%s",createAtDate];
        one.createAtDate = arre;
        
        if(onOff == 1){
            one.onOff = YES;
        }
        else if(onOff == 0){
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
    Plan *one=[data objectAtIndex:indexPath.row];
        //NSDate *datecon = one.createAtDate;
    //cell.date =
    NSString *datecre = one.createAtDate;
    //NSLog(@"%@",one.createAtDate);
    cell.date.text = datecre;
    cell.textContent.text = one.textContent;
    
    
    cell.onOff.on = one.onOff;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Plan *one=[data objectAtIndex:indexPath.row];
    NSString *sql;
    
    NSLog(@"onoff %d",one.onOff);
    NSLog(@"selected cell %d",indexPath.row);
    
    if(one.onOff == NO){
        sql = [NSString stringWithFormat:@"UPDATE PLAN SET onOff = '%d' WHERE rowid = %d",1,indexPath.row+1];
        
        NSString *sqla = [NSString stringWithFormat:@"INSERT INTO DOIT (content,year,month,day) VALUES ('%@','%d','%d','%d')",one.textContent,one.year,one.month,one.day];
        
        char *errorMsg;
        int ret = sqlite3_exec(db, [sqla UTF8String], NULL, NULL, &errorMsg);
        
        if (SQLITE_OK != ret) {
            NSLog(@"Error (%d) on intsert data : %s", ret, errorMsg);
        }

    }else{
        sql = [NSString stringWithFormat:@"UPDATE PLAN SET onOff = '%d' WHERE rowid = %d",0,indexPath.row+1];
        NSLog(@"%@",sql);
    }
    
    char *errorMsg;
    int ret = sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errorMsg);
    
    if (SQLITE_OK != ret) {
        NSLog(@"Error (%d) on update data : %s", ret, errorMsg);
    }
    [self resolveData];
    
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
