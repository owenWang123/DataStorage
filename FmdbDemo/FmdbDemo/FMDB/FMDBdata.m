//
//  FMDBdata.m
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/26.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FMDBdata.h"
#import "FMDB.h"
#import "StudentModel.h"

@interface FMDBdata (){
    FMDatabase *db;
}

@end
static FMDBdata *_sharedSingleton;
@implementation FMDBdata
+ (FMDBdata *)sharedInstance {
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        _sharedSingleton = [[FMDBdata alloc]init];
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
 增删改查中 除了查询（executeQuery），其余操作都用（executeUpdate）
 //1.sql语句中跟columnname 绑定的value 用 ？表示，不加‘’，可选参数是对象类型如：NSString，不是基本数据结构类型如：int，方法自动匹配对象类型
 - (BOOL)executeUpdate:(NSString*)sql, ...;
 //2.sql语句中跟columnname 绑定的value 用%@／%d表示，不加‘’
 - (BOOL)executeUpdateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
 //3.sql语句中跟columnname 绑定的value 用 ？表示的地方依次用 (NSArray *)arguments 对应的数据替代
 - (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
 //4.同3 ，区别在于多一个error指针，记录更新失败
 - (BOOL)executeUpdate:(NSString*)sql values:(NSArray * _Nullable)values error:(NSError * _Nullable __autoreleasing *)error;
 //5.同3，区别在于用 ？ 表示的地方依次用(NSDictionary *)arguments中对应的数据替代
 - (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
 - (BOOL)executeUpdate:(NSString*)sql withVAList: (va_list)args;
 */
- (void)handleInsert:(StudentModel *)model {
    [db open];
    //0.直接sql语句
//        BOOL result = [db executeUpdate:@"insert into 't_student' (ID,name,gender,score) values(1,'x1',1,83)"];
    //1.
//        BOOL result = [db executeUpdate:@"insert into 't_student'(ID,name,gender,score) values(?,?,?,?)",@111,@"x2",@YES,@23];
    //2.
//        BOOL result = [db executeUpdateWithFormat:@"insert into 't_student' (ID,name,gender,score) values(%d,%@,%@,%d)",112,@"x3",@NO,43];
    //3.
    BOOL result = [db executeUpdate:@"insert into 't_student'(ID,name,gender,score) values(?,?,?,?)" withArgumentsInArray:@[@(model.ID),model.name,@(model.gender),@(model.score)]];
    //4.
    //    BOOL result = [db executeUpdate:@"insert into 't_student' (ID,name,gender,score) values(:ID,:name,:gender,:score)" withParameterDictionary:@{@"ID":@114,@"name":@"x4",@"gender":@"14",@"score":@89}];
    if (result) {
        NSLog(@"insert into 't_studet' success");
    } else {
        NSLog(@"%@",[db lastError].description);
    }
    [db close];
}
- (void)handleDelete:(NSInteger)ID {
    [db open];
    ///0.直接sql语句
    //    BOOL result = [db executeUpdate:@"delete from 't_student' where ID = 110"];
    //1.
    //    BOOL result = [db executeUpdate:@"delete from 't_student' where ID = ?",@(111)];
    //2.
    //    BOOL result = [db executeUpdateWithFormat:@"delete from 't_student' where ID = %d",112];
    //3.
    BOOL result = [db executeUpdate:@"delete from 't_student' where ID = ?" withArgumentsInArray:@[@(ID)]];
    //4.
    //    BOOL result = [db executeUpdate:@"delete from 't_student' where :ID = ?" withParameterDictionary:@{@"ID":@"114"}];
    if (result) {
        NSLog(@"delete from 't_student' success");
    } else {
        NSLog(@"%@",[db lastError].description);
    }
    [db close];
}
- (void)handleUpdateScore:(NSInteger)score withID:(NSInteger)ID {
    [db open];
    //0.直接sql语句
    //    BOOL result = [db executeUpdate:@"update 't_student' set ID = 110 where name = 'x1'"];
    //1.
    //    BOOL result = [db executeUpdate:@"update 't_student' set ID = ? where name = ?",@111,@"x2" ];
    //2.
    //    BOOL result = [db executeUpdateWithFormat:@"update 't_student' set ID = %d where name = %@",113,@"x3" ];
    //3.
    BOOL result = [db executeUpdate:@"update 't_student' set score = ? where ID = ?" withArgumentsInArray:@[@(score),@(ID)]];
    //4.
    //    BOOL result = [db executeUpdate:@"update 't_student' set :ID = ? where :name = ?" withParameterDictionary:@{@"ID":@114,@"name":@"x4"}];
    if (result) {
        NSLog(@"update 't_student' success");
    } else {
        NSLog(@"%@",[db lastError].description);
    }
    [db close];
}
/**
 FMResultSet根据column name获取对应数据的方法
 intForColumn：
 longForColumn：
 longLongIntForColumn：
 boolForColumn：
 doubleForColumn：
 stringForColumn：
 dataForColumn：
 dataNoCopyForColumn：
 UTF8StringForColumnIndex：
 objectForColumn：
 */
- (NSMutableArray *)handleQuery:(NSInteger)ID {
    [db open];
    //0.直接sql语句
    //    FMResultSet *result = [db executeQuery:@"select * from 't_student' where ID = 110"];
    //1.
    //    FMResultSet *result = [db executeQuery:@"select *from 't_student' where ID = ?",@111];
    //2.
    //    FMResultSet *result = [db executeQueryWithFormat:@"select * from 't_student' where ID = %d",112];
    //3.
    FMResultSet *result = [db executeQuery:@"select * from 't_student' where ID = ?" withArgumentsInArray:@[@(ID)]];
    //4
    //    FMResultSet *result = [db executeQuery:@"select * from 't_sutdent' where ID = ?" withParameterDictionary:@{@"ID":@114}];
    NSMutableArray *arr = [NSMutableArray array];
    while ([result next]) {
        StudentModel *student = [StudentModel new];
        student.ID = [result intForColumn:@"ID"];
        student.name = [result stringForColumn:@"name"];
        student.gender = [result boolForColumn:@"gender"];
        student.score = [result intForColumn:@"score"];
        [arr addObject:student];
        NSLog(@"从数据库查询到的人员 %@",student.name);
    }
    return arr;
}

@end
