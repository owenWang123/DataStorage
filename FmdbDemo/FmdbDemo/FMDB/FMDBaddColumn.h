//
//  FMDBaddColumn.h
//  FmdbDemo
//
//  Created by 皓天 on 2019/7/15.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBaddColumn : NSObject
+ (FMDBaddColumn *)sharedInstance;

- (void)checkDataBaseUpdate:(NSString *)tableStr column:(NSString *)columnStr;
- (BOOL)checkIfColumnExist:(NSString *)tableStr column:(NSString *)columnStr;
- (BOOL)addColumnToTable:(NSString *)tableStr column:(NSString *)columnStr;
/* ⚠️ 以下为 测试 方法 ⚠️ */
- (void)handleUpdatePhone:(NSString *)phone withID:(NSInteger)ID;
- (NSMutableArray *)handleQuery:(NSInteger)ID;

@end

NS_ASSUME_NONNULL_END
