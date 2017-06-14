//
//  SYWeekSleepViewController.m
//  SYWristband
//
//  Created by obally on 17/5/19.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYWeekSleepViewController.h"
#import "OBColumnChart.h"
#import "SleepDataModel+CoreDataClass.h"
#if TARGET_IPHONE_SIMULATOR
#else
@interface SYWeekSleepViewController ()
{
    CGFloat topViewHeight;
    CGFloat centerTimeViewHeight;
    CGFloat centerColumnViewHeight;
    CGFloat bottomAverageViewHeight;
}
@property(nonatomic,strong) UIView *topDateView; //顶部日期时间视图
@property(nonatomic,strong) UIView *centerTimeView; //中间深浅睡时间视图
@property(nonatomic,strong) NSMutableArray *weekDateArray; //周时间数组
@property(nonatomic,strong) UILabel *deepText; //深睡数
@property(nonatomic,strong) UILabel *lightSleepText; //浅睡
@property(nonatomic,strong) UIView *centerColumnView; //中间柱状时间视图
@property(nonatomic,strong) OBColumnChart *sleepColumnChart; //周睡眠柱状图
@property(nonatomic,strong) UIView *bottomAverageView; //底部日平均值视图
@property(nonatomic,strong) UILabel *bottomDayAveSleep; //日睡眠平均值
@property(nonatomic,strong) UILabel *bottomDayAveDeepSleep; //日深睡睡眠平均值
@property(nonatomic,strong) UILabel *bottomDayAveLightSleep; //日浅睡睡眠平均值
@property(nonatomic,strong) NSMutableArray *dateArray; //周日期数据
@property(nonatomic,strong) NSMutableArray *dateArray2d; //周日期数据  存放每周的第一天跟最后一天的date 二维数组
@property(nonatomic,strong) NSMutableArray *currentTimeArray; //当前周数组 存放每天的二维数组
@property(nonatomic,strong) UIButton *currentSeletedButton; //当前选中按钮
@property(nonatomic,strong) NSMutableArray *weekSleepArray; //周睡眠数据

