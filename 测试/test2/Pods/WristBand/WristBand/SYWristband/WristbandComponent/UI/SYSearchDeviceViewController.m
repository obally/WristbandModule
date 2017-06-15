//
//  SYSearchDeviceViewController.m
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYSearchDeviceViewController.h"
//#import "WristStrapModel.h"
#import "SYScanedDevicesCell.h"
#import "SYConnectReminderView.h"
#import "SYTabBarViewController.h"
#import "SYDeviceInfoViewController.h"
//#import "SYUserDataManager.h"
#if TARGET_IPHONE_SIMULATOR
#else
@interface SYSearchDeviceViewController ()<WCDSharkeyFunctionDelegate,UITableViewDelegate,UITableViewDataSource,SYScanedDevicesCellDelegate,SYConnectReminderViewDelegate>
@property(nonatomic,strong)WCDSharkeyFunction *shareKey;
@property(nonatomic,strong)WristStrapModel *strapModel; //手环数据
@property(nonatomic,strong)Sharkey *sharKey; //sharekey 设备
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong)UIButton *searchReminderButton; //搜索状态提示语句
@property(nonatomic,strong)UILabel *confirmLabel; //提醒label
@property(nonatomic,strong)UILabel *label; //可用设备
@property(nonatomic,strong) UITableView *tableView; //设备列表
@property(nonatomic,strong) NSMutableArray *scanDevices; //扫描到的设备 二维数组
@property(nonatomic,strong) NSMutableArray *otherDevices; //扫描到的设备 其他设备
@property(nonatomic,strong) NSMutableArray *mineDevices; //扫描到的设备 我的设备
@property(nonatomic,strong) NSIndexPath *currentIndexPatch; //当前选择的indexpatch
@property(nonatomic,strong) SYConnectReminderView *reminderView; //敲击提示视图

@end
#endif
@implementation SYSearchDeviceViewController
#if TARGET_IPHONE_SIMULATOR
#else

#pragma mark -  生命周期 life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFirst) {
        [self setNavItem];
    }
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    self.title = @"绑定智能手环";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //手环初始化
    self.shareKey = [WCDSharkeyFunction shareInitializationt];
    self.shareKey.delegate = self;
    Sharkey *currentSharkey =  [self.shareKey currentSharkey];
    if (currentSharkey) {
        //连接状态
        //tableView数据源
        [self setTableViewData];
        [self.tableView reloadData];
    } else {
        //未连接状态
        //一些自动搜索跟连接
        [self someBleConnect];
    }
    //视图frame设置及相关约束
    [self viewframeSet];
    
    
    
}
//右侧导航按钮
- (void)setNavItem
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction)];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [rightButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.searchReminderButton];
    [self.view addSubview:self.confirmLabel];
