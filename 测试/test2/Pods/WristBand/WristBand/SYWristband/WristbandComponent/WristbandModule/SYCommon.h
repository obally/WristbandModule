//
//  SYCommon.h
//  SYWristband
//
//  Created by obally on 2017/6/13.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import <IQKeyboardManager/IQUITextFieldView+Additions.h>
#import <IQKeyboardManager/IQUIScrollView+Additions.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <IQKeyboardManager/IQUIView+IQKeyboardToolbar.h>
#import <HandyFrame/UIView+LayoutMethods.h>
#import <MGJRouter/MGJRouter.h>
#import "WCDSharkeyFunction.h"
#import "SYBrandTabBarMoulde.h"
#import "SYHealthMoulde.h"
#import "SYDeviceManagerMoulde.h"
#define HealthMouldeRouter @"SY://HealthMoulde"
#define DeviceManagerMoulde @"SY://DeviceManagerMoulde"
#define BrandTabBarMouleRouter @"SY://BrandTabBar"

#define SYBaseUrl  @"SYBaseUrl"; //服务器地址
#define SYController  @"navigationVC"; //当前控制器  push传导航控制器 present传模态视图
#define SYUserToken  @"SYUserToken"; //用户唯一表示
#define SYUserSchoolNum  @"SYUserSchoolNum"; //用户学校编号
