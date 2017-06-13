//
//  SYUserDataManager.h
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYUserInfoModel.h"
#import "SYLoginInfoModel.h"
@interface SYUserDataManager : NSObject
+ (instancetype)manager;
@property(nonatomic,strong) SYUserInfoModel *userInfoModel; //用户设置的基本信息
@property(nonatomic,strong) SYLoginInfoModel *userLoginInfoModel; //登录成功后的基本信息
- (void)removeUserLoginData;
@end
