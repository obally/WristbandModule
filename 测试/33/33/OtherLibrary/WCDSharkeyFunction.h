//
//  SharkeySDKWithiOS.h
//  SharkeySDKWithiOS
//
//  Created by liangjie on 16/3/16.
//  Copyright © 2016年 liangjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
@class AppDelegate;

/**
 *  交易记录
 */
@interface TradingRecordModel : NSObject
@property (strong, nonatomic) NSDate *date; // 交易日期
@property (nonatomic) int type;             // 交易方式：1代表充值   2代表消费
@property (nonatomic) uint32_t money;       // 交易金额, 分为单位
@end

typedef NS_ENUM(NSInteger, PAIRTYPE) {
    PAIRCODE = 0,   // 配对码方式
    TAPACTION,      // 敲击动作方式
};


/**
 *  找回sharkey设备时, 参数（NSDictionary）中的key
 */
extern NSString *const SHARKEYPAIRTYPE_KEY;
extern NSString *const SHARKEYIDENTIFIER_KEY;
extern NSString *const SHARKEYMACADDRESS_KEY;
extern NSString *const SHARKEYMODELNAME_KEY;

/**
 *  sharkey设备
 */
@interface Sharkey : NSObject
@property (nonatomic, assign, readonly) PAIRTYPE pairType; // 配对形式
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSString *serialNumber; // 序列号
@property (nonatomic, strong, readonly) NSString *firmwareVersion;// 固件版本
@property (nonatomic, strong, readonly) NSString *macAddress;   // mac地址
@property (nonatomic, strong, readonly) NSString *bleVersion;   // 蓝牙协议版本号
@property (nonatomic, strong, readonly) NSString *modelName;   // 产品Name
@property (nonatomic, strong, readonly) NSString *name;
@end

/**
 *  睡眠数据信息
 */
@interface SleepDataInfo : NSObject
@property (nonatomic, assign) NSUInteger startMinute;
@property (nonatomic, assign) NSUInteger deepMinute;
@property (nonatomic, assign) NSUInteger lightMinute;
@property (nonatomic, assign) NSUInteger totalMinute;
@property (nonatomic, strong) NSArray *sectionInfos; //SleepSectionInfo
@end
/**
 *  睡眠段信息
 */
@interface SleepSectionInfo : NSObject
@property (nonatomic, assign) NSUInteger startMinute;
@property (nonatomic, assign) NSUInteger endMinute;
@property (nonatomic, assign) NSUInteger deepMinute;
@end

// sharkey类型
typedef NS_OPTIONS(NSUInteger, SHARKEYTYPE) {
    TYPENONE   = 0,
    SHARKEYW1  = 1 << 0,
    SHARKEYB1  = 1 << 1,
    SHARKEYB1S = 1 << 2,
    SHARKEYB2  = 1 << 3,
    SHARKEYB3  = 1 << 4,
    SHARKEYGF = 1 << 5,
    SHARKEYALL = (SHARKEYW1 |
                  SHARKEYB1 |
                  SHARKEYB1S |
                  SHARKEYB2 |
                  SHARKEYB3 |
                  SHARKEYGF),
};
/**
 *  系统通知标识
 */
typedef NS_ENUM(NSInteger, ReminderFlagMask) {
    ReminderFlagPushIncomingCall = 1 << 0UL,//电话通知
    ReminderFlagPushSms          = 1 << 1UL,//消息通知
    ReminderFlagPushReminders    = 1 << 2UL,//事件通知
};

typedef NS_ENUM(NSInteger, BLEState) {
    BLEStateUnknown = 0,
    BLEStateNotReady,
    BLEStateUnsupported,
    BLEStateUnauthorized,
    BLEStatePoweredOff,
    BLEStatePoweredOn,
    BLEStateScaning,
    BLEStateStopScan,
    BLEStateDiscoverPeripheral,
    BLEStateDiscoverServicesError,
    BLEStateDiscoverCharacteristicsError,
    BLEStateDisconnected = 11,
    BLEStateConnecting,
    BLEStateConnected = 13,
    BLEStateConnectFail,
};

