//
//  WristStrapCommon.h
//  WristStrapDemo
//
//  Created by obally on 17/4/18.
//  Copyright © 2017年 obally. All rights reserved.
//

//#ifndef WristStrapCommon_h
//#define WristStrapCommon_h
#if TARGET_IPHONE_SIMULATOR
#else
#import "WCDSharkeyFunction.h"
#endif

#import "OBDataManager.h"
#import "NSDate+Extension.h"
#import "NSDate+Reporting.h"
#import <MagicalRecord/MagicalRecord.h>

#define kAPI_WristBaseURL @"http://172.16.15.169:8887"
//#define kAPI_WristBaseURL @"https://bracelet-i.xzxpay.com"
//1.1 绑定手环
#define kAPI_BindDevice kAPI_WristBaseURL"/sportbracelet/bindDeviceData"
//1.2 解绑手环
#define kAPI_unBindDevice kAPI_WristBaseURL"/sportbracelet/unBindDeviceData"
//1.3 验证手环是否能绑
#define kAPI_verifyDevice kAPI_WristBaseURL"/sportbracelet/bindDeviceVerify"
//1.4 上传运动数据
#define kAPI_uploadSportData kAPI_WristBaseURL"/sportbracelet/uploadSportData"
//1.5 上传睡眠数据
#define kAPI_uploadSleepData kAPI_WristBaseURL"/sportbracelet/uploadSleepData"
//1.6 四周运动数据
#define kAPI_querySportFourWeeksData kAPI_WristBaseURL"/sportbracelet/querySportFourWeeksData"
//1.7 四周睡眠数据
#define kAPI_querySleepFourWeeksData kAPI_WristBaseURL"sportbracelet/querySleepFourWeeksData"
//1.8 最近7天睡眠和运动数据
#define kAPI_querySevendayData kAPI_WristBaseURL"/sportbracelet/querySevendayData"
//#endif /* WristStrapCommon_h */

#define HealthMouldeRouter @"SY://HealthMoulde"
#define DeviceManagerMoulde @"SY://DeviceManagerMoulde"
#define BrandTabBarMouleRouter @"SY://BrandTabBar"

#define SYBaseUrl @"SYBaseUrl" //服务器地址
#define SYController @"navigationVC"//当前控制器  push传导航控制器 present传模态视图
#define SYUserToken @"SYUserToken" //用户唯一表示
#define SYUserSchoolNum @"SYUserSchoolNum" //用户学校编号
