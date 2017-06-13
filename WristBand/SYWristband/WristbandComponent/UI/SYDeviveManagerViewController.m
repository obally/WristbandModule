//
//  SYSettingViewController.m
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYDeviveManagerViewController.h"
#import "SYSearchDeviceViewController.h"
#import "SYAlarmClockViewController.h"
#if TARGET_IPHONE_SIMULATOR
#else
@interface SYDeviveManagerViewController ()<WCDSharkeyFunctionDelegate>
{
    MBProgressHUD *hud;
}
@property(nonatomic,strong)WCDSharkeyFunction *shareKey;
@property(nonatomic,strong)WristStrapModel *strapModel; //手环数据
@property(nonatomic,strong)Sharkey *sharKey; //sharekey 设备
/*
    连接状态上半部分跟下半部分都显示  未连接状态只显示下半部分
 */
@property(nonatomic,strong) UIView *topView; // 上半部分到手环管理
@property(nonatomic,strong) UIView *topBrandView; //手环管理View
@property(nonatomic,strong) UIImageView *topImageView; //手环管理View
@property(nonatomic,strong) UILabel *topBrandLabel; //手环名称
@property(nonatomic,strong) UIImageView *topBatteryLevelView; //手环电量
@property(nonatomic,strong) UIButton *topConnectButton; //连接按钮
@property(nonatomic,strong) UILabel *topGrayLabel; //手环名称
@property(nonatomic,strong) UIView *bottomView; // 下半部分  手环的一些设置
@property(nonatomic,strong) UISwitch *telSwitch; //来电提醒按钮
@property(nonatomic,strong) UISwitch *smsSwitch; //来电提醒按钮
@property(nonatomic,strong) UIView *telReminderView; //来电提醒
@property(nonatomic,strong) UIView *smsReminderView; //消息提醒
@property(nonatomic,strong) UIView *alarmClockView; //闹钟View
@property(nonatomic,strong) UIView *updateView; //固件升级View
@property(nonatomic,assign) BOOL isConnect; //手环是否连接