//    [self.view addSubview:self.label];
    [self.view addSubview:self.tableView];
}
- (void)addAction
{
    [self.searchReminderButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewframeSet
{
    self.imageView.frame = CGRectMake(kWidth(92), kHeight(43), kWidth(192), kHeight(118));
    self.searchReminderButton.frame = CGRectMake(0, self.imageView.bottom + kHeight(9), kScreenWidth, kHeight(30));
    self.confirmLabel.frame = CGRectMake(0, self.searchReminderButton.bottom + kHeight(26), kScreenWidth, kHeight(30));
//    self.label.frame = CGRectMake(kWidth(15), self.confirmLabel.bottom + kHeight(26), kScreenWidth, kHeight(45));
    self.tableView.frame = CGRectMake(0, self.confirmLabel.bottom, kScreenWidth, self.view.height - self.confirmLabel.bottom - 64);
    self.imageView.centerX = self.searchReminderButton.centerX = self.confirmLabel.centerX = self.view.centerX;
}
#pragma mark -  按钮点击 Actions
//跳过
- (void)nextAction
{
     [UIApplication sharedApplication].delegate.window.rootViewController = [[SYTabBarViewController alloc] init];
}
- (void)searchAction:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"重新搜索"]) {
        BLEState state = [self.shareKey queryBLEState];
        //重新扫描
        if (state == BLEStateNotReady || state == BLEStatePoweredOff || state == BLEStateUnknown  || state == BLEStateUnsupported) {
            //未打开蓝牙
            [MBProgressHUD showSuccess:@"请打开蓝牙" toView:self.view];
            
        } else {
            //已经打开蓝牙
//            if (self.scanDevices.count > 0) {
//                [self.scanDevices removeAllObjects];
//                [self.mineDevices removeAllObjects];
//                [self.otherDevices removeAllObjects];
//            }
            self.mineDevices = [self getMineDevices];
            if (self.scanDevices.count > 0) {
                [self.scanDevices removeAllObjects];
            }
            if (self.mineDevices.count > 0) {
                [self.scanDevices addObject:self.mineDevices];
            }
            if (self.otherDevices.count > 0) {
                [self.otherDevices removeAllObjects];
            }
            [self.shareKey scanWithSharkeyType:SHARKEYALL];
        }
    }
}
#pragma mark - private Methods 私有方法
- (void)someBleConnect
{
    //tableView数据源
    [self setTableViewData];
    [self.tableView reloadData];
    BLEState state = [self.shareKey queryBLEState];
    if (state == BLEStateNotReady || state == BLEStatePoweredOff || state == BLEStateUnknown  || state == BLEStateUnsupported) {
        //未打开蓝牙
        [MBProgressHUD showError:@"暂未打开蓝牙" toView:self.view];
        [self.searchReminderButton setTitle:@"重新搜索" forState:UIControlStateNormal];
    } else {
        //已经打开蓝牙
       
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model && [model.mobile isEqualToString:userInfo.mobile]){
            //有上一次重连
            //自动重连上一次
            self.currentIndexPatch = [NSIndexPath indexPathForRow:0 inSection:0];
            [self startAnimation];
            [self requestVerifyDeviceWithWristModel:model];
//            [self reConnectLastBle];
        } else {
            //重新搜索
             [self.searchReminderButton setTitle:@"正在搜索..." forState:UIControlStateNormal];
            self.mineDevices = [self getMineDevices];
            if (self.scanDevices.count > 0) {
                [self.scanDevices removeAllObjects];
            }
            if (self.mineDevices.count > 0) {
                [self.scanDevices addObject:self.mineDevices];
            }
            if (self.otherDevices.count > 0) {
                [self.otherDevices removeAllObjects];
            }
             [self.shareKey scanWithSharkeyType:SHARKEYALL];
        }
        
    }
    
   
    
}
//设置tableView的数据源
- (void)setTableViewData
{
    if (self.scanDevices.count > 0) {
        [self.scanDevices removeAllObjects];
    }
    self.mineDevices = [self getMineDevices];
    if (self.mineDevices.count > 0) {
        [self.scanDevices addObject:self.mineDevices];
    }
    if (self.otherDevices.count > 0) {
        [self.scanDevices addObject:self.otherDevices];
    }
    
}
//重新连接上一次的设备
- (void)reConnectLastBle
{
    WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
    SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
    if (model && [model.mobile isEqualToString:userInfo.mobile]){
        Sharkey *sharKey =  [self lastSharkey:model];
        if (sharKey) {
            [self.shareKey connectSharkey:sharKey];
        }
    }
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
- (WristStrapModel *)modelWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.scanDevices.count > indexPath.section) {
        //数组容错判断  建立连接
        NSMutableArray *array = self.scanDevices[indexPath.section];
        if (array.count > indexPath.row) {
            WristStrapModel *model = array[indexPath.row];
            return model;
        }return nil;
    }return nil;

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
    
    
}//保存最近一次连接设备
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
//获取我的设备
- (NSMutableArray *)getMineDevices
{
    WristStrapModel *lastmodel = [OBDataManager shareManager].lastStrapModel;
    SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
    if (lastmodel && [lastmodel.mobile isEqualToString:userInfo.mobile]){
        [self.mineDevices removeAllObjects];
        [self.mineDevices addObject:lastmodel];
        return self.mineDevices;
    } else
        return nil;
}
//点击某个cell 建立连接
- (void)connectToBleWithIndexPath:(NSIndexPath *)indexPath
{
    WristStrapModel *model = [self modelWithIndexPath:indexPath];
    Sharkey *sharKey = [self lastSharkey:model];
    WristStrapModel *lastmodel = [OBDataManager shareManager].lastStrapModel;
    SYLoginInfoModel *infoModel = [SYUserDataManager manager].userLoginInfoModel;
    if (lastmodel && [lastmodel.identifier isEqualToString:model.identifier]&& [lastmodel.mobile isEqualToString:infoModel.mobile]){
        //点击的是上一次保存的  请求服务器判断有没有被绑定
        [self requestVerifyDeviceWithWristModel:lastmodel];
    } else {
        [self.shareKey connectSharkeyNeedPair:sharKey];
    }
    
}