@end
#endif
@implementation SYWeekSleepViewController
#if TARGET_IPHONE_SIMULATOR
#else
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    //现获取日期数据
    [self getWeekDateArray];
    //从本地获取睡眠数据
    [self getWeekDataArray];
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    self.title = @"周睡眠详情";
    topViewHeight = kHeight(54);
    centerTimeViewHeight = kHeight(110);
    centerColumnViewHeight = kHeight(250);
    
    [self dateButtonAction:self.currentSeletedButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //视图frame设置及相关约束
    [self viewframeSet];
    
}
#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    [self.view addSubview:self.topDateView];
    [self.view addSubview:self.centerTimeView];
    [self.view addSubview:self.centerColumnView];
    [self.view addSubview:self.bottomAverageView];
    
}
- (void)addAction
{
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
}
- (void)viewframeSet
{
    self.topDateView.frame = CGRectMake(0, 0, kScreenWidth, topViewHeight);
    self.centerTimeView.frame = CGRectMake(0, self.topDateView.bottom, kScreenWidth, centerTimeViewHeight);
    self.centerColumnView.frame = CGRectMake(0, self.centerTimeView.bottom, kScreenWidth, centerColumnViewHeight);
    self.bottomAverageView.frame = CGRectMake(0, self.centerColumnView.bottom, kScreenWidth, self.view.height - self.centerColumnView.bottom);
//    self.centerColumnView.backgroundColor = RandomColor;
//    self.centerTimeView.backgroundColor = RandomColor;
}
- (void)addTopView
{
    NSArray *array = @[@"第一周",@"第二周",@"第三周",@"本周"];
//    NSArray *timearray = @[@"12.13~12.20",@"12.21~12.28",@"12.29~1.4",@"1.5~1.11"];
    for (int i = 0; i < 4; i++) {
       UIButton *button = [self createButtonWithName:array[i] subName:self.dateArray[i]];
        button.frame = CGRectMake(i * kScreenWidth/4.0, 0, kScreenWidth/4.0, kHeight(54));
        [button addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"tips"] forState:UIControlStateSelected];
        if (i == 3) {
            button.selected = YES;
            self.currentSeletedButton = button;
        }
//        button.backgroundColor = RandomColor;
        button.tag = 100 + i;
        [self.topDateView addSubview:button];
    }
}
- (void)addCenterSleepView
{
    //深睡
    UIImageView *deepImage = [[UIImageView alloc]init];
    deepImage.image = [UIImage imageNamed:@"ic_deepsleep"];
    UILabel *deepLabel0 = [[UILabel alloc]init];
    deepLabel0.text = @"深睡眠";
    deepLabel0.textColor = [UIColor lightGrayColor];
    deepLabel0.font = kFont(14.0);
    deepLabel0.textAlignment = NSTextAlignmentCenter;
    UILabel *deepLabel = [[UILabel alloc]init];
    deepLabel.text = @"小时";
    deepLabel.textColor = [UIColor lightGrayColor];
    deepLabel.font = kFont(14.0);
    deepLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *deepText = [[UILabel alloc]init];
    deepText.text = @"1.56";
    deepText.textColor = RGBColor(74, 172, 247);
    deepText.font = kFont(25.0);
    deepText.textAlignment = NSTextAlignmentCenter;
    self.deepText = deepText;
    
    //浅睡
    UIImageView *lightImage = [[UIImageView alloc]init];
    lightImage.image = [UIImage imageNamed:@"ic_poorsleep"];
    UILabel *lightSleepLabel0 = [[UILabel alloc]init];
    lightSleepLabel0.text = @"浅睡眠";
    lightSleepLabel0.textColor = [UIColor lightGrayColor];
    lightSleepLabel0.font = kFont(14.0);
    lightSleepLabel0.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lightLabel = [[UILabel alloc]init];
    lightLabel.text = @"小时";
    lightLabel.textColor = [UIColor lightGrayColor];
    lightLabel.font = kFont(14.0);
    lightLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *lightText = [[UILabel alloc]init];
    lightText.text = @"6.24";
    lightText.textColor = RGBColor(74, 172, 247);
    lightText.font = kFont(25.0);
    lightText.textAlignment = NSTextAlignmentCenter;
    self.lightSleepText = lightText;
    
    deepImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    deepImage.centerX = kScreenWidth/4.0 - kWidth(30);
    deepLabel0.frame = CGRectMake(deepImage.right, deepImage.top, kWidth(60) , kHeight(40));
    deepText.frame = CGRectMake(0, deepImage.bottom, kScreenWidth/2.0 , kHeight(40));
    deepLabel.frame = CGRectMake(0, deepText.bottom, kScreenWidth/2.0 , kHeight(30));
    lightImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    lightImage.centerX = kScreenWidth/4.0 * 3 - kWidth(30);
    lightSleepLabel0.frame = CGRectMake(lightImage.right, lightImage.top, kWidth(60) , kHeight(34));
    lightText.frame = CGRectMake(kScreenWidth/2.0, lightImage.bottom, kScreenWidth/2.0 , kHeight(40));
    lightLabel.frame = CGRectMake(kScreenWidth/2.0, lightText.bottom, kScreenWidth/2.0 , kHeight(30));
    
    [self.centerTimeView addSubview:deepImage];
    [self.centerTimeView addSubview:deepLabel0];
    [self.centerTimeView addSubview:deepLabel];
    [self.centerTimeView addSubview:deepText];
    [self.centerTimeView addSubview:lightImage];
    [self.centerTimeView addSubview:lightText];
    [self.centerTimeView addSubview:lightLabel];
    [self.centerTimeView addSubview:lightSleepLabel0];
    
}
- (void)addCenterCloumnView
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"本周睡眠趋势";
    label.textColor = RGBColor(136, 136, 136);
    label.font = kFont(14.0);
    label.frame = CGRectMake(kWidth(15), 0, kWidth(200), kHeight(30));
    [self.centerColumnView addSubview:label];
    OBColumnChart *column = [[OBColumnChart alloc] initWithFrame:CGRectMake(kWidth(20), label.bottom, kScreenWidth, kHeight(210))];
//    column.backgroundColor = [UIColor redColor];
    self.sleepColumnChart = column;
    column.valueArr = @[
                        @[@3,@5],
                        @[@2.2,@5.8],
                        @[@3.4,@4.3],
                        @[@2.1,@7.8],
                        @[@1.9,@2.8],
                        @[@1.2,@6.9],
                        @[@4.5,@15.9],
                        ];
    column.originSize = CGPointMake(kWidth(40), kHeight(40));
    /*    The first column of the distance from the starting point     */
    column.typeSpace = kWidth(25);
    column.columnSpace = 2;
    column.isShowYLine = NO;
    column.columnWidth = 8;
    column.xDescTextFontSize = 14.0;
    column.yDescTextFontSize = 14.0;
    column.drawTextColorForX_Y = RGBColor(172, 172, 172);
    column.colorForXYLine = [UIColor lightGrayColor];
    column.columnBGcolorsArr = @[[UIColor colorWithHexString:@"#44c0df"],[UIColor colorWithHexString:@"#7affdc"]];
    column.xShowInfoText = [self columnInfoTextArrayWithIndex:3];
