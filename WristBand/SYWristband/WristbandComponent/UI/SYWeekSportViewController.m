//
//  SYWeekSportViewController.m
//  SYWristband
//
//  Created by obally on 17/5/19.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYWeekSportViewController.h"
#import "JHLineChart.h"
#import "SportDataModel+CoreDataClass.h"

@interface SYWeekSportViewController ()
{
    CGFloat topViewHeight;
    CGFloat centerTimeViewHeight;
    CGFloat centerColumnViewHeight;
    CGFloat bottomAverageViewHeight;
}
@property(nonatomic,strong) UIView *topDateView; //顶部日期时间视图
@property(nonatomic,strong) UIView *centerTimeView; //中间步数 公里数时间视图
@property(nonatomic,strong) NSMutableArray *weekDateArray; //周时间数组
@property(nonatomic,strong) UILabel *stepText; //步数
@property(nonatomic,strong) UILabel *distantText; //公里数
@property(nonatomic,strong) UILabel *carText; //大卡
@property(nonatomic,strong) UIView *centerColumnView; //中间柱状时间视图
@property(nonatomic,strong) JHLineChart *stepChart; //周柱状图
@property(nonatomic,strong) UIView *bottomAverageView; //底部日平均值视图
@property(nonatomic,strong) UILabel *bottomDayAveStep; //日步数平均值
@property(nonatomic,strong) UILabel *bottomDayAveKcalStep; //日热量平均值
@property(nonatomic,strong) UILabel *bottomDayAveDistant; //日公里平均值
//@property(nonatomic,strong) UILabel *bottomLabel; //日浅睡睡眠平均值
@property(nonatomic,strong) NSMutableArray *dateArray; //周日期数据
@property(nonatomic,strong) NSMutableArray *dateArray2d; //周日期数据  存放每周的第一天跟最后一天的date 二维数组
@property(nonatomic,strong) NSMutableArray *currentTimeArray; //当前周数组 存放每天的二维数组
@property(nonatomic,strong) UIButton *currentSeletedButton; //当前选中按钮

@property(nonatomic,strong) NSMutableArray *weekSportArray; //周运动数据

@end

