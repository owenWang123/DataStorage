//
//  FMDBtransaction.h
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/26.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMDBtransaction : NSObject
+ (FMDBtransaction *)sharedInstance;
- (void)handleTransaction;
- (void)handleNotransaction;
- (void)handleStatements;

@end

NS_ASSUME_NONNULL_END
