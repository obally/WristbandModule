//
//  WristStrapModel.h
//  WristStrapDemo
//
//  Created by obally on 17/4/11.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 FirmwareVerison: (null), pairType: 1, sn: (null), identifier: 8B1F4532-2703-4EAA-8A61-C171032AC77A, mac: 08:7C:BE:0F:D0:0F, modelName: Sharkey_B1, name: Sharkey-B1-11017, bleVersion: (null)
 */
@interface WristStrapModel : NSObject
//@property(nonatomic,strong) Sharkey *sharKey;
#if TARGET_IPHONE_SIMULATOR
#else
@property(nonatomic,assign) PAIRTYPE pairType;
@property(nonatomic,strong) NSString *identifier;
@property(nonatomic,strong) NSString *firmwareVerison;
@property(nonatomic,strong) NSString *serialNumber;
@property(nonatomic,strong) NSString *macAddress;
@property(nonatomic,strong) NSString *modelName;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *bleVersion;
@property(nonatomic,strong) NSString *modelType;
@property(nonatomic,assign) BOOL isTelReminder;
@property(nonatomic,assign) BOOL isSmsReminder;
@property(nonatomic,assign) BOOL isConnected; //是否已连接
@property(nonatomic,assign) BOOL isMineDevice; //是否是我连接过的设备
@property(nonatomic,copy) NSString *mobile; //手机号
+ (WristStrapModel *)shareModel; //单例创建
#endif
@end