typedef NS_ENUM(NSInteger, SharkeyState) {
    SharkeyStateDisconnected = 0,
    SharkeyStateConnecting,
    SharkeyStateConnected,
    SharkeyStateDisconnecting NS_AVAILABLE(NA, 9_0),
} NS_AVAILABLE(NA, 7_0);


//闹钟是否有效
typedef NS_ENUM(NSInteger, AlarmClockState) {
    AlarmClockStateDisable = 0,
    AlarmClockStateEnable  = 1,
};
//闹钟循环规则
typedef NS_ENUM(NSInteger, AlarmClockCycleMask) {
    AlarmClockOnlyOnce      = 0,
    AlarmClockMondayMask    = 0x1,
    AlarmClockTuesdayMask   = 0x2,
    AlarmClockWednesdayMask = 0x4,
    AlarmClockThursdayMask  = 0x8,
    AlarmClockWorkDayMask   = 0x1F,
    AlarmClockSaturdayMask  = 0x20,
    AlarmClockSundayMask    = 0x40,
    AlarmClockFridayMask    = 0x10,
    AlarmClockWeekEndMask   = 0x60,
    AlarmClockEveryDay      = 0x7F,
};

@interface AlarmClockData : NSObject <NSCoding>
@property (nonatomic, readwrite) NSInteger enable; // AlarmClockState
@property (nonatomic, readwrite) NSInteger hour;
@property (nonatomic, readwrite) NSInteger minute;
@property (nonatomic, readwrite) NSInteger cycle; // AlarmClockCycleMask

@end

/**
 *  sharkey睡眠数据采集频率
 */
typedef NS_ENUM(NSInteger, SleepDataGatherRate) {
    oneMinuteRate,
    fiveMinuteRate,
};

/**
 *  蓝牙通道
 */
typedef NS_ENUM(NSInteger, ChannelOptions) {
    Fast = 0,
    Defer,
};


// SharkeySentDataResult
typedef NS_ENUM(NSInteger, SharkeySentDataResult) {
    SentResultSuccess = 0,
    SentResultTimeout,
    SentResultTerminated,
};

// 绑定设备与解绑设备响应结果
typedef NS_ENUM(NSInteger, BindorUnBoundDeviceResultCode) {
    Succeed,    // 成功
    Fail,       // 失败
    BeBound,    // 已被他人绑定
};

/**
 *  WCDSharkeyFunctionDelegate
 */
@protocol WCDSharkeyFunctionDelegate <NSObject>
@optional
- (void)WCDSharkeyScanCallBack:(Sharkey *)crippleSharkey;
- (void)WCDBLERealStateCallBack:(BLEState)bleState;
- (void)WCDShackHandSuccessCallBack:(Sharkey *)crippleSharkey;
- (void)WCDPairCodeSendSuccessCallBack;
- (void)WCDTapPairSendSuccessCallBack;
- (void)WCDSecurityPairCodeSendSuccessCallBack;
- (void)WCDConnectSuccessCallBck:(BOOL)flag sharkey:(Sharkey *)intactSharkey;
- (void)WCDSharkeyScanStop;
- (void)WCDSharkeyDidSendFault:(SharkeySentDataResult)result;
- (void)WCDQueryBatteryLevelCallBack:(BOOL)flag level:(NSUInteger)level;
- (void)WCDQueryCityCodeCallBack:(BOOL)flag cityCode:(NSNumber *)cityCode;
- (void)WCDPedometerDate:(NSDate *)date Count:(NSInteger)count Minute:(NSInteger)minute;
- (void)WCDRunPedometerDate:(NSDate *)date Count:(NSInteger)count Minute:(NSInteger)minute;    //计步跑步数据
- (void)WCDTotalPedometerDate:(NSDate *)date Count:(NSInteger)count Minute:(NSInteger)minute;    //计步总步数据
- (void)WCDQuerySleepDataFromSharkeyCallBack:(NSUInteger)startMinute rawData:(NSData *)rawData gatherRate:(SleepDataGatherRate)gatherRate;
- (void)WCDShackSetPhoneSuccessCallBack:(NSData*)flag;
- (void)WCDShackSentANCSCallBack:(Byte)flag;
- (void)WCDSharkeyRespond:(NSDictionary *)respondInfo;
- (void)WCDShackSetStepTargetCallBack:(NSData*)data;
- (void)WCDShackSentNFCCallBack:(NSData*)data;
- (void)WCDModifyDeviceNameCallBack:(Sharkey *)newSharkey;
- (void)WCDAlockTimeRespond:(BOOL)flag;
@end