//    column.xShowInfoText = @[@"周日\n4.24",@"周一\n4.24",@"周二\n4.24",@"周三\n4.24",@"周四\n4.24",@"周五\n4.24",@"周六\n4.24"];
    column.isShowLineChart = YES;
//    column.isShowYLine = YES;
//    column.lineValueArray =  @[@6,@12,@10,@1,@9,@5,@9,@9,@5,@6,@4,@8,@11];
    [column showAnimation];
    [self.centerColumnView addSubview:column];

    
}
- (void)addBottomTimeView
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"日平均值";
    label.textColor = RGBColor(136, 136, 136);
    label.font = kFont(14.0);
    label.frame = CGRectMake(kWidth(15), 0, kWidth(200), kHeight(30));
    [self.bottomAverageView addSubview:label];
    CGFloat leftEdge = kWidth(15);
    CGFloat Edge = kWidth(25);
    CGFloat imageWidth = (kScreenWidth - leftEdge * 2 - Edge * 2)/3.0;
    for (int i= 0; i< 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Edge + imageWidth) * i + leftEdge, label.bottom + kHeight(10), imageWidth, imageWidth)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.cornerRadius = imageWidth/2.0;
        imageView.layer.masksToBounds = YES;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blueColor].CGColor];
        gradientLayer.locations = @[@0, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 1.0);
        gradientLayer.frame = CGRectMake((Edge + imageWidth) * i + leftEdge, label.bottom + kHeight(10), imageWidth, imageWidth);
        gradientLayer.cornerRadius = imageWidth/2.0;
        gradientLayer.masksToBounds = YES;
        [self.bottomAverageView.layer addSublayer:gradientLayer];
        
        [self.bottomAverageView addSubview:imageView];
        UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight(20), imageView.width, kHeight(40))];
        timelabel.text = @"6.24";
        timelabel.textColor = [UIColor whiteColor];
        timelabel.font = kFont(30.0);
        timelabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:timelabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, timelabel.bottom, imageView.width, kHeight(20))];
        label.text = @"睡眠时间/日";
        label.textColor = [UIColor whiteColor];
        label.font = kFont(14.0);
        label.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:label];
        if (i == 0) {
            self.bottomDayAveSleep = timelabel;
            label.text = @"睡眠时间/日";
            timelabel.text = @"8.7";
            gradientLayer.colors = @[(__bridge id)RGBAlphaColor(238, 152, 78, 1).CGColor,(__bridge id)RGBAlphaColor(244, 144, 178, 0.6).CGColor];
        } else if (i == 1) {
            self.bottomDayAveDeepSleep = timelabel;
            label.text = @"深睡小时/日";
            timelabel.text = @"3.7";
            gradientLayer.colors = @[(__bridge id)RGBAlphaColor(160, 132, 198, 1).CGColor,(__bridge id)RGBAlphaColor(134, 210, 251, 0.6).CGColor];
        }else if (i == 2) {
            self.bottomDayAveLightSleep = timelabel;
            label.text = @"浅睡小时/日";
            timelabel.text = @"5.0";
            gradientLayer.colors = @[(__bridge id)RGBAlphaColor(91, 220, 121, 1).CGColor,(__bridge id)RGBAlphaColor(87, 221, 165, 0.6).CGColor];
        }
        
    }  

}

