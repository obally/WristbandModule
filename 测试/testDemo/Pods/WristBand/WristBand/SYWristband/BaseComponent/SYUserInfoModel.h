//
//  SYUserInfoModel.h
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//  用户基本信息模型

#import <Foundation/Foundation.h>

@interface SYUserInfoModel : NSObject
@property(nonatomic,copy) NSString *mobile; //手机号
@property(nonatomic,copy) NSString *nickname; //昵称
@property(nonatomic,copy) NSString *sexcode; //性别
@property(nonatomic,copy) NSString *birthday; //出生年月 1991-05
@property(nonatomic,copy) NSString *height; //身高 63
@property(nonatomic,copy) NSString *weight; //体重 65
@property(nonatomic,copy) NSString *imgUrl; //头像
@property(nonatomic,copy) NSString *sportsTarget; //运动目标
@property(nonatomic,copy) NSString *manufacturers; //设备厂商
@property(nonatomic,copy) NSString *equipmentType; //设备型号
@property(nonatomic,copy) NSString *deviceName; //设备名称
@property(nonatomic,copy) NSString *deviceSN; //设备SN
@property(nonatomic,copy) NSString *deviceMacAddress; //蓝牙MAC地址
@property(nonatomic,copy) NSString *deviceGuJianVeersion; //固件版本号
@end
