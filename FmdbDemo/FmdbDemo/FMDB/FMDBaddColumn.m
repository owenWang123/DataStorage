//
//  FMDBaddColumn.m
//  FmdbDemo
//
//  Created by 皓天 on 2019/7/15.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FMDBaddColumn.h"
#import "FMDB.h"
#import "StudentModel.h"

@interface FMDBaddColumn () {
    FMDatabase *db;
}

@end

static FMDBaddColumn *_sharedSingleton;
@implementation FMDBaddColumn
+ (FMDBaddColumn *)sharedInstance {
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        _sharedSingleton = [[FMDBaddColumn alloc]init];
    });
    return _sharedSingleton;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initDataBase];
    }
    return self;
}
- (void)initDataBase {
    //1.创建database路径
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"SQL.db"];
    NSLog(@"!!!dbPath = %@",dbPath);
    //2.创建对应路径下数据库
    db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    BOOL isSuccess = [db open];
    if (!isSuccess) {
        NSLog(@"db open fail");
        return;
    }
    //4.数据库中创建表（可创建多张）
    NSString *sql = @"create table if not exists t_student ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'gender' INTEGER NOT NULL,'score' INTEGER NOT NULL)";
    //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
    BOOL result = [db executeUpdate:sql];
    if (result) {
        NSLog(@"create table success");
    }
    [db close];
}

/**
 * Table中若column不存在，则插入
 */
- (void)checkDataBaseUpdate:(NSString *)tableStr column:(NSString *)columnStr {
    if (![self checkIfColumnExist:tableStr column:columnStr]) {
        [self addColumnToTable:tableStr column:columnStr];
    }
}
/**
 * 检查column是否存在
 */
- (BOOL)checkIfColumnExist:(NSString *)tableStr column:(NSString *)columnStr{
    BOOL result = [db columnExists:columnStr inTableWithName:tableStr];
    
    return result;
}
/**
 * 往Table中插入新column
 * 语法：ALTER TABLE table_name ADD column_name datatype
 * ⚠️ datatype应与column_name 类型匹配
 */
- (BOOL)addColumnToTable:(NSString *)tableStr column:(NSString *)columnStr{
    [db open];
    
    NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",tableStr,columnStr];
    BOOL worked = [db executeUpdate:alertStr];
    if(worked){
        NSLog(@"往Table中插入新column 插入成功");
    }else{
        NSLog(@"往Table中插入新column 插入失败");
    }
    
    [db close];
    
    // 测试
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self handleUpdatePhone:@"15011112222" withID:1];
    });
    
    return worked;
}
#pragma mark- 测试方法
- (void)handleUpdatePhone:(NSString *)phone withID:(NSInteger)ID {
    [db open];
    
    BOOL result = [db executeUpdate:@"update 't_student' set phone = ? where ID = ?",phone,@(ID)];
    if (result) {
        NSLog(@"update 't_student' success");
    } else {
        NSLog(@"%@",[db lastError].description);
    }
    
    [db close];
    
    // 测试
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self handleQuery:ID];
    });
}

- (NSMutableArray *)handleQuery:(NSInteger)ID {
    [db open];
    
    FMResultSet *result = [db executeQuery:@"select *from 't_student' where ID = ?",@(ID)];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        StudentModel *student = [StudentModel new];
        student.ID = [result intForColumn:@"ID"];
        student.name = [result stringForColumn:@"name"];
        student.gender = [result boolForColumn:@"gender"];
        student.score = [result intForColumn:@"score"];
        student.phone = [result stringForColumn:@"phone"];
        [arr addObject:student];
        NSLog(@"从数据库查询到的人员%d %@ %d %d %@",student.ID,student.name,student.gender,student.score,student.phone);
    }
    
    [db close];
    
    return arr;
}

@end
