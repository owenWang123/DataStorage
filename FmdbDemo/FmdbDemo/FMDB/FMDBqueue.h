//
//  FMDBqueue.h
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/27.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBqueue : NSObject
+ (FMDBqueue *)sharedInstance;
- (void)handleQueueMutilLine;
- (void)handleNormalMutilLine;

@end

NS_ASSUME_NONNULL_END
