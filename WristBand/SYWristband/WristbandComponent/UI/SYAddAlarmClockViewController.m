//
//  SYAddAlarmClockViewController.m
//  SYWristband
//
//  Created by obally on 17/5/31.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYAddAlarmClockViewController.h"
#if TARGET_IPHONE_SIMULATOR
#else
@interface SYAddAlarmClockViewController ()

@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) UILabel *alarmClockLabel; //闹钟范围
@property(nonatomic,strong) UIView  *clockView; //闹钟范围选择
@property(nonatomic,strong) UIButton *deleButton; //删除闹钟
@property(nonatomic,strong) NSMutableArray *selectedArray; //已选日期数组
@property(nonatomic,strong) NSArray *timeArray; //周一，周二，。。。。。
@property(nonatomic,strong) NSDate *selectedDate; //当前选择的日期



@end
#endif
@implementation SYAddAlarmClockViewController
#if TARGET_IPHONE_SIMULATOR
#else
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.timeArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
//    self.selectedDate = [self getNowDateFromatAnDate:[NSDate date]];
    
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    if (self.isEdit) {
        self.title = @"编辑闹钟";
        self.datePicker.date = self.clockModel.date;
        self.selectedDate = self.clockModel.date;
    } else {
        self.title = @"添加闹钟";
        self.selectedDate = [NSDate date];
    }
    
    
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
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"存储" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [rightButtonItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.alarmClockLabel];
    [self.view addSubview:self.clockView];
    [self addClockView];
    if (self.isEdit) {
        [self.view addSubview:self.deleButton];
    }
    
    
}
- (void)addClockView
{
    CGFloat edge = kWidth(10);
    CGFloat width = (kScreenWidth - edge *8)/7;
    for (int i = 0; i < self.timeArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(edge + (width + edge) * i, 0, width, width)];
        button.layer.cornerRadius = width/2.0;
        button.tag = 100 + i;
        [button setTitle:self.timeArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = kFont(16.0);
        [button setBackgroundImage:[UIImage imageNamed:@"ic_clock_unchoosetip"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_choosetip1"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.clockView addSubview:button];
        if (self.isEdit) {
            //编辑闹钟
            NSArray *cycleDateArray = [self.clockModel.cycleDate componentsSeparatedByString:@":"];
            if (cycleDateArray.count == 1 && [cycleDateArray[0] isEqualToString:@"每天"]) {
                cycleDateArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
            } else if (cycleDateArray.count == 1 && [cycleDateArray[0] isEqualToString:@"每个工作日"]) {
                cycleDateArray = @[@"周一",@"周二",@"周三",@"周四",@"周五"];
            }else if (cycleDateArray.count == 1 && [cycleDateArray[0] isEqualToString:@"周末"]) {
                cycleDateArray = @[@"周六",@"周日"];
            }
            if ([cycleDateArray containsObject:self.timeArray[i]]) {
                button.selected = YES;
                [self.selectedArray addObject:self.timeArray[i]];
            } else {
                button.selected = NO;
            }
        }
    }
}
- (void)addAction
{
    [self.datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
    [self.deleButton addTarget:self action:@selector(deleActionAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewframeSet
{
    self.datePicker.frame = CGRectMake(0, 0, kScreenWidth, kHeight(280));
    self.alarmClockLabel.frame = CGRectMake(kWidth(20), self.datePicker.bottom + kHeight(20), kScreenWidth, kHeight(30));
    self.clockView.frame = CGRectMake(0, self.alarmClockLabel.bottom + kHeight(20), kScreenWidth, kHeight(50));
    if (self.isEdit) {
        self.deleButton.frame = CGRectMake(0, self.clockView.bottom + kHeight(44), kScreenWidth, kHeight(46));
    }
}
#pragma mark -Actions
- (void)saveAction
{
    [self checkDateWithSelectedArray:self.selectedArray];
    if (self.isEdit) {
        //编辑
        [self.clockModel MR_deleteEntity];
        if (self.block) {
            self.block(self.selectedDate,self.selectedArray,self.clockModel.isOn);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        
        if (self.block) {
            self.block(self.selectedDate,self.selectedArray,NO);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
    
}
- (void)datePickerAction:(UIDatePicker *)picker
{
//    NSDate *selectedDate =  [self getNowDateFromatAnDate:picker.date];
    self.selectedDate = picker.date;
//    NSLog(@"------------%@",selectedDate);
}
- (void)timeButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
    NSInteger index = button.tag - 100;
    NSString *dayStr = self.timeArray[index];
    if (button.selected && ![self.selectedArray containsObject:dayStr]) {
        [self.selectedArray addObject:dayStr];
    }else if (!button.selected && [self.selectedArray containsObject:dayStr]) {
        [self.selectedArray removeObject:dayStr];
    }
}

- (void)deleActionAction
{
    //删除闹钟
//    Sharkey *sharKey = [[WCDSharkeyFunction shareInitializationt] currentSharkey];
//    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId==%@ AND userMobile == %@ AND date==%@",sharKey.identifier,model.mobile,self.clockModel.date];
//    [AlarmColckModel MR_deleteAllMatchingPredicate:predicate];
    [self.clockModel MR_deleteEntity];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 私有方法
- (void)checkDateWithSelectedArray:(NSMutableArray *)array
{
    if (array.count == 7) {
        //每天
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:@"每天"];
    }else if (array.count == 5 && [array containsObject:@"周一"] && [array containsObject:@"周二"] && [array containsObject:@"周三"] && [array containsObject:@"周四"] && [array containsObject:@"周五"]) {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:@"每个工作日"];
    }else if (array.count == 2 && [array containsObject:@"周六"] && [array containsObject:@"周日"] ) {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:@"周末"];
    }
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
#pragma mark - getter and setter
- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        _datePicker.timeZone = [NSTimeZone localTimeZone];
        [_datePicker setValue:[UIColor colorWithHexString:@"#60B8D1"] forKey:@"textColor"];
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    return _datePicker;
}
- (UILabel *)alarmClockLabel
{
    if (_alarmClockLabel == nil) {
        _alarmClockLabel = [[UILabel alloc]init];
        _alarmClockLabel.text = @"闹钟范围";
        _alarmClockLabel.font = kFont(16.0);
        _alarmClockLabel.textColor = [UIColor colorWithHexString:@"#4D4D4D"];
    }
    return _alarmClockLabel;
}
- (UIView *)clockView
{
    if (_clockView == nil) {
        _clockView = [[UIView alloc]init];
    }
    return _clockView;
}
- (UIButton *)deleButton
{
    if (_deleButton == nil) {
        _deleButton = [[UIButton alloc]init];
        [_deleButton setTitle:@"删除闹钟" forState:UIControlStateNormal];
        [_deleButton setTitleColor:[UIColor colorWithHexString:@"#F24C4C"] forState:UIControlStateNormal];
        _deleButton.titleLabel.font = kFont(16.0);
        _deleButton.backgroundColor = [UIColor whiteColor];
        
    }
    return _deleButton;
}
- (NSMutableArray *)selectedArray
{
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc]init];
    }
    return _selectedArray;
}
#endif
@end