//添加第一次连接 连接敲击提示框
- (void)addConnectRemiderView
{
    [self.view addSubview:self.reminderView];
}
//移除提示
- (void)removeReminderView
{
    if (self.reminderView) {
        [self.reminderView removeFromSuperview];
    }
//    BOOL noFirst =  [[NSUserDefaults standardUserDefaults]objectForKey:@"NoFirst"];
    if (self.isFirst) {
        //第一次  进入tabbar
         [UIApplication sharedApplication].delegate.window.rootViewController = [[SYTabBarViewController alloc] init];
    }
    
}
//开始转圈
- (void)startAnimation
{
    if (self.currentIndexPatch) {
        SYScanedDevicesCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPatch];
        if (cell) {
            [cell.activityView startAnimating];
        }
    }
    
}
//停止转圈
- (void)stopAnimation
{
    if (self.currentIndexPatch) {
        SYScanedDevicesCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPatch];
        if (cell) {
            [cell.activityView stopAnimating];
        }
    }
}
#pragma mark - 数据请求
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
                        //找到设备
                        WristStrapModel *lastmodel = [OBDataManager shareManager].lastStrapModel;
                        if (lastmodel && [lastmodel.identifier isEqualToString:model.identifier]) {
                            //连接的是上一次连接的设备
                           
                            //转圈
//                            [self startAnimation];
                            [self.shareKey connectSharkey:sharKey];
                        } else {
                            //新设备需要配对  走配对
//                            [self startAnimation];
                            [self.shareKey pairToSharkey:sharKey];
                        }
                    }
                } else {
                    //设备不可以连
                    [MBProgressHUD showSuccess:result[@"resultMsg"] toView:self.view];
                }
                
            } else {
                //请求失败
                [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
            }
            [self stopAnimation];
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
                if (self.isFirst) {
                     [UIApplication sharedApplication].delegate.window.rootViewController = [[SYTabBarViewController alloc] init];
                }
               
            }
        } failedBlock:^(id  _Nonnull error) {
            
        }];
        
    }
    
}
- (void)requestUnBindDeviceWithWristModel:(WristStrapModel *)model
{
    if (![SYUserDataManager manager].userLoginInfoModel) {
        //暂未登录
        [MBProgressHUD showError:@"请先登录" toView:self.view];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"unBindDeviceData" forKey:@"tradeId"];
        [params setObject:model.macAddress forKey:@"mac"];
        [params setObject:[SYUserDataManager manager].userLoginInfoModel.token forKey:@"token"];
        [OBDataRequest requestWithURL:kAPI_unBindDevice params:params httpMethod:@"POST" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionblock:^(id  _Nonnull result) {
            if (![result[@"success"] boolValue]) {
                //请求失败
                [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
            } else {
                //成功解除绑定
                [[OBDataManager shareManager] removeLastModel];
                [self setTableViewData];
                [self.tableView reloadData];
            }
        } failedBlock:^(id  _Nonnull error) {
             [MBProgressHUD showError:error toView:self.view];
        }];
        
    }

}
#pragma mark - 手环代理方法 WCDSharkeyFunctionDelegate
- (void)WCDBLERealStateCallBack:(BLEState)bleState
{
    if (bleState == BLEStatePoweredOn) {
        //蓝牙打开状态
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model && [model.mobile isEqualToString:userInfo.mobile]){
            //有上一次重连
            //自动重连上一次  请求服务器能否连
            [self requestVerifyDeviceWithWristModel:model];
//            [self reConnectLastBle];
        } else {
            //重新搜索
//            [self setTableViewData];
            [self.searchReminderButton setTitle:@"正在搜索..." forState:UIControlStateNormal];
            if (self.scanDevices.count > 0) {
                [self.scanDevices removeAllObjects];
            }
            if (self.otherDevices.count > 0) {
                [self.otherDevices removeAllObjects];
            }
            [self.shareKey scanWithSharkeyType:SHARKEYALL];
        }
        //tableView数据源
        
        [self.tableView reloadData];
        //开始扫描手环
        NSLog(@"-------BLEStatePoweredOn--");
    } else if (bleState == BLEStateScaning) {
        [self.searchReminderButton setTitle:@"正在搜索..." forState:UIControlStateNormal];
//        self.searchReminderLabel.text = @"正在搜索...";
        NSLog(@"-------BLEStateScaning--");
    } else if (bleState == BLEStatePoweredOff) {
        [self.searchReminderButton setTitle:@"重新搜索" forState:UIControlStateNormal];
//        self.searchReminderLabel.text = @"请打开蓝牙设备";
        NSLog(@"-------BLEStatePoweredOff--");
    } else if (bleState == BLEStateConnected) {
//        self.searchReminderLabel.text = @"设备已连接";
        NSLog(@"-------BLEStateConnected--");
    }else if (bleState == BLEStateConnectFail) {
//        self.searchReminderLabel.text = @"设备连接失败";
        NSLog(@"-------BLEStateConnectFail--");
    }else if (bleState == BLEStateUnknown) {
//        self.searchReminderLabel.text = @"未知状态";
        NSLog(@"-------BLEStateUnknown--");
    } else if (bleState == BLEStateNotReady) {
//        self.searchReminderLabel.text = @"未准备";
        NSLog(@"-------BLEStateNotReady--");
    }else if (bleState == BLEStateUnsupported) {
//        self.searchReminderLabel.text = @"设备不支持连接";
        NSLog(@"-------BLEStateUnsupported--");
    }else if (bleState == BLEStateUnauthorized) {
//        self.searchReminderLabel.text = @"设备未授权";
        NSLog(@"-------BLEStateUnauthorized--");
    }else if (bleState == BLEStateStopScan) {
//        self.searchReminderLabel.text = @"停止扫描设备";
        NSLog(@"-------BLEStateStopScan--");
    }else if (bleState == BLEStateDiscoverPeripheral) {
//        self.searchReminderLabel.text = @"发现蓝牙设备";
        NSLog(@"-------BLEStateDiscoverPeripheral--");
    }else if (bleState == BLEStateDiscoverServicesError) {
//        self.searchReminderLabel.text = @"蓝牙设备发生错误";
        NSLog(@"-------BLEStateDiscoverServicesError--");
    }else if (bleState == BLEStateDiscoverCharacteristicsError) {
//        self.searchReminderLabel.text = @"未知错误";
        NSLog(@"-------BLEStateDiscoverCharacteristicsError--");
    }else if (bleState == BLEStateDisconnected) {
//        self.searchReminderLabel.text = @"设备未连接";
        [MBProgressHUD showError:@"设备暂未连接" toView:self.view];
        NSLog(@"-------BLEStateDisconnected--");
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model && [model.mobile isEqualToString:userInfo.mobile]){
            model.isConnected = NO;
            [OBDataManager shareManager].strapModel = model;
        }
        [self setTableViewData];
        [self.tableView reloadData];
    }
}