@implementation SYWeekSportViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    //现获取日期数据
    [self getWeekDateArray];
    [self getWeekSportDataArray];
    //添加相关视图
    [self addView];
    //相关视图事件添加
    [self addAction];
    self.title = @"周运动详情";
    topViewHeight = kHeight(54);
    centerTimeViewHeight = kHeight(110);
    centerColumnViewHeight = kHeight(250);
    //设置选中
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
    self.centerTimeView.frame = CGRectMake(0, self.topDateView.bottom + kHeight(13), kScreenWidth, centerTimeViewHeight);
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
        [button setBackgroundImage:[UIImage imageNamed:@"tips"] forState:UIControlStateSelected];
        button.frame = CGRectMake(i * kScreenWidth/4.0, 0, kScreenWidth/4.0, kHeight(54));
        [button addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 3) {
            button.selected = YES;
            self.currentSeletedButton = button;
        }
        button.tag = 100 + i;
        [self.topDateView addSubview:button];
    }
}
- (void)addCenterSleepView
{
    //步数
    UIImageView *stepImage = [[UIImageView alloc]init];
    stepImage.image = [UIImage imageNamed:@"ic_step"];
    UILabel *stepLabel = [[UILabel alloc]init];
    stepLabel.text = @"步";
    stepLabel.textColor = [UIColor lightGrayColor];
    stepLabel.font = kFont(14.0);
    stepLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *stepText = [[UILabel alloc]init];
    stepText.text = @"10000";
    stepText.textColor = RGBColor(74, 172, 247);
    stepText.font = kFont(25.0);
    stepText.textAlignment = NSTextAlignmentCenter;
    self.stepText = stepText;
    
    //公里
    UIImageView *lightImage = [[UIImageView alloc]init];
    lightImage.image = [UIImage imageNamed:@"ic_km"];
    UILabel *distantLabel = [[UILabel alloc]init];
    distantLabel.text = @"公里";
    distantLabel.textColor = [UIColor lightGrayColor];
    distantLabel.font = kFont(14.0);
    distantLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *distantText = [[UILabel alloc]init];
    distantText.text = @"6.24";
    distantText.textColor = RGBColor(74, 172, 247);
    distantText.font = kFont(25.0);
    distantText.textAlignment = NSTextAlignmentCenter;
    self.distantText = distantText;
    
    //大卡
    UIImageView *carImage = [[UIImageView alloc]init];
    carImage.image = [UIImage imageNamed:@"ic_kal"];
    UILabel *carLabel = [[UILabel alloc]init];
    carLabel.text = @"大卡";
    carLabel.textColor = [UIColor lightGrayColor];
    carLabel.font = kFont(14.0);
    carLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *carText = [[UILabel alloc]init];
    carText.text = @"320";
    carText.textColor = RGBColor(74, 172, 247);
    carText.font = kFont(25.0);
    carText.textAlignment = NSTextAlignmentCenter;
    self.carText = carText;
    
    CGFloat width = kScreenWidth/3.0;
//    CGFloat stepleft = kWidth(20);
    stepImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    stepImage.centerX = kScreenWidth/6.0;
    stepText.frame = CGRectMake(0, stepImage.bottom, width, kHeight(40));
    stepLabel.frame = CGRectMake(0, stepText.bottom, width, kHeight(30));
//    CGFloat distantleft = kWidth(20) + kScreenWidth/3.0;
    lightImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    lightImage.centerX = kScreenWidth/6.0 * 3;
    distantText.frame = CGRectMake(width, lightImage.bottom, width, kHeight(40));
    distantLabel.frame = CGRectMake(width, distantText.bottom, width, kHeight(30));
    CGFloat calorieleft = kWidth(20) + kScreenWidth/3.0 * 2;
    carImage.frame = CGRectMake(calorieleft, 0, kWidth(34), kHeight(34));
    carImage.centerX = kScreenWidth/6.0 * 5;
    carText.frame = CGRectMake(width * 2, carImage.bottom, width, kHeight(40));
    carLabel.frame = CGRectMake(width * 2, carText.bottom, width, kHeight(30));
    
    [self.centerTimeView addSubview:stepImage];
    [self.centerTimeView addSubview:stepLabel];
    [self.centerTimeView addSubview:stepText];
    [self.centerTimeView addSubview:lightImage];
    [self.centerTimeView addSubview:distantText];
    [self.centerTimeView addSubview:distantLabel];
    [self.centerTimeView addSubview:carImage];
    [self.centerTimeView addSubview:carText];
    [self.centerTimeView addSubview:carLabel];
    
}
- (void)addCenterCloumnView
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"本周运动趋势";
    label.textColor = RGBColor(136, 136, 136);
    label.font = kFont(14.0);
    label.frame = CGRectMake(kWidth(15), 0, kWidth(200), kHeight(30));
    [self.centerColumnView addSubview:label];
    
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(kWidth(10), label.bottom,kScreenWidth - kWidth(20), kHeight(220)) andLineChartType:JHChartLineValueNotForEveryX];
//    lineChart.xLineDataArr = @[@"周日\n4.24",@"周日\n4.24",@"周日\n4.24",@"周日\n4.24",@"周日\n4.24",@"周日\n4.24",@"周日\n4.24"];
    self.stepChart = lineChart;
    lineChart.xLineDataArr = [self columnInfoTextArrayWithIndex:3];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    lineChart.chartOrigin = CGPointMake(30, lineChart.chartOrigin.y);
    lineChart.valueArr = @[@[@0,@0,@0,@0,@0,@0,@0]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = NO;
    lineChart.showValueLeadingLine = NO;
//    lineChart.valueFontSize = kFont(<#a#>);
    lineChart.valueFontSize = kWidth(14);
    lineChart.backgroundColor = [UIColor clearColor];
    lineChart.pointColorArr = @[[UIColor colorWithRed:61.0/255 green:201.0/255 blue:255.0/255 alpha:1]];
    lineChart.valueLineColorArr =@[[UIColor colorWithRed:61.0/255 green:201.0/255 blue:255.0/255 alpha:1]];;
    lineChart.xAndYLineColor = [UIColor blackColor];
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    lineChart.contentFill = YES;
    lineChart.pathCurve = YES;
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:61.0/255 green:201.0/255 blue:255.0/255 alpha:0.268]];
    [self.centerColumnView addSubview:lineChart];
    [lineChart showAnimation];
    
    
}
- (void)addBottomTimeView
{
    UILabel *label = [[UILabel alloc]init];
    label.text = @"日平均值";
    label.textColor = RGBColor(136, 136, 136);
    label.font = kFont(14.0);
    label.frame = CGRectMake(kWidth(15), kHeight(10), kWidth(200), kHeight(30));
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
        timelabel.font = kFont(26.0);
        timelabel.textAlignment = NSTextAlignmentCenter;
//        [gradientLayer addSublayer:timelabel.layer];
        [imageView addSubview:timelabel];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, timelabel.bottom, imageView.width, kHeight(20))];
        label1.text = @"睡眠时间/日";
        label1.textColor = [UIColor whiteColor];
        label1.font = kFont(14.0);
        label1.textAlignment = NSTextAlignmentCenter;