/**
 *  APDU相关回调块
 *
 *  @param result result
 */
typedef void(^APDUChannelBlack)(BOOL result);
typedef void(^APDUCommandBlack)(BOOL result, NSData *resultData, NSData *respondData);
typedef void(^APDUCommandsBlack)(BOOL result, NSArray *respondDatas);

/**
 *  
 *
 *  @param result
 */
typedef void (^BindDeviceResult)(BindorUnBoundDeviceResultCode result);
typedef void (^QueryBoundDevicesResult)(NSArray *devices);
typedef void (^QueryBalanceBlockHandler)(BOOL flag, int balance);
typedef void (^QueryRecordsBlockHandler)(BOOL flag, NSArray *records);
typedef void (^QueryCardNumberBlockHandler)(BOOL flag, NSString *cardNumber);

/**
 *  WCDSharkeyFunction
 */
@interface WCDSharkeyFunction : NSObject
@property (nonatomic, weak) id<WCDSharkeyFunctionDelegate> delegate;
@property (nonatomic, readonly) SharkeyState sharkeyState;
@property (nonatomic, readonly) BLEState bleState;

/**
 *  配置SDK的执行环境
 *
 *  @param appDelegate
 *  @param flag         YES: 正式环境
 *                       NO: 测试环境
 */
+ (void)configuration:(id<UIApplicationDelegate>)appDelegate isRelease:(BOOL)flag;

/**
 *  初始化
 *
 *  @return WCDSharkeyFunction对象
 */
+ (instancetype)shareInitializationt;

/**
 *  通过sharkey信息找回sharkey设备
 *
 *  @param sharkeyInfo sharkeyInfo必须包涵上面提到的所有Key
 *
 *  @return sharkey对象
 */
- (Sharkey *)retrieveSharkey:(NSDictionary *)sharkeyInfo;

/**
 *  扫描sharkey
 *
 *  @param sharkeyType 扫描类型
 */
- (void)scanWithSharkeyType:(SHARKEYTYPE)sharkeyType;

/**
 *  停止扫描
 */
- (void)stopScan;

/**
 *  直接连接sharkey设备, 需要有sharkey相关信息
 *
 *  @param sharkey  sharkey对象, 需要包含序列号信息
 */
- (void)connectSharkey:(Sharkey *)sharkey;

/**
 *  第一次绑定sharkey, 需要配对步骤
 *
 *  @param sharkey sharkey对象
 */
- (void)connectSharkeyNeedPair:(Sharkey *)sharkey;
/**
 *  配对步骤
 *
 *  @param sharkey sharkey对象
 */
- (void)pairToSharkey:(Sharkey *)sharkey;

/**
 *  验证配对码是否正确
 *
 *  @param pairCode pairCode
 *
 */
- (void)verifyPairCode:(NSString *)pairCode;

/**
 *  断开连接
 */
- (void)disconnectSharkey:(Sharkey *)sharkey;

/**
 *  查询走步
 *
 *  @param numberOfDays 传值范围(d1~d7)
 */
- (void)updatePedometerDataFromRemoteWalkNumberOfDays:(Byte)numberOfDays;