@end
#endif
@implementation SYDeviveManagerViewController
#if TARGET_IPHONE_SIMULATOR
#else
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备管理";
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图frame设置及相关约束
    [self viewframeSet];
    //手环初始化
    self.shareKey = [WCDSharkeyFunction shareInitializationt];
    self.shareKey.delegate = self;
    Sharkey *currentSharkey =  [self.shareKey currentSharkey];
    BLEState bleState = [self.shareKey queryBLEState];
    if (bleState == BLEStateNotReady) {
        //未打开蓝牙
        [MBProgressHUD showError:@"暂未打开蓝牙" toView:self.view];
        self.isConnect = NO;
    }else if(bleState == BLEStateDisconnected|| bleState == BLEStatePoweredOff || bleState == BLEStateUnknown  || bleState == BLEStateUnsupported){
        [MBProgressHUD showError:@"设备暂未连接" toView:self.view];
        self.isConnect = NO;
    } else {
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        //打开蓝牙
        if (currentSharkey && model.isConnected == YES && [model.mobile isEqualToString:userInfo.mobile]) {
            //连接状态
            self.isConnect = YES;
            [self.shareKey queryBatteryLevel];
        } else if (currentSharkey){
            self.isConnect = NO;
            [self.shareKey connectSharkey:currentSharkey];
        }else {
            //未连接状态
            self.isConnect = NO;
            if (model&&[model.mobile isEqualToString:userInfo.mobile]) {
                //有上一次重连
                //自动重连上一次
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = @"正在连接";
                [self requestVerifyDeviceWithWristModel:model];
            }
            
        }
    
    }
     [self controlViewWithShareKeyStatus:self.isConnect];
    

    
}
#pragma mark - 视图、action 添加  frame设置
//根据连接与否来控制视图显示与否
- (void)controlViewWithShareKeyStatus:(BOOL)isConnect
{
    if (self.isConnect) {
        //已连接
        self.topBrandLabel.hidden = NO;
        self.topBatteryLevelView.hidden = NO;
        [self.topConnectButton setTitle:@"断开连接" forState:UIControlStateNormal];
        self.bottomView.hidden = NO;
        WristStrapModel *model = [OBDataManager shareManager].strapModel;
        self.topBrandLabel.text = model.name;
        self.topBrandLabel = [self.topBrandLabel resizeLabelHorizontal];
        self.topBrandLabel.centerX = self.view.centerX;
        self.topBatteryLevelView.left = self.topBrandLabel.right + kWidth(10);
        [self.telSwitch setOn:model.isTelReminder];
        [self.smsSwitch setOn:model.isSmsReminder];
        self.topImageView.image = [UIImage imageNamed:@"sbgl_s1"];
    } else {
        //未连接
        self.topBrandLabel.hidden = YES;
        self.topBatteryLevelView.hidden = YES;
        [self.topConnectButton setTitle:@"点击连接" forState:UIControlStateNormal];
        self.bottomView.hidden = YES;
        self.topImageView.image = [UIImage imageNamed:@"sbgl_s2"];
        
    }
}
- (void)addView
{
    [self addTopView];
    [self addBottomView];
}
- (void)addAction
{
    UITapGestureRecognizer *brandTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(brandTap)];
    [self.topBrandView addGestureRecognizer:brandTap];
    UITapGestureRecognizer *alarmClockTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alarmClockTap)];
    [self.alarmClockView addGestureRecognizer:alarmClockTap];
    UITapGestureRecognizer *updateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateTap)];
    [self.updateView addGestureRecognizer:updateTap];

    [self.telSwitch addTarget:self action:@selector(telSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.smsSwitch addTarget:self action:@selector(smsSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.topConnectButton addTarget:self action:@selector(topConnectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewframeSet
{
    CGFloat height = kHeight(48);
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, kHeight(280));
    self.topImageView.frame = CGRectMake((kScreenWidth - kWidth(50))/2.0, kHeight(15), kWidth(50), kHeight(76));
    self.topBrandLabel.frame = CGRectMake((kScreenWidth - kWidth(200))/2.0, self.topImageView.bottom + kHeight(15), kWidth(200), kHeight(30));
    self.topBatteryLevelView.frame = CGRectMake(self.topBrandLabel.right, self.topBrandLabel.top +kHeight(8), kWidth(9), kHeight(14));
    self.topConnectButton.frame = CGRectMake((kScreenWidth - kWidth(100))/2.0, self.topImageView.bottom + kHeight(60), kWidth(100), kHeight(40));
    self.topGrayLabel.frame = CGRectMake(0, self.topConnectButton.bottom + kHeight(15),kScreenWidth, kHeight(8));
    self.topBrandView.frame = CGRectMake(0, self.topGrayLabel.bottom,kScreenWidth, height);
    self.topView.height = self.topBrandView.bottom;
    
    self.bottomView.frame = CGRectMake(0, self.topView.bottom + kHeight(8),kScreenWidth, kHeight(240));
    self.telReminderView.frame = CGRectMake(0, 0,kScreenWidth, height);
    self.smsReminderView.frame = CGRectMake(0, self.telReminderView.bottom,kScreenWidth, height);
    self.alarmClockView.frame = CGRectMake(0, self.smsReminderView.bottom,kScreenWidth, height);
    self.updateView.frame = CGRectMake(0, self.alarmClockView.bottom,kScreenWidth, height);
    self.bottomView.height = self.updateView.bottom;
    
}
//上半部分视图创建
- (void)addTopView
{
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.topImageView];
    [self.topView addSubview:self.topBrandLabel];
    [self.topView addSubview:self.topBatteryLevelView];
    [self.topView addSubview:self.topConnectButton];
    [self.topView addSubview:self.topGrayLabel];
    self.topBrandView = [self createViewWithImageString:@"tab3_ic_shouh" title:@"手环管理" subTitle:@""];
    [self.topView addSubview:self.topBrandView];
}
//上半部分视图创建
- (void)addBottomView
{
    self.telReminderView =  [self createSwitchViewWithImageString:@"tab3_ic_phone" title:@"来电提醒"];
    self.telSwitch = [self.telReminderView viewWithTag:100];
    self.smsReminderView =  [self createSwitchViewWithImageString:@"tab3_ic_bell" title:@"消息提醒"];
    self.smsSwitch = [self.smsReminderView viewWithTag:100];
    self.alarmClockView = [self createViewWithImageString:@"tab3_ic_clock" title:@"手机闹钟" subTitle:@""];
    self.updateView = [self createViewWithImageString:@"tab3_ic_update" title:@"固件升级" subTitle:@""];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.telReminderView];
    [self.bottomView addSubview:self.smsReminderView];
    [self.bottomView addSubview:self.alarmClockView];
    [self.bottomView addSubview:self.updateView];
    
}
//创建一个带图标 带名字 跟箭头的view
- (UIView *)createViewWithImageString:(NSString *)imageString title:(NSString *)title subTitle:(NSString *)subTitle
{
    CGFloat height = kHeight(48);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), (height - kHeight(25))/2.0, kWidth(25), kHeight(25))];
    imageView.image =  [UIImage imageNamed:imageString];//pro_ic_phone_copy
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + kWidth(17), imageView.top, kWidth(150), kHeight(25))];
    label.text = title;
    label.font = kFont(16.0);
    label.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    [view addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, imageView.top, kScreenWidth - label.right - kWidth(40), kHeight(25))];
    subLabel.text = subTitle;
    subLabel.font = kFont(12.0);
    subLabel.tag = 100;
    subLabel.textAlignment = NSTextAlignmentRight;
    subLabel.textColor = [UIColor colorWithHexString:@"#7B7B7B"];
    [view addSubview:subLabel];
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(subLabel.right + kWidth(17), imageView.top, kWidth(8), kHeight(13))];
    arrowImage.image = [UIImage imageNamed:@"ic_goon"];
    [view addSubview:arrowImage];
    arrowImage.centerY = subLabel.centerY;
    UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height - kHeight(2), kScreenWidth, kHeight(2))];
    grayLabel.backgroundColor = RGBColor(241, 241, 241);
    [view addSubview:grayLabel];
    
    return view;
}
//创建一个带图标 带名字 带开关的视图
- (UIView *)createSwitchViewWithImageString:(NSString *)imageString title:(NSString *)title
{
    CGFloat height = kHeight(48);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(20), (height - kHeight(25))/2.0, kWidth(25), kHeight(25))];
    imageView.image =  [UIImage imageNamed:imageString];//pro_ic_phone_copy
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right + kWidth(17), imageView.top, kWidth(150), kHeight(25))];
    label.text = title;
    label.font = kFont(16.0);
    label.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    [view addSubview:label];
    
    UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth - kWidth(60), (height - kHeight(30))/2.0, kWidth(44), kHeight(30))];
    switchView.tag = 100;
    switchView.centerY = imageView.centerY;
    [view addSubview:switchView];
    
    UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height - kHeight(2), kScreenWidth, kHeight(2))];
    grayLabel.backgroundColor = RGBColor(241, 241, 241);
    [view addSubview:grayLabel];
    return view;
}