#pragma mark -Actions
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"swipeDirection -  --%ld",swipe.direction);
    NSInteger index = self.currentSeletedButton.tag - 100;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        //左滑
        if (index == self.dateArray.count - 1) {
            //最左边
            return;
        } else {
            UIButton *button = [self.topDateView viewWithTag:self.currentSeletedButton.tag + 1];
            [self dateButtonAction:button];
        }
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //右滑
        if (index == 0) {
            //最右边
            return;
        } else {
            UIButton *button = [self.topDateView viewWithTag:self.currentSeletedButton.tag - 1];
            [self dateButtonAction:button];
        }
    }
}
- (void)getWeekDataArray
{
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    Sharkey *sharkey =  [[WCDSharkeyFunction shareInitializationt] currentSharkey];
    for (int i = 0; i < self.currentTimeArray.count; i++) {
        NSMutableArray *array0 = [NSMutableArray array];
        NSArray *array = self.currentTimeArray[i];
        for (int i = 0; i < array.count; i ++) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@ AND userMobile == %@",array[i],model.mobile];
            NSArray *dateArray = [SleepDataModel MR_findAllWithPredicate:predicate];
            if (dateArray.count > 0) {
                [array0 addObject:dateArray[0]];
            } else {
                [array0 addObject:@""];
            }
        }
        [self.weekSleepArray addObject:array0];
    }

}
- (void)dateButtonAction:(UIButton *)button
{
    self.currentSeletedButton.selected = NO;
    NSInteger index = button.tag - 100;
    button.selected = YES;
    self.currentSeletedButton = button;
    self.sleepColumnChart.xShowInfoText =  [self columnInfoTextArrayWithIndex:index];
//    self.sleepColumnChart.valueArr =
    NSMutableArray *valArray = [NSMutableArray array];
    NSInteger totalSleep = 0;
    CGFloat totalDeep = 0;
    CGFloat totalLight = 0;
    if (self.weekSleepArray.count > index) {
        NSArray *weekArray = self.weekSleepArray[index];
        for (int i = 0; i < weekArray.count; i ++) {
            NSMutableArray *array = [NSMutableArray array];
            if (![weekArray[i] isKindOfClass:[SleepDataModel class]]) {
                //无数据
                [array addObject:@"0"];
                [array addObject:@"0"];
            } else {
                SleepDataModel *model = weekArray[i];
                NSLog(@"model.totalStep = %.2f",model.totalSleep);
                [array addObject:[NSString stringWithFormat:@"%.1f",model.deepSleep]];
                [array addObject:[NSString stringWithFormat:@"%.1f",model.lightSleep]];
                totalSleep += model.totalSleep ;
                totalDeep += model.deepSleep;
                totalLight += model.lightSleep;
            }
            [valArray addObject:array];
            
        }
    }
    self.sleepColumnChart.valueArr = valArray;
    self.deepText.text = [NSString stringWithFormat:@"%.1f",totalDeep];
    self.lightSleepText.text = [NSString stringWithFormat:@"%.1f",totalLight];
    self.bottomDayAveLightSleep.text = [NSString stringWithFormat:@"%.2f",totalLight/7];
    self.bottomDayAveDeepSleep.text = [NSString stringWithFormat:@"%.2f",totalDeep/7.0];
    self.bottomDayAveSleep.text = [NSString stringWithFormat:@"%.2f",totalSleep/7.0];
    [self.sleepColumnChart showAnimation];
}
#pragma mark - 一些时间 日期的换算
//获取解析周日期 数组
- (void)getWeekDateArray
{
    NSDate *date = [NSDate date];
    for (int i = 0; i < 4; i++) {
        //上一周
        //       NSDate *previousWeek = [startWeekDate previousWeek];
        NSString *str =  [self dateStringWithDate:date];
        [self.dateArray insertObject:str atIndex:0];
        date = [date previousWeek];
        
    }
    
}
//通过日期转化为周字符串 例：05.21~05.27
- (NSString *)dateStringWithDate:(NSDate *)date
{
    NSDate *startWeekDate = [date startOfWeek];
    NSDate *endWeekDate = [date endOfWeek];
    NSString *startWeekStr = [self monthAndDayStringWithDate:startWeekDate];
    NSString *endWeekStr = [self monthAndDayStringWithDate:endWeekDate];
    NSString *arrayStr = [NSString stringWithFormat:@"%@~%@",startWeekStr,endWeekStr];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:startWeekDate];
    [array addObject:endWeekDate];
    //转化为周日期二维数组 例如@[@[date1,date2],@[date1,date2]]
    [self.dateArray2d addObject:array];
    //转化为周每天的二维数组 例如@[@[05.21,05.22,05.23,05.24,05.25,05.26,05.27],@[05.28...]]
    [self getDateArrayWithDateArray:array];
    return arrayStr;
}
- (NSString *)monthAndDayStringWithDate:(NSDate *)date
{
    NSString *currentDateStr = [date formatYMD];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    NSString *string = [NSString stringWithFormat:@"%@.%@",dateArray[1],dateArray[2]];
    return string;
}

