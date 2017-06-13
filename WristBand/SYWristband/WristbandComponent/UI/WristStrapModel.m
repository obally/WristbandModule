//
//  WristStrapModel.m
//  WristStrapDemo
//
//  Created by obally on 17/4/11.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "WristStrapModel.h"

@implementation WristStrapModel

+ (WristStrapModel *)shareModel
{
    static WristStrapModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[WristStrapModel alloc]init];
    });
    return model;
}
-(instancetype)init
{
    self = [super init];
    return self;
}
MJCodingImplementation
@end