//        [gradientLayer addSublayer:label1.layer];
//        self.bottomDayAveDistant = label1;
        [imageView addSubview:label1];
        if (i == 0) {
            self.bottomDayAveStep = timelabel;
            label1.text = @"步/日";
            timelabel.text = @"10230";
            gradientLayer.colors = @[(__bridge id)RGBAlphaColor(85, 142, 203, 1).CGColor,(__bridge id)RGBAlphaColor(115, 218, 251, 0.6).CGColor];
        } else if (i == 1) {
            self.bottomDayAveKcalStep = timelabel;
            label1.text = @"大卡/日";
            timelabel.text = @"37";
            gradientLayer.colors = @[(__bridge id)RGBAlphaColor(244, 145, 90, 1).CGColor,(__bridge id)RGBAlphaColor(240, 208, 108, 0.6).CGColor];
        }else if (i == 2) {
            self.bottomDayAveDistant = timelabel;
            label1.text = @"公里/日";
            timelabel.text = @"5.0";
            gradientLayer.colors = @[(__bridge id)RGBAlphaColor(108, 90, 189, 1).CGColor,(__bridge id)RGBAlphaColor(196, 133, 209, 1).CGColor];
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

- (void)dateButtonAction:(UIButton *)button
{
    self.currentSeletedButton.selected = NO;
    NSInteger index = button.tag - 100;
    button.selected = YES;
    self.currentSeletedButton = button;
    self.stepChart.xLineDataArr =  [self columnInfoTextArrayWithIndex:index];
    NSMutableArray *valArray = [NSMutableArray array];
    NSInteger totalStep = 0;
    CGFloat totalkCal = 0;
    CGFloat totalDistant = 0;
    if (self.weekSportArray.count > index) {
        NSArray *array = self.weekSportArray[index];
        for (int i = 0; i < array.count; i ++) {
            if (![array[i] isKindOfClass:[SportDataModel class]]) {
                //无数据
                [valArray addObject:@"0"];
            } else {
                SportDataModel *model = array[i];
                NSLog(@"model.totalStep = %d ,date =  %@ ",model.totalStep,model.date);
                [valArray addObject:[NSString stringWithFormat:@"%d",model.totalStep]];
                totalStep += model.totalStep;
                totalkCal += model.calorie;
                totalDistant += model.distant;
            }
                
        }
    }
    NSMutableArray *array2 = [NSMutableArray arrayWithObject:valArray];
    self.stepChart.valueArr =(NSArray *)array2;
    self.stepText.text = [NSString stringWithFormat:@"%ld",totalStep];
    self.distantText.text = [NSString stringWithFormat:@"%.2f",totalDistant];
    self.carText.text = [NSString stringWithFormat:@"%.2f",totalkCal];
    self.bottomDayAveStep.text = [NSString stringWithFormat:@"%ld",totalStep/7];
    self.bottomDayAveKcalStep.text = [NSString stringWithFormat:@"%.2f",totalkCal/7.0];
    self.bottomDayAveDistant.text = [NSString stringWithFormat:@"%.2f",totalDistant/7.0];
    [self.stepChart showAnimation];
}
#pragma mark - 一些时间 日期的换算
//从本地读取数据
- (void)getWeekSportDataArray
{
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    Sharkey *sharkey =  [[WCDSharkeyFunction shareInitializationt] currentSharkey];
    for (int i = 0; i < self.currentTimeArray.count; i++) {
        NSMutableArray *array0 = [NSMutableArray array];
        NSArray *array = self.currentTimeArray[i];
        for (int i = 0; i < array.count; i ++) {
            NSLog(@"%@----日期--date",array[i]);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@ AND userMobile == %@",array[i],model.mobile];
            NSArray *dateArray = [SportDataModel MR_findAllWithPredicate:predicate];
            if (dateArray.count > 0) {
                [array0 addObject:dateArray[0]];
                SportDataModel *model = dateArray[0];
                NSLog(@"model.totalStep = %d ,date =  %@ ",model.totalStep,model.date);
            } else {
                [array0 addObject:@""];
            }
        }
        [self.weekSportArray addObject:array0];
    }
}
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
- (UILabel *)stepText
{
    if (_stepText == nil) {
        _stepText = [[UILabel alloc]init];
        _stepText.text = @"1.56";
        _stepText.textColor = RGBColor(74, 172, 247);
        _stepText.font = kFont(35.0);
        _stepText.textAlignment = NSTextAlignmentCenter;
    }
    return _stepText;
}
- (UILabel *)distantText
{
    if (_distantText == nil) {
        _distantText = [[UILabel alloc]init];
        _distantText.text = @"6.24";
        _distantText.textColor = RGBColor(74, 172, 247);
        _distantText.font = kFont(35.0);
        _distantText.textAlignment = NSTextAlignmentCenter;
    }
    return _distantText;
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
- (NSMutableArray *)weekSportArray
{
    if (_weekSportArray == nil) {
        _weekSportArray = [[NSMutableArray alloc]init];
    }
    return _weekSportArray;
}
@end