#pragma mark -Actions
- (void)telSwitchAction:(UISwitch *)telSwitch
{
    WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
    model.isTelReminder = telSwitch.isOn;
    [OBDataManager shareManager].strapModel = model;
    [self setReminderFlag];
}
- (void)smsSwitchAction:(UISwitch *)smsSwitch
{
    WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
    model.isSmsReminder = smsSwitch.isOn;
    [OBDataManager shareManager].strapModel = model;
    [self setReminderFlag];
}
- (void)setReminderFlag
{
    int flag = 0;
    WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
    SYLoginInfoModel *infoModel = [SYUserDataManager manager].userLoginInfoModel;
    if ([model.mobile isEqualToString:infoModel.mobile]) {
        flag = model.isTelReminder?ReminderFlagPushIncomingCall:0;
        flag = model.isSmsReminder?flag|ReminderFlagPushSms:flag;
    }
    [self.shareKey setNotifyRemoteReminderFlag:flag];
}
- (void)brandTap
{
    SYSearchDeviceViewController *searchDeviceVC = [[SYSearchDeviceViewController alloc]init];
    [self.navigationController pushViewController:searchDeviceVC animated:YES];
}
//闹钟设置
- (void)alarmClockTap
{
    SYAlarmClockViewController *alarmClock = [[SYAlarmClockViewController alloc]init];
    [self.navigationController pushViewController:alarmClock animated:YES];
}
//固件升级
- (void)updateTap
{
    
}
//连接
- (void)topConnectButtonAction:(UIButton *)button
{
    BLEState state = [self.shareKey queryBLEState];
    //重新扫描
    if (state == BLEStateNotReady || state == BLEStatePoweredOff || state == BLEStateUnknown  || state == BLEStateUnsupported) {
        //未打开蓝牙
        [MBProgressHUD showSuccess:@"请打开蓝牙" toView:self.view];
        return;
        
    }
    WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
    SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
    if (model&&[model.mobile isEqualToString:userInfo.mobile]) {
        Sharkey *sharKey =  [self lastSharkey:model];
        if (sharKey) {
            //连接的是上一次连接的设备
            if ([button.titleLabel.text isEqualToString:@"断开连接"]) {
                //断开连接
                [self.shareKey disconnectSharkey:sharKey];
            } else {
                //连接
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = @"正在连接";
                [self.shareKey connectSharkey:sharKey];
            }
            
        }
    } else {
        SYSearchDeviceViewController *searchDevice = [[SYSearchDeviceViewController alloc]init];
        [self.navigationController pushViewController:searchDevice animated:YES];
    }
   
}
#pragma mark - 手环连接流程
- (void)requestVerifyDeviceWithWristModel:(WristStrapModel *)model
{
    if (![SYUserDataManager manager].userLoginInfoModel) {
        //暂未登录
        [MBProgressHUD showError:@"请先登录" toView:self.view];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"bindDeviceVerify" forKey:@"tradeId"];
        [params setObject:model.macAddress forKey:@"mac"];
        [params setObject:model.firmwareVerison.length > 0?model.firmwareVerison:@"1.0" forKey:@"firmwareVersion"];
        [params setObject:[SYUserDataManager manager].userLoginInfoModel.token forKey:@"token"];
        [OBDataRequest requestWithURL:kAPI_verifyDevice params:params httpMethod:@"POST" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionblock:^(id  _Nonnull result) {
            if ([result[@"success"] boolValue]) {
                if ([result[@"data"][@"isEnable"] boolValue]) {
                    //设备可以连
                    Sharkey *sharKey =  [self lastSharkey:model];
                    if (sharKey) {
                        //连接的是上一次连接的设备
                        [self.shareKey connectSharkey:sharKey];
                    }
                    
                } else {
                    //设备不可以连
                    [MBProgressHUD showSuccess:result[@"resultMsg"] toView:self.view];
                    [hud hideAnimated:YES];
                }
                
            } else {
                //请求失败
                [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
                [hud hideAnimated:YES];
            }
        } failedBlock:^(id  _Nonnull error) {
            
        }];
        
    }
}
- (void)requestBindDeviceWithWristModel:(WristStrapModel *)model
{
    if (![SYUserDataManager manager].userLoginInfoModel) {
        //暂未登录
        [MBProgressHUD showError:@"请先登录" toView:self.view];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"bindDeviceData" forKey:@"tradeId"];
        [params setObject:model.macAddress?model.macAddress:@"" forKey:@"deviceSN"];
        [params setObject:model.name?model.name:@"" forKey:@"deviceName"];
        [params setObject:model.macAddress?model.macAddress:@"" forKey:@"deviceMacAddress"];
        [params setObject:model.firmwareVerison?model.firmwareVerison:@"" forKey:@"deviceVersion"];
        [params setObject:[SYUserDataManager manager].userLoginInfoModel.token forKey:@"token"];
        [OBDataRequest requestWithURL:kAPI_BindDevice params:params httpMethod:@"POST" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionblock:^(id  _Nonnull result) {
            if (![result[@"success"] boolValue]) {
                //请求失败
                NSLog(@"----[NSThread currentThread]----%@",[NSThread currentThread]);
                [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
            } else {
                
            }
        } failedBlock:^(id  _Nonnull error) {
            
        }];
        
    }
    
}

