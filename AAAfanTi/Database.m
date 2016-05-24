//
//  Database.m
//  afanti
//
//  Created by 尾巴超大号 on 15/11/27.
//  Copyright © 2015年 尾巴超大号. All rights reserved.
//

#import "Database.h"
#import "sqlite3.h"
#define DATABASENAME @"afanti.sqlite"
@interface Database ()

@property (nonatomic,assign) sqlite3 *database;

@end

@implementation Database

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



#pragma mark create database
- (void)createDatabase
{
    NSString *database_path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:DATABASENAME];
    if (sqlite3_open([database_path UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"database open failed");
    }
}

#pragma mark - create table
- (void)crateTableAndAdd
{
    NSString *createTabInfo = @"CREATE TABLE IF NOT EXISTS tabinfo (uid INTEGER,title TEXT)";
    [self execSql:createTabInfo];
    
    NSString *ad = [NSString stringWithFormat:@"INSERT INTO '%@' (uid,title) VALUES(%d,'%@')",@"tabinfo",0,@"精品旅游"];

    [self execSql:ad];

}
#pragma mark - sqlite3 exec
- (void)execSql:(NSString *)sql
{
    char *error;
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        sqlite3_close(_database);
        NSLog(@"error:%s",error);
    }
}
@end