//获取一周的时间
- (void)getDateArrayWithDateArray:(NSArray *)array
{
    NSDate *date;
    if (array.count > 1) {
        date = array[0];
    }
    //    NSDate *weekDate = [date nextDay];
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSString *str =  [self monthAndDayStringWithDate:date];
        [array1 addObject:str];
        date = [date nextDay];
    }
    [self.currentTimeArray insertObject:array1 atIndex:0];
}
- (NSArray *)columnInfoTextArrayWithIndex:(NSInteger)index
{
    NSMutableArray *array0 = [NSMutableArray array];
    if (self.currentTimeArray.count > index) {
        NSArray *array = self.currentTimeArray[index];
        for (int i = 0;i< array.count;i++) {
            NSString *str = nil;
            if (i == 0) {
                str = [NSString stringWithFormat:@"周日\n%@",array[i]];
            } else if (i == 1) {
                str = [NSString stringWithFormat:@"周一\n%@",array[i]];
            } else if (i == 2) {
                str = [NSString stringWithFormat:@"周二\n%@",array[i]];
            } else if (i == 3) {
                str = [NSString stringWithFormat:@"周三\n%@",array[i]];
            } else if (i == 4) {
                str = [NSString stringWithFormat:@"周四\n%@",array[i]];
            } else if (i == 5) {
                str = [NSString stringWithFormat:@"周五\n%@",array[i]];
            } else if (i == 6) {
                str = [NSString stringWithFormat:@"周六\n%@",array[i]];
            }
            [array0 addObject:str];
        }
    }
    return array0;
}

#pragma maek - private methods  私有方法
- (UIButton *)createButtonWithName:(NSString *)name subName:(NSString *)subName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:[NSString stringWithFormat:@"%@\n%@",name,subName] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%@",subName] forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button setTitleColor:RGBColor(179, 183, 186) forState:UIControlStateNormal];
    [button setTitleColor:RGBColor(58, 190, 249) forState:UIControlStateSelected];
    button.titleLabel.font = kFont(14.0);
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
//    button.backgroundColor = RandomColor;
    return button;
}
#pragma mark - getter and setter

- (NSMutableArray *)weekDateArray
{
    if (_weekDateArray == nil) {
        _weekDateArray = [[NSMutableArray alloc]init];
    }
    return _weekDateArray;
}
- (UIView *)topDateView
{
    if (_topDateView == nil) {
        _topDateView = [[UIView alloc]init];
        [self addTopView];
    }
    return _topDateView;
}
- (UIView *)centerTimeView
{
    if (_centerTimeView == nil) {
        _centerTimeView = [[UIView alloc]init];
        [self addCenterSleepView];
    }
    return _centerTimeView;
}
- (UILabel *)deepText
{
    if (_deepText == nil) {
        _deepText = [[UILabel alloc]init];
        _deepText.text = @"1.56";
        _deepText.textColor = RGBColor(74, 172, 247);
        _deepText.font = kFont(35.0);
        _deepText.textAlignment = NSTextAlignmentCenter;
    }
    return _deepText;
}
- (UILabel *)lightSleepText
{
    if (_lightSleepText == nil) {
        _lightSleepText = [[UILabel alloc]init];
        _lightSleepText.text = @"6.24";
        _lightSleepText.textColor = RGBColor(74, 172, 247);
        _lightSleepText.font = kFont(35.0);
        _lightSleepText.textAlignment = NSTextAlignmentCenter;
    }
    return _lightSleepText;
}
- (UIView *)centerColumnView
{
    if (_centerColumnView == nil) {
        _centerColumnView = [[UIView alloc]init];
        [self addCenterCloumnView];
    }
    return _centerColumnView;
}
- (UIView *)bottomAverageView
{
    if (_bottomAverageView == nil) {
        _bottomAverageView = [[UIView alloc]init];
        [self addBottomTimeView];
    }
    return _bottomAverageView;
}
- (NSMutableArray *)dateArray
{
    if (_dateArray == nil) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}
- (NSMutableArray *)dateArray2d
{
    if (_dateArray2d == nil) {
        _dateArray2d = [[NSMutableArray alloc]init];
    }
    return _dateArray2d;
}
- (NSMutableArray *)currentTimeArray
{
    if (_currentTimeArray == nil) {
        _currentTimeArray = [[NSMutableArray alloc]init];
    }
    return _currentTimeArray;
}
- (NSMutableArray *)weekSleepArray
{
    if (_weekSleepArray == nil) {
        _weekSleepArray = [[NSMutableArray alloc]init];
    }
    return _weekSleepArray;
}
#endif
@end

