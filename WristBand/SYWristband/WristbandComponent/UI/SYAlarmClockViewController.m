//
//  SYAlarmClockViewController.m
//  SYWristband
//
//  Created by obally on 17/5/31.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYAlarmClockViewController.h"
#import "SYAddAlarmClockViewController.h"
#import "SYAlarmClockCell.h"
#import "AlarmColckModel+CoreDataClass.h"
@interface SYAlarmClockViewController ()<UITableViewDelegate,UITableViewDataSource,SYAlarmClockCellDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *alarmClockDate;
@property(nonatomic,strong) NSMutableArray *clockArray;

//@property(nonatomic,strong) NSMutableDictionary *dataDic;
//@property(nonatomic,strong) NSArray *dataKeyArray;

@end

@implementation SYAlarmClockViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"闹钟";
//    [self deleDataFromSql];
//    self.dataKeyArray = [NSArray array];
    [self setNavItem];
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    [self findDataFormSql];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图frame设置及相关约束
    [self viewframeSet];
    
    
}
//右侧导航按钮
- (void)setNavItem
{
    UIBarButtonItem *rightButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClockAction)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    [self.view addSubview:self.tableView];
}
- (void)addAction
{
    
}
- (void)viewframeSet
{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}
- (void)deleDataFromSql
{
    Sharkey *sharKey = [[WCDSharkeyFunction shareInitializationt] currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId==%@ AND userMobile == %@",sharKey.identifier,model.mobile];
    [AlarmColckModel MR_deleteAllMatchingPredicate:predicate];
    
}
- (void)alarmClockWithModel:(AlarmColckModel *)model
{
    AlarmClockData *clock = [[AlarmClockData alloc]init];
    NSArray *array =  [model.cycleDate componentsSeparatedByString:@":"];
    NSString *firstStr = nil;
    if (array.count > 0) {
        firstStr = array[0];
    }
    
    if (firstStr.length > 0) {
        //不是临时闹钟
        if ([array[0] isEqualToString:@"每天"]) {
            clock.cycle = AlarmClockEveryDay;
        } else if ([array[0] isEqualToString:@"每个工作日"]) {
            clock.cycle = AlarmClockWorkDayMask;
        } else if ([array[0] isEqualToString:@"周末"]) {
            clock.cycle = AlarmClockWeekEndMask;
        } else {
            clock.cycle = [self cycleMaskWithArray:array];
        }
        clock.enable = YES;
        clock.hour = model.date.hour;
        clock.minute = model.date.minute;
        [self.clockArray addObject:clock];
    } else {
        //临时闹钟 判断是不是今天
        if ([model.date isToday]) {
            clock.cycle = AlarmClockOnlyOnce;
            clock.enable = YES;
            clock.hour = model.date.hour;
            clock.minute = model.date.minute;
            [self.clockArray addObject:clock];
        } else {
            model.isOn = NO;
            model.date = [model.date nextDay];
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:nil];
        }
    }
    
//    [[WCDSharkeyFunction shareInitializationt] setAlockTime:[NSArray arrayWithObjects:clock,nil]];
}
- (NSInteger)cycleMaskWithArray:(NSArray *)array
{
    NSInteger cycleMask = 0;
    for (NSString *str in array) {
        if ([str isEqualToString:@"周一"]) {
            cycleMask = cycleMask|AlarmClockMondayMask;
        } else if ([str isEqualToString:@"周二"]) {
            cycleMask = cycleMask|AlarmClockTuesdayMask;
        } else if ([str isEqualToString:@"周三"]) {
            cycleMask = cycleMask|AlarmClockWednesdayMask;
        } else if ([str isEqualToString:@"周四"]) {
            cycleMask = cycleMask|AlarmClockThursdayMask;
        } else if ([str isEqualToString:@"周五"]) {
            cycleMask = cycleMask|AlarmClockFridayMask;
        } else if ([str isEqualToString:@"周六"]) {
            cycleMask = cycleMask|AlarmClockSaturdayMask;
        } else if ([str isEqualToString:@"周日"]) {
            cycleMask = cycleMask|AlarmClockSundayMask;
        }
    }
    return cycleMask;
}
//从本地数据库查找数据
- (void)findDataFormSql
{
    if (self.clockArray.count > 0) {
        [self.clockArray removeAllObjects];
    }
    Sharkey *sharKey = [[WCDSharkeyFunction shareInitializationt] currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId==%@ AND userMobile==%@",sharKey.identifier,model.mobile];
    
    NSArray *dataArray = [AlarmColckModel MR_findAllWithPredicate:predicate];
    for (AlarmColckModel *model in dataArray) {
        NSLog(@"-----dateString----%@",model.dateString);
        if (model.isOn) {
            //打开闹钟
            [self alarmClockWithModel:model];
            
        }
    }
    self.alarmClockDate = [NSMutableArray arrayWithArray:dataArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [[WCDSharkeyFunction shareInitializationt] setAlockTime:self.clockArray];
    
}
- (void)saveDataToSqlWithDate:(NSDate *)date timeArray:(NSArray *)timeArray isOpen:(BOOL)isOpen
{
    NSString *str = [timeArray componentsJoinedByString:@":"];
    Sharkey *sharKey = [[WCDSharkeyFunction shareInitializationt] currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute|NSCalendarUnitHour fromDate:date];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    NSString *hourString = [NSString stringWithFormat:@"%ld",components.hour];
    NSString *minuteString = [NSString stringWithFormat:@"%ld",components.minute];
    if (components.minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%ld",components.minute];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@:%@",hourString,minuteString];
    AlarmColckModel *clockModel = [AlarmColckModel MR_createEntity];
    clockModel.deviceId = sharKey.identifier;
    clockModel.dateString = dateStr;
    clockModel.cycleDate = str;
    clockModel.date = date;
    clockModel.isOn = isOpen;
    if (model) {
        clockModel.userMobile = model.mobile;
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self findDataFormSql];
    }];
}
#pragma mark -Actions
- (void)addClockAction
{
    SYAddAlarmClockViewController *addClock = [[SYAddAlarmClockViewController alloc]init];
    addClock.block = ^(NSDate *date,NSArray *timeArray,BOOL isOpen) {
        [self saveDataToSqlWithDate:date timeArray:timeArray isOpen:isOpen];
        
//        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addClock animated:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.alarmClockDate.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYAlarmClockCell *cell = [SYAlarmClockCell cellWithTableView:tableView indexPatch:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.alarmClockDate.count > indexPath.row) {
        cell.model = self.alarmClockDate[indexPath.row];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight(65);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.alarmClockDate.count > indexPath.row) {
        SYAddAlarmClockViewController *addClock = [[SYAddAlarmClockViewController alloc]init];
        addClock.isEdit = YES;
        addClock.clockModel = self.alarmClockDate[indexPath.row];
        addClock.block = ^(NSDate *date,NSArray *timeArray,BOOL isOpen) {
            [self saveDataToSqlWithDate:date timeArray:timeArray isOpen:isOpen];
            
//            [self findDataFormSql];
//            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:addClock animated:YES];
    } else {
        [MBProgressHUD showError:@"请返回上一页再重新试试" toView:self.view];
    }
}
#pragma mark - SYAlarmClockCellDelegate
- (void)clockCellDidOpenClockWithModel:(AlarmColckModel *)model isOn:(BOOL)ison
{
    model.isOn = ison;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
    [self alarmClockWithModel:model];
    [[WCDSharkeyFunction shareInitializationt] setAlockTime:self.clockArray];
}

#pragma mark - getter and setter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    return _tableView;
}
- (NSMutableArray *)alarmClockDate
{
    if (_alarmClockDate == nil) {
        _alarmClockDate = [[NSMutableArray alloc]init];
    }
    return _alarmClockDate;
}
- (NSMutableArray *)clockArray
{
    if (_clockArray == nil) {
        _clockArray = [[NSMutableArray alloc]init];
    }
    return _clockArray;
}
//- (NSMutableDictionary *)dataDic
//{
//    if (_dataDic == nil) {
//        _dataDic = [[NSMutableDictionary alloc]init];
//    }
//    return _dataDic;
//}
@end