//保存最近一次连接设备
- (Sharkey *)lastSharkey:(WristStrapModel *)model
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:model.pairType] forKey:SHARKEYPAIRTYPE_KEY];
    [dic setObject:model.identifier forKey:SHARKEYIDENTIFIER_KEY];
    [dic setObject:model.macAddress forKey:SHARKEYMACADDRESS_KEY];
    [dic setObject:model.modelName forKey:SHARKEYMODELNAME_KEY];
    Sharkey *sharKey =  [self.shareKey retrieveSharkey:dic];
    return sharKey;
}
//将设备信息转成模型
- (WristStrapModel *)modelWithSharKey:(Sharkey *)intactSharkey
{
    WristStrapModel *model = [[WristStrapModel alloc]init];
    model.pairType = intactSharkey.pairType;
    model.identifier = intactSharkey.identifier;
    model.firmwareVerison = intactSharkey.firmwareVersion;
    model.serialNumber = intactSharkey.serialNumber;
    model.macAddress = intactSharkey.macAddress;
    model.modelName = intactSharkey.modelName;
    model.name = intactSharkey.name;
    model.bleVersion = intactSharkey.bleVersion;
    return model;
}
//保存最近一次连接设备模型数据
- (void)saveLastStrapModel:(Sharkey *)intactSharkey
{
    WristStrapModel *oldmodel = [OBDataManager shareManager].strapModel;
    WristStrapModel *model = [self modelWithSharKey:intactSharkey];
    SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
    if ([model.identifier isEqualToString:oldmodel.identifier]) {
        //是之前  保存之前的设置数据
        oldmodel.isMineDevice = YES;
        oldmodel.isConnected = YES;
        oldmodel.mobile = userInfo.mobile;
        [OBDataManager shareManager].strapModel = oldmodel;
    } else {
        model.isMineDevice = YES;
        model.isConnected = YES;
        model.mobile = userInfo.mobile;
        [OBDataManager shareManager].strapModel = model;
    }
   
    
}
#pragma mark - 手环代理方法 WCDSharkeyFunctionDelegate
- (void)WCDQueryBatteryLevelCallBack:(BOOL)flag level:(NSUInteger)level
{
    if(flag) {
        if (level == 0) {
            self.topBatteryLevelView.image = [UIImage imageNamed:@"ic_battery_0"];
        } else if (level == 1) {
            self.topBatteryLevelView.image = [UIImage imageNamed:@"ic_battery_1"];
        } else if (level == 2) {
            self.topBatteryLevelView.image = [UIImage imageNamed:@"ic_battery_2"];
        } else if (level == 3) {
            self.topBatteryLevelView.image = [UIImage imageNamed:@"ic_battery_3"];
        } else if (level == 4) {
            self.topBatteryLevelView.image = [UIImage imageNamed:@"ic_battery_4"];
        }
    }
    
   
}
- (void)WCDBLERealStateCallBack:(BLEState)bleState
{
    if (bleState == BLEStatePoweredOn) {
        //蓝牙打开状态
        [MBProgressHUD showSuccess:@"重新连接" toView:self.view];
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model&&[model.mobile isEqualToString:userInfo.mobile]){
            //有上一次重连
            //自动重连上一次  请求服务器能否连
            [self requestVerifyDeviceWithWristModel:model];
        }
        //开始扫描手环
        NSLog(@"-------BLEStatePoweredOn--");
    } else if (bleState == BLEStateDisconnected) {
        NSLog(@"-------BLEStateDisconnected--");
        [MBProgressHUD showError:@"设备暂未连接" toView:self.view];
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model&&[model.mobile isEqualToString:userInfo.mobile]){
            model.isConnected = NO;
            [OBDataManager shareManager].strapModel = model;
        }
        self.isConnect = NO;
        [self controlViewWithShareKeyStatus:self.isConnect];
    }
}
- (void)WCDConnectSuccessCallBck:(BOOL)flag sharkey:(Sharkey *)intactSharkey
{
    hud.label.text = @"连接成功";
    //保存设备模型数据
    [self saveLastStrapModel:intactSharkey];
    
    [hud hideAnimated:YES];
    [self.shareKey setqueryRemotePairStatus];
    [self.shareKey queryBatteryLevel];
    self.isConnect = YES;
    [self controlViewWithShareKeyStatus:self.isConnect];
    //闹钟设置
    [self setReminderFlag];
    //告诉服务器绑定成功
    WristStrapModel *model = [self modelWithSharKey:intactSharkey];
    [self requestBindDeviceWithWristModel:model];
    NSLog(@"-----------连接成功");

}
- (void)WCDShackSetPhoneSuccessCallBack:(NSData *)flag
{
//    [MBProgressHUD showError:@"设置" toView:self.view];
}
#pragma mark - getter and setter

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIImageView *)topImageView
{
    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"sbgl_s1"];
    }
    return _topImageView;
}
- (UILabel *)topBrandLabel
{
    if (_topBrandLabel == nil) {
        _topBrandLabel = [[UILabel alloc]init];
        _topBrandLabel.text = @"Synjones Bracelect";
        _topBrandLabel.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
        _topBrandLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topBrandLabel;
}
- (UIImageView *)topBatteryLevelView
{
    if (_topBatteryLevelView == nil) {
        _topBatteryLevelView = [[UIImageView alloc]init];
//        _topBatteryLevelView.backgroundColor = RandomColor;
    }
    return _topBatteryLevelView;
}
- (UIButton *)topConnectButton
{
    if (_topConnectButton == nil) {
        _topConnectButton = [[UIButton alloc]init];
        [_topConnectButton setTitle:@"断开连接" forState:UIControlStateNormal];
        [_topConnectButton setTitleColor:[UIColor colorWithHexString:@"#4D4D4D"] forState:UIControlStateNormal];
        _topConnectButton.titleLabel.font = kFont(16.0);
        _topConnectButton.layer.masksToBounds = YES;
        _topConnectButton.layer.cornerRadius = 24;
        _topConnectButton.layer.borderColor = [UIColor colorWithHexString:@"#71CBE5"].CGColor;
        _topConnectButton.layer.borderWidth = 2;
    }
    return _topConnectButton;
}
- (UILabel *)topGrayLabel
{
    if (_topGrayLabel == nil) {
        _topGrayLabel = [[UILabel alloc]init];
        _topGrayLabel.backgroundColor = RGBColor(241, 241, 241);
    }
    return _topGrayLabel;
}
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
#endif
@end

