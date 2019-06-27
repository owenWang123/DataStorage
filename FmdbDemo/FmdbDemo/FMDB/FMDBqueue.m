//
//  FMDBqueue.m
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/27.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FMDBqueue.h"
#import "FMDB.h"

static FMDBqueue *_sharedSingleton;
@implementation FMDBqueue
+ (FMDBqueue *)sharedInstance {
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        _sharedSingleton = [[FMDBqueue alloc]init];
    });
    return _sharedSingleton;
}

/**
 *  在多条线程中不允许使用同一个FMDataBase实例对象，如果使用可能会造成数据丢失或者混乱，为了保证数据库操作时线程安全，引入FMDataBaseQueue
 */
- (void)handleQueueMutilLine {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"test4.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [db open];
    if (![db isOpen]) {
        return;
    }
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"create table if not exists text4('ID' INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age INTRGER)"];
        if (!result) {
            return;
        }
        NSLog(@"create table = %@",[NSThread currentThread]);
    }];
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        //测试开启多个线程操作数据库
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_group_async(group, queue, ^{
            BOOL result = [db executeUpdate:@"insert into text4(ID,name,age) values(:ID,:name,:age)" withParameterDictionary:@{@"ID":@10,@"name":@"10",@"age":@10}];
            if (result) {
                NSLog(@"在group insert 10 success");
            }
            NSLog(@"current thread = %@",[NSThread currentThread]);
            
        });
        dispatch_group_async(group, queue, ^{
            BOOL result = [db executeUpdate:@"insert into text4(ID,name,age) values(:ID,:name,:age)" withParameterDictionary:@{@"ID":@11,@"name":@"11",@"age":@11}];
            if (result) {
                NSLog(@"在group insert 11 success");
            }
            NSLog(@"current thread = %@",[NSThread currentThread]);
            
        });
        dispatch_group_async(group, queue, ^{
            BOOL result = [db executeUpdate:@"insert into text4(ID,name,age) values(:ID,:name,:age)" withParameterDictionary:@{@"ID":@12,@"name":@"12",@"age":@12}];
            if (result) {
                NSLog(@"在group insert 12 success");
            }
            NSLog(@"current thread = %@",[NSThread currentThread]);
            
        });
        dispatch_group_notify(group, queue, ^{
            NSLog(@"done");
            NSLog(@"current thread = %@",[NSThread currentThread]);
            BOOL result = [db executeQuery:@"select * from text4 where ID = ?",@(10)];
            if (result) {
                NSLog(@"query 10 success");
            }
            BOOL result2 = [db executeQuery:@"select * from text4 where ID = ?",@(11)];
            if (result2) {
                NSLog(@"query 11 success");
            }
            BOOL result3 = [db executeQuery:@"select * from text4 where ID = ?",@(12)];
            if (result3) {
                NSLog(@"query 12 success");
            }
        });
    }];
}
/**
 *  正常操作，无保护
 */
- (void)handleNormalMutilLine {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"test2.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    if (![db isOpen]) {
        return;
    }
    BOOL result = [db executeUpdate:@"create table if not exists text3('ID' INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age INTRGER)"];
    if (!result) {
        return;
    }
    NSLog(@"create table = %@",[NSThread currentThread]);
    //测试开启多个线程操作数据库
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        BOOL result = [db executeUpdate:@"insert into text3(ID,name,age) values(:ID,:name,:age)" withParameterDictionary:@{@"ID":@10,@"name":@"10",@"age":@10}];
        if (result) {
            NSLog(@"在group insert 10 success");
        }
        NSLog(@"current thread = %@",[NSThread currentThread]);
        
    });
    dispatch_group_async(group, queue, ^{
        BOOL result = [db executeUpdate:@"insert into text3(ID,name,age) values(:ID,:name,:age)" withParameterDictionary:@{@"ID":@11,@"name":@"11",@"age":@11}];
        if (result) {
            NSLog(@"在group insert 11 success");
        }
        NSLog(@"current thread = %@",[NSThread currentThread]);
        
    });
    dispatch_group_async(group, queue, ^{
        BOOL result = [db executeUpdate:@"insert into text3(ID,name,age) values(:ID,:name,:age)" withParameterDictionary:@{@"ID":@12,@"name":@"12",@"age":@12}];
        if (result) {
            NSLog(@"在group insert 12 success");
        }
        NSLog(@"current thread = %@",[NSThread currentThread]);
        
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
        NSLog(@"current thread = %@",[NSThread currentThread]);
        BOOL result = [db executeQuery:@"select * from text3 where ID = ?",@(10)];
        if (result) {
            NSLog(@"query 10 success");
        }
        BOOL result2 = [db executeQuery:@"select * from text3 where ID = ?",@(11)];
        if (result2) {
            NSLog(@"query 11 success");
        }
        BOOL result3 = [db executeQuery:@"select * from text3 where ID = ?",@(12)];
        if (result3) {
            NSLog(@"query 12 success");
        }
    });
}
@end
