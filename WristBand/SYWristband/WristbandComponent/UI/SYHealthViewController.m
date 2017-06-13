//
//  SYHealthViewController.m
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYHealthViewController.h"
#import "SYSportViewController.h"
#import "SYSleepViewController.h"
#import "SleepDataModel+CoreDataClass.h"
#import "SportDataModel+CoreDataClass.h"
#import "UpLoadSleepDate+CoreDataClass.h"
#import "UpLoadSportDate+CoreDataClass.h"
#import "SYHealthModel.h"
@interface SYHealthViewController ()<WCDSharkeyFunctionDelegate>{
    MBProgressHUD *hud;
}
@property(nonatomic,strong)WCDSharkeyFunction *shareKey;
@property(nonatomic,strong)WristStrapModel *strapModel; //手环数据
@property(nonatomic,strong)Sharkey *sharKey; //sharekey 设备
@property(nonatomic,strong)UIView *topView; //顶部自定义的view
@property(nonatomic,strong)UIButton *topSportButton; //顶部运动按钮
@property(nonatomic,strong) UILabel *sportLine;
@property(nonatomic,strong) UILabel *sleepLine; //白色线
@property(nonatomic,strong)UIButton *topSleepButton; //顶部睡眠按钮
@property(nonatomic,strong)UIViewController *currentVC;//当前控制器
@property(nonatomic,strong) SYSportViewController *sportVC; //运动控制器
@property(nonatomic,strong) SYSleepViewController *sleepVC; //睡眠控制器
@property(nonatomic,assign) BOOL isConnect; //手环是否连接

@property(nonatomic,strong)NSMutableArray *stepArray; //步数
@property(nonatomic,strong)NSMutableArray *distantArray; //公里数
@property(nonatomic,strong)NSMutableArray *calorieArray; //卡路里数

@end