/**
 *  查询跑步
 *
 *  @param numberOfDays 传值范围(e1~e7)
 */
- (void)updatePedometerDataFromRemoteRunNumberOfDays:(Byte)numberOfDays;

/**
 *  查询总步
 *
 *  @param numberOfDays 传值范围(01~07)
 */
- (void)updatePedometerDataFromRemoteTotalNumberOfDays:(Byte)numberOfDays;

/**
 *  查询sharkey状态
 *
 *  @return SharkeyState
 */
- (SharkeyState)querySharkeyState;

/**
 查询BLE状态
 
 @return BLEState
 */
- (BLEState)queryBLEState;

/**
 *  当前连接的sharkey对象
 *
 *  @return sharkey对象
 */
-(Sharkey *)currentSharkey;

/**
 *  查询电量值
 */
- (void)queryBatteryLevel;

/**
 *  查询城市代码
 */
- (void)queryCityCode;

/**
 *  计算走步公里
 *
 *  @param height  身高(CM)
 *  @param numStep 走步步数
 *
 *  @return 公里数
 */
- (CGFloat)getDistanceWalk:(NSInteger)height numStep:(NSInteger)numStep;

/**
 *  计算跑步公里
 *
 *  @param height  身高(CM)
 *  @param numStep 跑步步数
 *
 *  @return 公里数
 */
- (CGFloat)getDistanceRun:(NSInteger)height numStep:(NSInteger)numStep;

/**
 *  计算总公里 (用于设置目标步数时使用)
 *
 *  @param height  身高(CM)
 *  @param numStep 总步数
 *
 *  @return 公里数
 */
- (CGFloat)getDistanceAll:(NSInteger)height numStep:(NSInteger)numStep;

/**
 * 计算走步卡路里
 *
 * @param distance  走步公里
 * @param weight 体重(kg)
 *
 * @return 千卡
 */
- (CGFloat)getkCalWalk:(CGFloat)distance weight:(NSInteger)weight;

/**
 * 计算跑步卡路里
 *
 * @param distance  跑步公里
 * @param weight 体重(kg)
 *
 * @return 千卡
 */
- (CGFloat)getkCalRun:(CGFloat)distance weight:(NSInteger)weight;

/**
 *  计算总卡路里 (用于设置目标步数时使用)
 *
 * @param distance  总公里
 *  @param weight 体重(kg)
 *
 *  @return 千卡
 */
- (CGFloat)getKcal:(CGFloat)distance weight:(NSInteger)weight;

/**
 *  切换快慢速通道
 *
 *  @param option
 *  @param blockHandler
 */
- (void)switchBLEChannel:(ChannelOptions)option block:(APDUChannelBlack)blockHandler;

/**
 *  打开APDU通道
 */
- (void)openAPDUChannel:(APDUChannelBlack)apduChannelBlack;

/**
 *  关闭APDU通道
 */
- (void)closeAPDUChannel:(APDUChannelBlack)apduChannelBlack;
/**
 *  发送单条APDU指令
 */
- (void)sendAPDUCommand:(NSData *)command apduCommandBlack:(APDUCommandBlack)apduCommandBlack;
/**
 *  发送单条APDU指令
 *
 *  @param command          数据
 *  @param second           超时时间（单位：秒）
 *  @param apduCommandBlack 回调块
 */
- (void)sendAPDUCommand:(NSData *)command timeout:(NSUInteger)second apduCommandBlack:(APDUCommandBlack)apduCommandBlack;
/**
 *  批量发送APDU指令
 *
 *  @param commands          commands
 *  @param apduCommandsBlack apduCommandsBlack
 */
- (void)sendAPDUCommands:(NSArray *)commands apduCommandsBlack:(APDUCommandsBlack)apduCommandsBlack;
/**
 *  批量发送APDU指令
 *
 *  @param commands          数据
 *  @param second            超时时间（单位：秒)
 *  @param apduCommandsBlack 回调块
 */
