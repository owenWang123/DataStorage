//
//  FMDBdata.h
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/26.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class StudentModel;
@interface FMDBdata : NSObject
+ (FMDBdata *)sharedInstance;
- (void)handleInsert:(StudentModel *)model;
- (void)handleDelete:(NSInteger)ID;
- (void)handleUpdateScore:(NSInteger)score withID:(NSInteger)ID;
- (NSMutableArray *)handleQuery:(NSInteger)ID;

@end

NS_ASSUME_NONNULL_END