@implementation SYHealthViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    self.title = @"健康";
    NSArray *array = [SleepDataModel MR_findAll];
    NSArray *array1 = [SportDataModel MR_findAll];
    if (array.count == 0 || array1.count == 0) {
        //从服务器请求数据 并保存数据到本地
        [self requestAllDataFromService];
    }

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图frame设置及相关约束
    [self viewframeSet];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //手环初始化
    self.shareKey = [WCDSharkeyFunction shareInitializationt];
    self.shareKey.delegate = self;
    [self.shareKey setTimeSynchronization];
    Sharkey *currentSharkey =  [self.shareKey currentSharkey];
    BLEState bleState = [self.shareKey queryBLEState];
    if (bleState == BLEStateNotReady) {
        //未打开蓝牙
        [MBProgressHUD showError:@"暂未打开蓝牙" toView:self.view];
        self.isConnect = NO;
    }else if(bleState == BLEStateDisconnected|| bleState == BLEStatePoweredOff || bleState == BLEStateUnknown  || bleState == BLEStateUnsupported){
        [MBProgressHUD showError:@"设备暂未连接" toView:self.view];
        self.isConnect = NO;
    }else {
        
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
       if (currentSharkey && model.isConnected == YES) {
            //连接状态
            self.isConnect = YES;
            [self.shareKey updatePedometerDataFromRemoteWalkNumberOfDays:0xd7];
            [self.shareKey querySleepDataFromSharkey];
       }else if (currentSharkey){
           self.isConnect = NO;
           [self.shareKey connectSharkey:currentSharkey];
       } else {
            //未连接状态
           
            self.isConnect = NO;
           SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
           if (model&&[model.mobile isEqualToString:userInfo.mobile]){
                //有上一次重连
                //自动重连上一次
                
                [self requestVerifyDeviceWithWristModel:model];
            } else {
                [MBProgressHUD showError:@"请先连接设备" toView:self.view];
                
            }
        }

    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - request  数据请求
//从服务器请求数据
- (void)requestAllDataFromService
{
    SYLoginInfoModel *infoModel = [SYUserDataManager manager].userLoginInfoModel;
    if (![SYUserDataManager manager].userLoginInfoModel) {
        [MBProgressHUD showError:@"暂未登录" toView:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"querySevendayData" forKey:@"tradeId"];
    [params setObject:infoModel.token forKey:@"token"];
    [OBDataRequest requestWithURL:kAPI_querySevendayData params:params httpMethod:@"POST" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionblock:^(id  _Nonnull result) {
        if ([result[@"success"] boolValue]) {
            //成功
            NSArray *healthArray = [SYHealthModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
//            self.healthArray = healthArray;
            [self saveDateToSqlFromServiceWithDataArray:healthArray];
        } else if (![result[@"success"] boolValue]) {
            //其它原因失败
            [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
        }
    } failedBlock:^(id  _Nonnull error) {
        [MBProgressHUD showError:error toView:self.view];
    }];
    
}
- (void)saveDateToSqlFromServiceWithDataArray:(NSArray *)dataArray
{
    for (SYHealthModel *healthModel in dataArray) {
        NSArray *array = [healthModel.date componentsSeparatedByString:@"-"];
        NSString *str = nil;
        if (array.count > 2) {
            str = [NSString stringWithFormat:@"%@.%@",array[1],array[2]];
        }
        [self saveSleepWithModel:healthModel dateString:str];
        [self saveSportWithModel:healthModel dateString:str];
    }
}
- (void)saveSleepWithModel:(SYHealthModel *)healthModel dateString:(NSString *)dateString
{
    //保存睡眠
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date =  [dateFormatter dateFromString:healthModel.date];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    Sharkey *sharKey = [self.shareKey currentSharkey];
    SleepDataModel *sleepModel = [SleepDataModel MR_createEntity];
    sleepModel.deviceId = sharKey.identifier;
    sleepModel.date = dateString;
    sleepModel.totalDate = date;
    sleepModel.totalSleep = [healthModel.totalSleepTime floatValue];
    sleepModel.deepSleep = [healthModel.deepSleetTime floatValue];
    sleepModel.lightSleep = [healthModel.lightSleepTime floatValue];
    if (model) {
        sleepModel.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
}
- (void)saveSportWithModel:(SYHealthModel *)healthModel dateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date =  [dateFormatter dateFromString:healthModel.date];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    Sharkey *sharKey = [self.shareKey currentSharkey];
    SportDataModel *sportModel = [SportDataModel MR_createEntity];
    sportModel.deviceId = sharKey.identifier;
    sportModel.date = dateString;
    sportModel.totalDate = date;
    sportModel.distant = [healthModel.sportDistance floatValue];
    sportModel.calorie = [healthModel.energyConsume floatValue];
    sportModel.totalStep = [healthModel.totalSportSteps floatValue];
    if (model) {
        sportModel.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
}
//上传睡眠数据
- (void)uploadSleepDataWithSleepInfo:(SleepDataModel *)sleepModel date:(NSString *)date
{
    SYLoginInfoModel *infoModel = [SYUserDataManager manager].userLoginInfoModel;
    if (![SYUserDataManager manager].userLoginInfoModel) {
        [MBProgressHUD showError:@"暂未登录" toView:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"uploadSleepData" forKey:@"tradeId"];
    [params setObject:infoModel.token forKey:@"token"];
    [params setObject:date forKey:@"sleepDate"];
    [params setObject:[NSNumber numberWithFloat:sleepModel.totalSleep]  forKey:@"sleepTime"];
    [params setObject:[NSNumber numberWithFloat:sleepModel.deepSleep] forKey:@"deepSleepTime"];
    [params setObject:[NSNumber numberWithFloat:sleepModel.lightSleep] forKey:@"shallowSleepTime"];
    [OBDataRequest requestWithURL:kAPI_uploadSleepData params:params httpMethod:@"POST" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionblock:^(id  _Nonnull result) {
        if ([result[@"success"] boolValue]) {
            //成功  保存上传数据到本地
            [self saveUpLoadSleepDataWithDate:date];
            
        } else if (![result[@"success"] boolValue]) {
            //其它原因失败
//            hud.label.text = result[@"resultMsg"];
            [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
        }
    } failedBlock:^(id  _Nonnull error) {
        [MBProgressHUD showError:error toView:self.view];
    }];

}
//上传运动数据
- (void)uploadSportDataWithSportInfo:(SportDataModel *)sportModel date:(NSString *)date
{
    SYLoginInfoModel *infoModel = [SYUserDataManager manager].userLoginInfoModel;
    if (![SYUserDataManager manager].userLoginInfoModel) {
        [MBProgressHUD showError:@"暂未登录" toView:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"queyUserInfo" forKey:@"tradeId"];
    [params setObject:infoModel.token forKey:@"token"];
    [params setObject:date forKey:@"sportDate"];
    [params setObject:[NSNumber numberWithFloat:sportModel.totalStep] forKey:@"sportSteps"];
    [params setObject:[NSNumber numberWithFloat:sportModel.distant] forKey:@"sportDistance"];
    [params setObject:[NSNumber numberWithFloat:sportModel.calorie] forKey:@"energyConsume"];
    [OBDataRequest requestWithURL:kAPI_uploadSportData params:params httpMethod:@"POST" progressBlock:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionblock:^(id  _Nonnull result) {
        if ([result[@"success"] boolValue]) {
            //成功
            [self saveUpLoadSportDataWithDate:date];
            
        } else if (![result[@"success"] boolValue]) {
            //其它原因失败
            //            hud.label.text = result[@"resultMsg"];
            [MBProgressHUD showError:result[@"resultMsg"] toView:self.view];
        }
    } failedBlock:^(id  _Nonnull error) {
        [MBProgressHUD showError:error toView:self.view];
    }];

}
#pragma mark  -  本地数据保存

//保存上传睡眠时间数据到本地
- (void)saveUpLoadSleepDataWithDate:(NSString *)date
{
    Sharkey *sharKey = [self.shareKey currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    UpLoadSleepDate *sleepDate = [UpLoadSleepDate MR_createEntity];
    sleepDate.deviceId = sharKey.identifier;
    sleepDate.date = date;
    if (model) {
        sleepDate.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    
    //最多7条
    NSArray *allupArray = [UpLoadSleepDate MR_findAllSortedBy:@"date" ascending:YES];
    if (allupArray.count > 7) {
        UpLoadSleepDate *sleepModel = allupArray[0];
        [sleepModel MR_deleteEntity];
    }
    
}
//保存上传运动时间数据到本地
- (void)saveUpLoadSportDataWithDate:(NSString *)date
{
    Sharkey *sharKey = [self.shareKey currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    UpLoadSportDate *sportDate = [UpLoadSportDate MR_createEntity];
    sportDate.deviceId = sharKey.identifier;
    sportDate.date = date;
    if (model) {
        sportDate.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    //最多7条
    NSArray *allupArray = [UpLoadSportDate MR_findAllSortedBy:@"date" ascending:YES];
    if (allupArray.count > 7) {
        UpLoadSportDate *sportDate = allupArray[0];
        [sportDate MR_deleteEntity];
    }
    
}
//保存运动数据到本地
- (void)saveSportDataWithSportDate:(NSDate *)date distant:(CGFloat)distant kCal:(CGFloat)kCal totalStep:(NSInteger)count
{
    NSDate *currentDate = [self getNowDateFromatAnDate:date];
    NSString *string = [self stringWithDate:date];
    Sharkey *sharKey = [self.shareKey currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@ AND userMobile == %@",string,model.mobile];
    NSArray *dataArray = [SportDataModel MR_findAllWithPredicate:predicate];
    if (dataArray.count > 0) {
        //之前存储过  存最新的
        for (SportDataModel *sport in dataArray) {
            [sport MR_deleteEntity];
            NSLog(@"sportstep = %d  date = %@",sport.totalStep,sport.date);
        }
    }
    SportDataModel *sportModel = [SportDataModel MR_createEntity];
    sportModel.deviceId = sharKey.identifier;
    sportModel.date = string;
    sportModel.totalDate = date;
    sportModel.distant = distant;
    sportModel.calorie = (float)kCal;
    sportModel.totalStep = (int)count;
    if (model) {
        sportModel.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    NSArray *allArray = [SportDataModel MR_findAllSortedBy:@"totalDate" ascending:YES];
    if (allArray.count > 28) {
        SleepDataModel *sleepModel = allArray[0];
        NSLog(@"date-------%@",sleepModel.date);
        [sleepModel MR_deleteEntity];
    }
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"date==%@AND userMobile == %@",[currentDate formatYMD],model.mobile];
    NSArray *array = [UpLoadSportDate MR_findAllWithPredicate:predicate1];
//    NSDate *date1 = [self getNowDateFromatAnDate:[NSDate date]];
    if (array.count == 0) {
        //表示没有传过
        if (![currentDate isToday]) {
            //今天的数据不传
            [self uploadSportDataWithSportInfo:sportModel date:[currentDate formatYMD]];
        }
        
    }
    
}

//保存睡眠数据到本地
- (void)saveSleepDataWithSleepInfo:(SleepDataInfo *)sleep date:(NSDate *)date
{
    NSString *string = [self stringWithDate:date];
    Sharkey *sharKey = [self.shareKey currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@ AND userMobile == %@",string,model.mobile];
    NSArray *dataArray = [SleepDataModel MR_findAllWithPredicate:predicate];
    if (dataArray.count > 0) {
        //之前存储过  存最新的
        for (SleepDataModel *sleep in dataArray) {
            [sleep MR_deleteEntity];
            NSLog(@"sportstep = %.2f  date = %@",sleep.totalSleep,sleep.date);
        }
    }
    SleepDataModel *sleepModel = [SleepDataModel MR_createEntity];
    sleepModel.deviceId = sharKey.identifier;
    sleepModel.date = string;
    sleepModel.totalDate = date;
    sleepModel.totalSleep = sleep.totalMinute/60.0;
    sleepModel.deepSleep = sleep.deepMinute/60.0;
    sleepModel.lightSleep = sleep.lightMinute/60.0;
    if (model) {
        sleepModel.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    //最多28条
    NSArray *allArray = [SleepDataModel MR_findAllSortedBy:@"totalDate" ascending:YES];
    if (allArray.count > 28) {
        SleepDataModel *sleepModel = allArray[0];
        [sleepModel MR_deleteEntity];
    }
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"date==%@AND userMobile == %@",[date formatYMD],model.mobile];
    
    NSArray *array = [UpLoadSleepDate MR_findAllWithPredicate:predicate1];
    if (array.count == 0) {
        //表示没有传过
        //判断当前时间是上午还是下午
        NSDate *currentdate = [NSDate date];
        NSLog(@"%ld",currentdate.hour);
        if (currentdate.hour > 12) {
            //表示是下午  上传数据到服务器
            [self uploadSleepDataWithSleepInfo:sleepModel date:[date formatYMD]];
        }
        
    }
    
}

#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    [self addChildViewController:self.sportVC];
    [self.view addSubview:self.sportVC.view];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.topSportButton];
    [self.topSportButton addSubview:self.sportLine];
    [self.topView addSubview:self.topSleepButton];
    [self.topSleepButton addSubview:self.sleepLine];
}
- (void)addAction
{
    [self.topSportButton addTarget:self action:@selector(sportAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topSleepButton addTarget:self action:@selector(sleepAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewframeSet
{
    CGFloat buttonWidth = kWidth(50);
    self.sportVC.view.frame = CGRectMake(0,64, kScreenWidth, kScreenHeight - 64 - 44);
    self.sleepVC.view.frame = CGRectMake(0,64, kScreenWidth, kScreenHeight - 64 - 44);
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, NaviHeitht);
    self.topSportButton.frame = CGRectMake((kScreenWidth - buttonWidth *2 - kWidth(55))/2.0, self.topView.height - kHeight(30), buttonWidth, kHeight(30));
    self.sportLine.frame = CGRectMake(kWidth(3), self.topSportButton.height - kHeight(2), self.topSportButton.width - kWidth(3) * 2, kHeight(2));
    self.topSleepButton.frame = CGRectMake(self.topSportButton.right + kWidth(55), self.topSportButton.top, self.topSportButton.width, self.topSportButton.height);
    self.sleepLine.frame = CGRectMake(kWidth(3), self.topSleepButton.height - kHeight(2), self.topSleepButton.width - kWidth(3) * 2, kHeight(2));
}
#pragma mark  -私有方法
//返回05.17  月.日 格式
- (NSString *)stringWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    //    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    NSString *monthString = [NSString stringWithFormat:@"%ld",month];
    NSString *dayString = [NSString stringWithFormat:@"%ld",day];;
    if (month < 10) {
        monthString = [NSString stringWithFormat:@"0%ld",month];
    }
    if (day < 10) {
        dayString = [NSString stringWithFormat:@"0%ld",day];
    }
    NSString *string = [NSString stringWithFormat:@"%@.%@",monthString,dayString];
    return string;
}
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
#pragma mark -Actions
- (void)sportAction:(UIButton *)button
{
    button.selected = YES;
    self.topSleepButton.selected = NO;
    self.sportLine.hidden = NO;
    self.sleepLine.hidden = YES;
    if (self.currentVC == self.sportVC) {
        //点击当前页面
        return;
    } else {
        [self replaceController:self.currentVC newController:self.sportVC];
    }
}
- (void)sleepAction:(UIButton *)button
{
    button.selected = YES;
    self.topSportButton.selected = NO;
    self.sportLine.hidden = YES;
    self.sleepLine.hidden = NO;
    if (self.currentVC == self.sleepVC) {
        //点击当前页面
        return;
    } else {
        [self replaceController:self.currentVC newController:self.sleepVC];
    }
//    [self.sleepVC requestCurrentSleepDataFormWrist];

}
//  切换各个标签内容
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *            着重介绍一下它
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController      当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options                 动画效果(渐变,从下往上等等,具体查看API)
     *  animations              转换过程中得动画
     *  completion              转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:1.0 options:UIViewAnimationOptionCurveLinear animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
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
                        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.label.text = @"正在连接";
                        [hud hideAnimated:YES afterDelay:10];
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
    } else if (bleState == BLEStatePoweredOff) {
        [MBProgressHUD showError:@"暂未打开蓝牙" toView:self.view];
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model&&[model.mobile isEqualToString:userInfo.mobile]){
            model.isConnected = NO;
            [OBDataManager shareManager].strapModel = model;
        }
        NSLog(@"-------BLEStatePoweredOff--");
    } else if (bleState == BLEStateConnectFail) {
        NSLog(@"-------BLEStateConnectFail--");
        [MBProgressHUD showError:@"设备连接失败" toView:self.view];
    }else if (bleState == BLEStateUnknown) {
        NSLog(@"-------BLEStateUnknown--");
    } else if (bleState == BLEStateNotReady) {
        [MBProgressHUD showError:@"尚未准备" toView:self.view];
        NSLog(@"-------BLEStateNotReady--");
    }else if (bleState == BLEStateUnsupported) {
        [MBProgressHUD showError:@"设备不支持连接" toView:self.view];
        NSLog(@"-------BLEStateUnsupported--");
    }else if (bleState == BLEStateUnauthorized) {
        [MBProgressHUD showError:@"设备未授权" toView:self.view];
        NSLog(@"-------BLEStateUnauthorized--");
    }else if (bleState == BLEStateStopScan) {
        //        self.searchReminderLabel.text = @"停止扫描设备";
        NSLog(@"-------BLEStateStopScan--");
    }else if (bleState == BLEStateDiscoverPeripheral) {
        //        self.searchReminderLabel.text = @"发现蓝牙设备";
        NSLog(@"-------BLEStateDiscoverPeripheral--");
    }else if (bleState == BLEStateDiscoverServicesError) {
        [MBProgressHUD showError:@"蓝牙设备发生错误" toView:self.view];
        NSLog(@"-------BLEStateDiscoverServicesError--");
    }else if (bleState == BLEStateDiscoverCharacteristicsError) {
        [MBProgressHUD showError:@"蓝牙未知错误" toView:self.view];
        NSLog(@"-------BLEStateDiscoverCharacteristicsError--");
    }else if (bleState == BLEStateDisconnected) {
        NSLog(@"-------BLEStateDisconnected--");
        [MBProgressHUD showError:@"设备暂未连接" toView:self.view];
        WristStrapModel *model = [OBDataManager shareManager].lastStrapModel;
        SYLoginInfoModel *userInfo =  [SYUserDataManager manager].userLoginInfoModel;
        if (model&&[model.mobile isEqualToString:userInfo.mobile]){
            model.isConnected = NO;
            [OBDataManager shareManager].strapModel = model;
        }
    }

}
- (void)WCDConnectSuccessCallBck:(BOOL)flag sharkey:(Sharkey *)intactSharkey
{
    hud.label.text = @"连接成功";
    [hud hideAnimated:YES];
    //保存设备模型数据
    [self saveLastStrapModel:intactSharkey];
    [self.shareKey setqueryRemotePairStatus];
    [self.shareKey queryBatteryLevel];
    self.isConnect = YES;
//    [self controlViewWithShareKeyStatus:self.isConnect];
    //告诉服务器绑定成功
    WristStrapModel *model = [self modelWithSharKey:intactSharkey];
    [self requestBindDeviceWithWristModel:model];
    [self.shareKey updatePedometerDataFromRemoteWalkNumberOfDays:0xd7];
    [self.shareKey querySleepDataFromSharkey];
    NSLog(@"--------------连接成功");
}
//计步
- (void)WCDPedometerDate:(NSDate *)date Count:(NSInteger)count Minute:(NSInteger)minute
{
    
    NSLog(@"date------%@,count------%ld,minute-----%ld",date,count,minute);
    [self.stepArray insertObject:[NSNumber numberWithInteger:count] atIndex:0];
    //查询公里数
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSInteger height = [model.height integerValue]>0?[model.height integerValue]:160;
    NSInteger weight = [model.weight integerValue]>0?[model.weight integerValue]:50;
    CGFloat distant = [[WCDSharkeyFunction shareInitializationt] getDistanceAll:height numStep:count];
    //卡路里
    CGFloat kCal = [[WCDSharkeyFunction shareInitializationt] getKcal:distant weight:weight];
    NSLog(@"distant------%f,kCal------%f",distant,kCal);
    [self.distantArray insertObject:[NSNumber numberWithFloat:distant] atIndex:0];
    [self.calorieArray insertObject:[NSNumber numberWithFloat:kCal] atIndex:0];
    if (self.sportVC) {
        self.sportVC.distantArray = self.distantArray;
        self.sportVC.stepArray = self.stepArray;
        self.sportVC.calorieArray = self.calorieArray;
    }
    //保存睡眠数据到本地
    [self saveSportDataWithSportDate:date distant:distant kCal:kCal totalStep:count];
}
//睡眠数据
- (void)WCDQuerySleepDataFromSharkeyCallBack:(NSUInteger)startMinute rawData:(NSData *)rawData gatherRate:(SleepDataGatherRate)gatherRate
{
    SleepDataInfo *sleep = [[SleepDataInfo alloc]init];
    sleep =  [self.shareKey analyseSleep:startMinute data:rawData gatherRate:gatherRate];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate* date = [[NSDate date]previousDay];
    NSString* startString = [formatter stringFromDate:date];
    NSString* deepString = [NSString stringWithFormat:@"%.2f",sleep.deepMinute/60.0];
    NSString* lightString = [NSString stringWithFormat:@"%.2f",sleep.lightMinute/60.0];
    NSString* totalString = [NSString stringWithFormat:@"%.2f",sleep.totalMinute/60.0];
    NSLog(@"睡眠开始时间 ----------%@",startString);
    NSLog(@"深睡时间 ----------%@",deepString);
    NSLog(@"浅睡时间 ----------%@",lightString);
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:totalString];
    [array addObject:deepString];
    [array addObject:lightString];
    if (self.sleepVC) {
        self.sleepVC.sleepData = array;
    }
    //存储睡眠数据
    [self saveSleepDataWithSleepInfo:sleep date:date];
    
}
#pragma mark - getter and setter

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#6fc3db"];
    }
    return _topView;
}
- (UIButton *)topSportButton
{
    if (_topSportButton == nil) {
        _topSportButton = [[UIButton alloc]init];
        [_topSportButton setTitle:@"运动" forState:UIControlStateNormal];
        _topSportButton.titleLabel.textColor = [UIColor whiteColor];
        _topSportButton.selected = YES;
        _topSportButton.titleLabel.font = kFont(19.0);
        [_topSportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_topSportButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        _topSportButton.backgroundColor = RandomColor;
    }
    return _topSportButton;
}
- (UIButton *)topSleepButton
{
    if (_topSleepButton == nil) {
        _topSleepButton = [[UIButton alloc]init];
        [_topSleepButton setTitle:@"睡眠" forState:UIControlStateNormal];
        [_topSleepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_topSleepButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        _topSleepButton.titleLabel.textColor = [UIColor whiteColor];
        _topSleepButton.titleLabel.font = kFont(19.0);
//        _topSleepButton.backgroundColor = RandomColor;
    }
    return _topSleepButton;
}

- (UILabel *)sportLine
{
    if (_sportLine == nil) {
        _sportLine = [[UILabel alloc]init];
        _sportLine.backgroundColor = [UIColor whiteColor];
    }
    return _sportLine;
}
- (UILabel *)sleepLine
{
    if (_sleepLine == nil) {
        _sleepLine = [[UILabel alloc]init];
        _sleepLine.backgroundColor = [UIColor whiteColor];
        _sleepLine.hidden = YES;
    }
    return _sleepLine;
}
- (SYSleepViewController *)sleepVC
{
    if (_sleepVC == nil) {
        _sleepVC = [[SYSleepViewController alloc]init];
    }
    return _sleepVC;
}
- (SYSportViewController *)sportVC
{
    if (_sportVC == nil) {
        _sportVC = [[SYSportViewController alloc]init];
        self.currentVC = _sportVC;
        
    }
    return _sportVC;
}
- (NSMutableArray *)stepArray
{
    if (_stepArray == nil) {
        _stepArray = [[NSMutableArray alloc]init];
    }
    return _stepArray;
}
- (NSMutableArray *)distantArray
{
    if (_distantArray == nil) {
        _distantArray = [[NSMutableArray alloc]init];
    }
    return _distantArray;
}
- (NSMutableArray *)calorieArray
{
    if (_calorieArray == nil) {
        _calorieArray = [[NSMutableArray alloc]init];
    }
    return _calorieArray;
}

@end