- (void)sendAPDUCommands:(NSArray *)commands timeout:(NSUInteger)second apduCommandsBlack:(APDUCommandsBlack)apduCommandsBlack;
/**
 *  设置电话、短信、事件提醒
 */
- (void)setNotifyRemoteReminderFlag:(NSUInteger)reminderFlag ;
/**
 *  发起ancs配对请求指令
 */
- (void)setqueryRemotePairStatus;
/**
 *  设置语言类别langId = 1; // English         langId = 0; // Chinese
 */
- (void)setNotifyRemoteToChangeLanguage:(Byte)langId ;

/**
 *  @查询sharkey的睡眠数据信息
 */
- (void)querySleepDataFromSharkey;

/**
 *  解析睡眠数据
 *
 *  @param startMinute startMinute
 *  @param rawData     rawData
 *  @param gatherRate  gatherRate
 *
 *  @return SleepDataInfo对象
 */
- (SleepDataInfo *)analyseSleep:(NSUInteger)startMinute data:(NSData *)rawData gatherRate:(SleepDataGatherRate)gatherRate;

/**
 *  设置计步目标
 *
 *  @param targetStepNumber 目标步数
 */
- (void)setqueryRemoteStepTarget:(uint32_t)targetStepNumber;

/** 
 * 时间设置同步
 */
- (void)setTimeSynchronization;
/**
 * 设置NFC参数
 * AMS3922版本： city “00”深圳通 “01” 其它； SKY1321  city “00”:深圳通 “01
 * datain 参数数据 AMS3922版本：datain为17个长度 SKY1321 ：datain为8个长度
 * datain 0x10 查询，0x11写入
 */
-(void)setNFCParpm:(NSData*)datain;

/**
 *  修改设备名称
 *
 *  @param newName 新的设备名称, 最长15个字节
 */
- (void)modifyDeviceName:(NSString *)newName;
/**
 *  设置闹钟
 *
 *  @param 闹钟数据, AlarmClockData集合
 */
- (void)setAlockTime:(NSArray*)timearr;

/**
 *  绑定设备
 *
 *  @param sharkey      sharkey对象
 *  @param phone        用户名(手机号)
 *  @param blockHandler 绑定结果回调
 */
- (void)bindSharkeyDevice:(Sharkey *)sharkey phone:(NSString *)phone block:(BindDeviceResult)blockHandler;
/**
 *  解除绑定
 *
 *  @param sharkey      sharkey对象
 *  @param phone        用户名(手机号)
 *  @param blockHandler 绑定结果回调
 */
- (void)unBindSharkeyDevice:(Sharkey *)sharkey phone:(NSString *)phone block:(BindDeviceResult)blockHandler;
/**
 *  查询用户已经绑定的设备
 *
 *  @param phone        用户名
 *  @param blockHandler 结果块
 */
- (void)queryBoundSharkeyDevices:(NSString *)phone block:(QueryBoundDevicesResult)blockHandler;
/**
 *  查询余额, 单位：分
 *
 *  @param cityCode     查询城市代码返回的citycode
 *  @param blockHandler 结果块
 */
- (void)queryBalanceWithCityCode:(NSNumber *)cityCode handler:(QueryBalanceBlockHandler)blockHandler;
/**
 *  查询交易记录
 *
 *  @param cityCode     查询城市代码返回的citycode
 *  @param blockHandler 结果块
 */
- (void)queryTradingRecordsWithCityCode:(NSNumber *)cityCode handler:(QueryRecordsBlockHandler)blockHandler;
/**
 *  查询卡号
 *
 *  @param cityCode     查询城市代码返回的citycode
 *  @param blockHandler 结果块
 */
- (void)queryLoginCardNumberWithCityCode:(NSNumber *)cityCode handler:(QueryCardNumberBlockHandler)blockHandler;

/**
 *  获取SDK版本号
 *
 *  @return
 */
+ (NSString *)fetchSDKVersion;


@end