//扫描回调
- (void)WCDSharkeyScanCallBack:(Sharkey *)crippleSharkey
{
    NSLog(@"crippleSharkey -------%@",crippleSharkey);
    WristStrapModel *lastmodel = [OBDataManager shareManager].lastStrapModel;
    WristStrapModel *model = [self modelWithSharKey:crippleSharkey];
    SYLoginInfoModel *userInfo = [SYUserDataManager manager].userLoginInfoModel;
    //先删除原来的 再添加我的设备
    
    if (lastmodel && [lastmodel.mobile isEqualToString:userInfo.mobile] && [model.identifier isEqualToString:lastmodel.identifier]) {
        //有连接过的设备
    }else {
        //其他设备
        if ([self.scanDevices containsObject:self.otherDevices]) {
            [self.scanDevices removeObject:self.otherDevices];
        }
        [self.otherDevices addObject:model];
        [self.scanDevices addObject:self.otherDevices];
    }
    [self.tableView reloadData];
}
- (void)WCDSharkeyScanStop
{
    NSLog(@"扫描结束");
    [self.searchReminderButton setTitle:@"重新搜索" forState:UIControlStateNormal];
}
//握手
- (void)WCDShackHandSuccessCallBack:(Sharkey *)crippleSharkey
{
    //配对之前请求服务器 有没有被绑定过
    WristStrapModel *model = [self modelWithSharKey:crippleSharkey];
    if (crippleSharkey.macAddress.length == 0) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"请先到系统蓝牙去忽略此设备，然后再重新搜索" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
//            if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                [[UIApplication sharedApplication]openURL:url];
//            }
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else
        [self requestVerifyDeviceWithWristModel:model];
    
}
- (void)WCDConnectSuccessCallBck:(BOOL)flag sharkey:(Sharkey *)intactSharkey
{
    NSLog(@"配对成功flag ----- %d，intactSharkey -------%@",flag,intactSharkey);
    [self removeReminderView];
//    [self.shareKey stopScan];
    [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"NoFirst"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //保存设备模型数据
    [self saveLastStrapModel:intactSharkey];
    if (self.currentIndexPatch) {
        //点击单元格连接
        WristStrapModel *model = [self modelWithIndexPath:self.currentIndexPatch];
        if (model) {
            model.isConnected = YES;
            model.isMineDevice = YES;
            if ([self.otherDevices containsObject:model]) {
                //从其他设备中删除 添加到我的设备当中
                [self.otherDevices removeObject:model];
                [self.mineDevices addObject:[self modelWithSharKey:intactSharkey]];
                //tableView 数据重置
                [self setTableViewData];
            }
            
        }
    }
    [self setTableViewData];
    [self.tableView reloadData];
    [self.shareKey setqueryRemotePairStatus];
    [self.shareKey queryBatteryLevel];
    
    //告诉服务器绑定成功
    WristStrapModel *model = [self modelWithSharKey:intactSharkey];
    [self requestBindDeviceWithWristModel:model];
    //停止转圈
//    [self stopAnimation];
    

    
}
- (void)WCDQueryBatteryLevelCallBack:(BOOL)flag level:(NSUInteger)level
{
    NSLog(@"电池电量获取-----------%d -----level %ld",flag,level);
}
- (void)WCDPairCodeSendSuccessCallBack
{
    NSLog(@"验证码配对");
}
- (void)WCDTapPairSendSuccessCallBack
{
    NSLog(@"敲击配对");
    [self addConnectRemiderView];
}
- (void)WCDSecurityPairCodeSendSuccessCallBack
{
    NSLog(@"屏幕点击配对");
    [self addConnectRemiderView];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.scanDevices.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.scanDevices.count > section) {
        NSMutableArray *array = self.scanDevices[section];
        return array.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYScanedDevicesCell *cell = [SYScanedDevicesCell cellWithTableView:tableView indexPatch:indexPath];
    cell.delegate = self;
    if (self.scanDevices.count > indexPath.section) {
        NSMutableArray *array = self.scanDevices[indexPath.section];
        if (array.count > indexPath.row) {
            WristStrapModel *model = array[indexPath.row];
            if (model) {
                cell.strapModel = model;
            }
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shareKey.bleState == BLEStateNotReady || self.shareKey.bleState == BLEStatePoweredOff) {
        //未打开蓝牙
        [self.searchReminderButton setTitle:@"重新搜索" forState:UIControlStateNormal];
        //未打开蓝牙
        [MBProgressHUD showSuccess:@"请打开蓝牙" toView:self.view];
    } else {
        //已经打开蓝牙  建立连接
        self.currentIndexPatch = indexPath;
        [self startAnimation];
        [self connectToBleWithIndexPath:indexPath];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.scanDevices.count > section) {
        NSMutableArray *array = self.scanDevices[section];
        if (array.count > 0) {
            WristStrapModel *model = array[0];
            if (model.isMineDevice) {
                return @"我的设备";
            } else
                return @"其他设备";
        }
        return nil;
    }
    return nil;
       
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight(64);
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if (indexPath.section == 0) {
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        if (model && model.isConnected) {
            title =  @"断开连接";
        } else if(model) {
            //没有已连接设备
            title =  @"解除绑定";
        }
    }
    UITableViewRowAction *disconnectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self editActionWithIndexPath:indexPath];
    }];
    if ([disconnectAction.title isEqualToString:@"断开连接"]) {
        disconnectAction.backgroundColor = RGBColor(241, 151, 53);
    } else if ([disconnectAction.title isEqualToString:@"解除绑定"]) {
        disconnectAction.backgroundColor = [UIColor redColor];
    }
    
    return @[disconnectAction];
}
//指定行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置tableview是否可编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里是关键：这样写才能实现既能禁止滑动删除Cell，又允许在编辑状态下进行删除  这里只有我的设备可以滑动
    if (self.scanDevices.count > indexPath.section) {
        NSMutableArray *array = self.scanDevices[indexPath.section];
        if (array.count > indexPath.row) {
            WristStrapModel *model = array[indexPath.row];
            if ([self.mineDevices containsObject:model]) {
                return UITableViewCellEditingStyleDelete;
            } else
                return UITableViewCellEditingStyleNone;
        } else
            return UITableViewCellEditingStyleNone;
    } else
        return UITableViewCellEditingStyleNone;
}
- (void)editActionWithIndexPath:(NSIndexPath *)indexPath
{
    WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
    if (model && model.isConnected) {
        //取消连接
        Sharkey *sharKey =  [self lastSharkey:model];
        if (sharKey) {
            [self.shareKey disconnectSharkey:sharKey];
            model.isConnected = NO;
            [OBDataManager shareManager].strapModel = model;
            [self setTableViewData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        //解绑
        NSLog(@"---------解绑");
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"解绑后请到系统蓝牙去忽略此设备" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                [[UIApplication sharedApplication]openURL:url];
//            }
            [self requestUnBindDeviceWithWristModel:model];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}
#pragma mark - SYScanedDevicesCellDelegate
- (void)scanedCellDidSelectedInfoButtonWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.scanDevices.count > indexPath.section) {
        //数组容错判断  建立连接
        NSMutableArray *array = self.scanDevices[indexPath.section];
        if (array.count > indexPath.row) {
            WristStrapModel *model = array[indexPath.row];
            SYDeviceInfoViewController *infoVC = [[SYDeviceInfoViewController alloc]init];
            infoVC.model = model;
            [self.navigationController pushViewController:infoVC animated:YES];
        }
    }

}
#pragma mark  - SYConnectReminderViewDelegate
- (void)connectReminderViewDidSelectedDeleteButton
{
//    [self removeReminderView];
    if (self.reminderView) {
        [self.reminderView removeFromSuperview];
    }

}
#pragma mark - getter and setter

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"shouhuan"];
    }
    return _imageView;
}
- (UIButton *)searchReminderButton
{
    if (_searchReminderButton == nil) {
        _searchReminderButton = [[UIButton alloc]init];
        _searchReminderButton.titleLabel.font = kFont(15.0);
        [_searchReminderButton setTitle:@"重新搜索" forState:UIControlStateNormal];
        [_searchReminderButton setTitleColor:[UIColor colorWithHexString:@"#6fc3db"] forState:UIControlStateNormal];
    }
    return _searchReminderButton;
}
- (UILabel *)confirmLabel
{
    if (_confirmLabel == nil) {
        _confirmLabel = [[UILabel alloc]init];
        _confirmLabel.font = kFont(14.0);
        _confirmLabel.textColor = [UIColor colorWithHexString:@"#939393"];
        _confirmLabel.textAlignment = NSTextAlignmentCenter;
        _confirmLabel.text = @"请确定智能手环在手机附近";
    }
    return _confirmLabel;
}
- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.font = kFont(15.0);
        _label.textColor = [UIColor colorWithHexString:@"#939393"];
        _label.text = @"可用设备";
    }
    return _label;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)scanDevices
{
    if (_scanDevices == nil) {
        _scanDevices = [[NSMutableArray alloc]init];
    }
    return _scanDevices;
}
- (NSMutableArray *)otherDevices
{
    if (_otherDevices == nil) {
        _otherDevices = [[NSMutableArray alloc]init];
    }
    return _otherDevices;
}
- (NSMutableArray *)mineDevices
{
    if (_mineDevices == nil) {
        _mineDevices = [[NSMutableArray alloc]init];
    }
    return _mineDevices;
}
- (SYConnectReminderView *)reminderView
{
    if (_reminderView == nil) {
        _reminderView = [[SYConnectReminderView alloc]init];
        _reminderView.delegate = self;
    }
    return _reminderView;
}
#endif
@end

