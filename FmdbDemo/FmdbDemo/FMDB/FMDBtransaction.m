//
//  FMDBtransaction.m
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/26.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FMDBtransaction.h"
#import "FMDB.h"

@interface FMDBtransaction (){
    FMDatabase *db;
}

@end
static FMDBtransaction *_sharedSingleton;
@implementation FMDBtransaction
+ (FMDBtransaction *)sharedInstance {
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        _sharedSingleton = [[FMDBtransaction alloc]init];
    });
    return _sharedSingleton;
}
/**
 transaction:事务 开启一个事务执行多个任务，效率高
 1.fmdb 封装transaction 方法，操作简单
 - (BOOL)beginTransaction;
 - (BOOL)beginDeferredTransaction;
 - (BOOL)beginImmediateTransaction;
 - (BOOL)beginExclusiveTransaction;
 - (BOOL)commit;
 - (BOOL)rollback;
 等等
 */

/**
 事务特征：
 原子性（Atomic）：事务中包含的一系列操作被看作一个逻辑单元，这个逻辑单元要不全部成功，要不全部失败
 一致性（Consistency）：事务中包含的一系列操作，只有合法的数据被写入数据库，一些列操作失败之后，事务会滚到最初创建事务的状态
 隔离性（Isolation）：对数据进行修改的多个事务之间是隔离的，每个事务是独立的，不应该以任何方式来影响其他事务
 持久性（Durability）事务完成之后，事务处理的结果必须得到固化，它对于系统的影响是永久的，该修改即使出现系统固执也将一直保留，真实的修改了数据库
 */

/**
 *  ⚠️事务处理
 *  ⚠️用于：快速高效的执行批量操作
 */
- (void)handleTransaction {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"test1.db"];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:dbPath];
    [db open];
    if (![db isOpen]) {
        return;
    }
    BOOL result = [db executeUpdate:@"create table if not exists text1 (name text,age,integer,ID integer)"];
    if (result) {
        NSLog(@"create table success");
    }
    //1.开启事务
    [db beginTransaction];
    NSDate *begin = [NSDate date];
    BOOL rollBack = NO;
    @try {
        //2.在事务中执行任务
        for (int i = 0; i< 500; i++) {
            NSString *name = [NSString stringWithFormat:@"text_%d",i];
            NSInteger age = i;
            NSInteger ID = i *1000;
            
            BOOL result = [db executeUpdate:@"insert into text1(name,age,ID) values(:name,:age,:ID)" withParameterDictionary:@{@"name":name,@"age":[NSNumber numberWithInteger:age],@"ID":@(ID)}];
            if (result) {
                NSLog(@"在事务中insert success");
            }
        }
    }
    @catch(NSException *exception) {
        //3.在事务中执行任务失败，退回开启事务之前的状态
        rollBack = YES;
        [db rollback];
    }
    @finally {
        //4. 在事务中执行任务成功之后
        rollBack = NO;
        [db commit];
    }
    NSDate *end = [NSDate date];
    NSTimeInterval time = [end timeIntervalSinceDate:begin];
    NSLog(@"事务中执行插入任务 所需要的时间 = %f",time);
}
/**
 *  ⚠️常规处理
 *  ⚠️对比发现：用事务处理一系列数据库操作，要省时效率高的多
 */
- (void)handleNotransaction {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"test1.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    if (![db isOpen]) {
        return;
    }
    BOOL result = [db executeUpdate:@"create table if not exists text2('ID' INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age INTRGER)"];
    if (!result) {
        [db close];
    }
    NSDate *begin = [NSDate date];
    for (int i = 0; i< 500; i++) {
        NSString *name = [NSString stringWithFormat:@"text_%d",i];
        NSInteger age = i;
        NSInteger ID = i *1000;
        
        BOOL result = [db executeUpdate:@"insert into text2(name,age,ID) values(:name,:age,:ID)" withParameterDictionary:@{@"name":name,@"age":[NSNumber numberWithInteger:age],@"ID":@(ID)}];
        if (result) {
            NSLog(@"不在事务中insert success");
        }
    }
    NSDate *end = [NSDate date];
    NSTimeInterval time = [end timeIntervalSinceDate:begin];
    NSLog(@"不在事务中执行插入任务 所需要的时间 = %f",time);
}
/**
 *  批量操作
 */
- (void)handleStatements{
    NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
    "create table bulktest2 (id integer primary key autoincrement, y text);"
    "create table bulktest3 (id integer primary key autoincrement, z text);"
    "insert into bulktest1 (x) values ('XXX');"
    "insert into bulktest2 (y) values ('YYY');"
    "insert into bulktest3 (z) values ('ZZZ');";
    
    BOOL success = [db executeStatements:sql];
    
    sql = @"select count(*) as count from bulktest1;"
    "select count(*) as count from bulktest2;"
    "select count(*) as count from bulktest3;";
    
    success = [db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
//        NSInteger count = [dictionary[@"count"] integerValue];
//        XCTAssertEqual(count, 1, @"expected one record for dictionary %@", dictionary);
        NSLog(@"批量操作sql：%@",dictionary);
        return 0;
    }];
}

@end
