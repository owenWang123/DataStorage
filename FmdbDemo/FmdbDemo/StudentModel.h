//
//  StudentModel.h
//  FmdbDemo
//
//  Created by 皓天 on 2019/6/26.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel : NSObject
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL gender;// YES男 NO女
@property (nonatomic, assign) int score;

@end

NS_ASSUME_NONNULL_END
