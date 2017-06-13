//
//  SYLoginInfoModel.h
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYLoginInfoModel : NSObject
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *serverTime;
@property(nonatomic,copy) NSString *mobile; //手机号
@property(nonatomic,copy) NSString *imgUrl; //头像
@property(nonatomic,copy) NSString *nickName; //昵称
@property(nonatomic,copy) NSString *gender; //性别
@property(nonatomic,copy) NSString *targetStep; //目标步数
@property(nonatomic,copy) NSString *height; //身高
@property(nonatomic,copy) NSString *weight; //体重
@property(nonatomic,copy) NSString *birthday; //生日

@end
