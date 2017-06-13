//
//  SYSleepViewController.m
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYSleepViewController.h"
#import "SYSleepView.h"
#import "NSDate+Extension.h"
#import "SYWeekSleepViewController.h"
#import "SleepDataModel+CoreDataClass.h"
#import "SportDataModel+CoreDataClass.h"
#import "SYHealthModel.h"

@interface SYSleepViewController ()<UIGestureRecognizerDelegate,WCDSharkeyFunctionDelegate>
@property(nonatomic,strong)WCDSharkeyFunction *shareKey;
@property(nonatomic,strong)UIScrollView *timeScrollView; //时间滚动视图
@property(nonatomic,strong) NSMutableArray *timeArray; //时间数组
@property(nonatomic,strong)UIView *dataView; // 睡眠数据展示视图
@property(nonatomic,strong)SYSleepView *sleepView; //睡眠视图
@property(nonatomic,strong)NSMutableArray *sleepArray;
@property(nonatomic,strong)NSMutableDictionary *sleepDic; //@{@"7":@[@"12",@"5",@"7"],@"6":@[@"12",@"5",@"7"]...}
@property(nonatomic,strong)UIButton *lastSelectedButton; //上一次选中的按钮
@property(nonatomic,strong)UIView *centerView; //深睡浅睡视图
@property(nonatomic,strong) UIImageView *deepImage; //深睡图片
@property(nonatomic,strong) UILabel *deepText; //深睡数
@property(nonatomic,strong) UILabel *deepLabel; //深睡
@property(nonatomic,strong) UILabel *deepLabel0; //深睡
@property(nonatomic,strong) UIImageView *lightSleepImage; //浅睡图片
@property(nonatomic,strong) UILabel *lightSleepText; //浅睡
@property(nonatomic,strong) UILabel *lightSleepLabel; //浅睡
@property(nonatomic,strong) UILabel *lightSleepLabel0; //浅睡
@property(nonatomic,strong)UIButton *weekSleepbutton; //周睡眠详情
@property(nonatomic,strong) NSArray *healthArray;

@end

@implementation SYSleepViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.timeArray = @[@"12.26",@"12.27",@"12.28",@"12.29",@"12.30",@"12.31",@"01.01",@"01.06",@"今天"];
//    self.sleepArray = @[@11,@5.9,@8.0,@6.5,@7.5,@10.0,@7.9,];
    [self getDateArray];
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
    
//    [self requestCurrentSleepDataFormWrist];

}
//获取已知数据
-(void)requestCurrentSleepDataFormWrist
{
    [[WCDSharkeyFunction shareInitializationt] querySleepDataFromSharkey];
}
#pragma mark - 视图、action 添加  frame设置
- (void)addView
{
    //为了解决控制器view 的第一个子视图是uiscrollView  scrollView 的子视图会下移的情况  http://blog.csdn.net/xdrt81y/article/details/27208989
    UIView *tempBackGround = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tempBackGround];
    [self.view addSubview:self.timeScrollView];
    CGFloat width = kWidth(44);
    CGFloat edge = kWidth(10);
    self.timeScrollView.contentSize = CGSizeMake(self.timeArray.count * (width + edge),0);
    CGPoint position =  CGPointMake(self.timeScrollView.contentSize.width - kScreenWidth, 0);
    [self.timeScrollView setContentOffset:position animated:YES];
    for (int i = 0; i < self.timeArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((edge + width) * i + edge, kHeight(5), width, kHeight(44));
        [button setTitle:[self.timeArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_choosetip1"] forState:UIControlStateSelected];
        if (i == self.timeArray.count - 1) {
            button.selected = YES;
            self.lastSelectedButton = button;
        }
        button.titleLabel.font = kFont(14.0);
        button.tag = i + 100;
        //        button.backgroundColor = [UIColor greenColor];
        [button addTarget:self action:@selector(didClickHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeScrollView addSubview:button];
        
    }
    [self.view addSubview:self.dataView];
    [self.dataView addSubview:self.sleepView];
    [self.view addSubview:self.centerView];
    [self.centerView addSubview:self.deepImage];
    [self.centerView addSubview:self.deepText];
    [self.centerView addSubview:self.deepLabel0];
    [self.centerView addSubview:self.deepLabel];
    [self.centerView addSubview:self.lightSleepImage];
    [self.centerView addSubview:self.lightSleepLabel0];
    [self.centerView addSubview:self.lightSleepLabel];
    [self.centerView addSubview:self.lightSleepText];
    [self.view addSubview:self.weekSleepbutton];
    
}
- (void)addAction
{
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dataView addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.dataView addGestureRecognizer:rightSwipeGesture];
    
    [self.weekSleepbutton addTarget:self action:@selector(weekSleepAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewframeSet
{
    self.timeScrollView.frame =CGRectMake(0, 0, kScreenWidth, kHeight(54));
    self.dataView.frame = CGRectMake(0, self.timeScrollView.bottom, kScreenWidth, kHeight(274));
    self.centerView.frame = CGRectMake(0, self.dataView.bottom, kScreenWidth, kHeight(150));
    self.deepImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    self.deepImage.centerX = kScreenWidth/4.0 - kWidth(30);
    self.deepLabel0.frame = CGRectMake(self.deepImage.right, self.deepImage.top, kWidth(60) , kHeight(34));
    self.deepText.frame = CGRectMake(0, self.deepImage.bottom, kScreenWidth/2.0 , kHeight(56));
    self.deepLabel.frame = CGRectMake(0, self.deepText.bottom, kScreenWidth/2.0 , kHeight(30));
    self.lightSleepImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    self.lightSleepImage.centerX = kScreenWidth/4.0 * 3 - kWidth(30);
    self.lightSleepLabel0.frame = CGRectMake(self.lightSleepImage.right, self.lightSleepImage.top, kWidth(60) , kHeight(34));
    self.lightSleepText.frame = CGRectMake(kScreenWidth/2.0, self.lightSleepImage.bottom, kScreenWidth/2.0 , kHeight(56));
    self.lightSleepLabel.frame = CGRectMake(kScreenWidth/2.0, self.lightSleepText.bottom, kScreenWidth/2.0 , kHeight(30));
    
    self.centerView.height = self.lightSleepLabel.bottom;
    self.weekSleepbutton.frame = CGRectMake((kScreenWidth - kWidth(200))/2.0, self.centerView.bottom +kHeight(21), kWidth(180), kHeight(48));
    
}
#pragma mark -Actions
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    NSLog(@"swipeDirection -  --%ld",swipe.direction);
    NSInteger index = self.lastSelectedButton.tag - 100;
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        //左滑
        if (index == self.timeArray.count - 1) {
            //最左边
            return;
        } else {
            UIButton *button = [self.timeScrollView viewWithTag:self.lastSelectedButton.tag + 1];
            [self didClickHeadButtonAction:button];
        }
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //右滑
        if (index == 0) {
            //最右边
            return;
        } else {
            UIButton *button = [self.timeScrollView viewWithTag:self.lastSelectedButton.tag - 1];
            [self didClickHeadButtonAction:button];
        }
    }
}
- (void)didClickHeadButtonAction:(UIButton *)button
{
    self.lastSelectedButton.selected = NO;
    NSInteger index =  button.tag - 100;
    button.selected = YES;
    self.lastSelectedButton = button;

//    if (self.sleepArray.count > index) {
//        self.sleepView.sleepCount = [self.sleepArray[index] floatValue];
//    }
    if (index * (button.width + kWidth(10)) + kScreenWidth > self.timeScrollView.contentSize.width) {
        CGPoint position =  CGPointMake(self.timeScrollView.contentSize.width - kScreenWidth, 0);
        [self.timeScrollView setContentOffset:position animated:YES];
    } else {
        CGPoint position =  CGPointMake(index * (button.width + kWidth(10)), 0);
        [self.timeScrollView setContentOffset:position animated:YES];
        
    }
    NSArray *array =  [self.sleepDic objectForKey:[NSNumber numberWithInteger:index]];
    if (array.count > 0) {
        self.sleepView.sleepCount = [array[0] floatValue];
        self.deepText.text = array[1];
        self.lightSleepText.text = array[2];
    } else {
        //先从本地获取数据 本地没有再从服务器请求睡眠数据
        [self getSleepDateFormSqlWithDateString:self.timeArray[index]];
        
    }
    
}
//周睡眠
- (void)weekSleepAction
{
    SYWeekSleepViewController *weekSleep = [[SYWeekSleepViewController alloc]init];
    [self.navigationController pushViewController:weekSleep animated:YES];
}
#pragma mark - 数据请求
//从本地获取这一天的睡眠数据
- (void)getSleepDateFormSqlWithDateString:(NSString *)dateString
{
//    Sharkey *sharKey = [self.shareKey currentSharkey];
    SYLoginInfoModel *model = [SYUserDataManager manager].userLoginInfoModel;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@ AND userMobile == %@",dateString,model.mobile];
    NSArray *array =  [SleepDataModel MR_findAll];
    for (SleepDataModel *model in array) {
        NSLog(@"model---------%@--",model.date);
    }
    NSArray *dataArray = [SleepDataModel MR_findAllWithPredicate:predicate];
    if (dataArray.count > 0) {
        SleepDataModel *model = dataArray[0];
        self.sleepView.sleepCount = model.totalSleep;
        self.deepText.text = [NSString stringWithFormat:@"%.2f",model.deepSleep];
        self.lightSleepText.text = [NSString stringWithFormat:@"%.2f",model.lightSleep];
    } else {
        //
        self.sleepView.sleepCount = 0;
        self.deepText.text = @"0.00";
        self.lightSleepText.text = @"0.00";
//        for (SYHealthModel *healthModel in self.healthArray) {
//            NSArray *array = [healthModel.date componentsSeparatedByString:@"-"];
//            NSString *str = nil;
//            if (array.count > 2) {
//                str = [NSString stringWithFormat:@"%@.%@",array[1],array[2]];
//                if ([str isEqualToString:dateString]) {
//                    self.sleepView.sleepCount = [healthModel.totalSleepTime floatValue];
//                    self.deepText.text = healthModel.deepSleetTime;
//                    self.lightSleepText.text = healthModel.lightSleepTime;
//                }
//            }
//        }
    }
    
}

#pragma mark - private method  私有方法
//获取一周的时间
- (void)getDateArray
{
    NSDate *date = [NSDate date];
    NSDate *weekDate = [[date previousWeek]nextDay];
    for (int i = 0; i < 7; i++) {
        if (i == 6) {
            //今天
            [self.timeArray addObject:@"今天"];
        } else {
            NSString *str =  [self monthAndDayStringWith:weekDate];
            [self.timeArray addObject:str];
            weekDate = [weekDate nextDay];
        }
    }
}
- (NSString *)monthAndDayStringWith:(NSDate *)date
{
    NSString *currentDateStr = [date formatYMD];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    NSString *string = [NSString stringWithFormat:@"%@.%@",dateArray[1],dateArray[2]];
    return string;
}
#pragma mark - WCDSharkeyFunctionDelegate
//睡眠数据
- (void)WCDQuerySleepDataFromSharkeyCallBack:(NSUInteger)startMinute rawData:(NSData *)rawData gatherRate:(SleepDataGatherRate)gatherRate
{
    SleepDataInfo *sleep = [[SleepDataInfo alloc]init];
    sleep =  [self.shareKey analyseSleep:startMinute data:rawData gatherRate:gatherRate];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:sleep.startMinute*60.0];
    NSString* startString = [formatter stringFromDate:date];
    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:sleep.de*60.0];
    NSString* deepString = [NSString stringWithFormat:@"%.2f",sleep.deepMinute/60.0];
    NSString* lightString = [NSString stringWithFormat:@"%.2f",sleep.lightMinute/60.0];
    NSString* total = [NSString stringWithFormat:@"%.2f",sleep.totalMinute/60.0];
    NSLog(@"睡眠开始时间 ----------%@",startString);
    NSLog(@"深睡时间 ----------%@",deepString);
    NSLog(@"浅睡时间 ----------%@",lightString);
    NSLog(@"总睡眠时间 ----------%@",total);
    
}

#pragma mark - getter and setter

- (NSMutableArray *)timeArray
{
    if (_timeArray == nil) {
        _timeArray = [[NSMutableArray alloc]init];
    }
    return _timeArray;
}
- (UIScrollView *)timeScrollView
{
    if (_timeScrollView == nil) {
        _timeScrollView = [[UIScrollView alloc]init];
        _timeScrollView.alwaysBounceHorizontal = YES;
        _timeScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _timeScrollView;
}
- (SYSleepView *)sleepView
{
    if (_sleepView == nil) {
        _sleepView = [[SYSleepView alloc]initWithFrame:CGRectMake((kScreenWidth - kWidth(250))/2.0, kHeight(20),kWidth(250), kWidth(250))];
        _sleepView.sleepCount = 0;
        _sleepView.targetSleepCount = 12;
        _sleepView.roundView.roundWidth = 12;
        _sleepView.roundView.leftEndGradientColor = RGBColor(74, 207, 228);
        _sleepView.roundView.leftCenterGradientColor =  [UIColor colorWithHexString:@"#57BCD6"];
        _sleepView.roundView.leftBeginGradientColor =  [UIColor colorWithHexString:@"#92FAD1"];
        _sleepView.roundView.rightCenterGradientColor =  [UIColor colorWithHexString:@"#94F0E3"];
        _sleepView.roundView.rightBeginGradientColor = [UIColor colorWithHexString:@"#92FAD1"];
        _sleepView.roundView.rightEndGradientColor = RGBColor(74, 207, 228);
    }
    return _sleepView;
}
- (UIView *)dataView
{
    if (_dataView == nil) {
        _dataView = [[UIView alloc]init];
        _dataView.userInteractionEnabled = YES;
    }
    return _dataView;
}
- (UIView *)centerView
{
    if (_centerView == nil) {
        _centerView = [[UIView alloc]init];
    }
    return _centerView;
}
- (UIImageView *)deepImage
{
    if (_deepImage == nil) {
        _deepImage = [[UIImageView alloc]init];
        _deepImage.image = [UIImage imageNamed:@"ic_deepsleep"];
    }
    return _deepImage;
}
- (UILabel *)deepLabel0
{
    if (_deepLabel0 == nil) {
        _deepLabel0 = [[UILabel alloc]init];
        _deepLabel0.text = @"深睡眠";
        _deepLabel0.textColor = [UIColor lightGrayColor];
        _deepLabel0.font = kFont(14.0);
        _deepLabel0.textAlignment = NSTextAlignmentCenter;
    }
    return _deepLabel0;
}
- (UILabel *)deepLabel
{
    if (_deepLabel == nil) {
        _deepLabel = [[UILabel alloc]init];
        _deepLabel.text = @"小时";
        _deepLabel.textColor = [UIColor lightGrayColor];
        _deepLabel.font = kFont(14.0);
        _deepLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _deepLabel;
}
- (UILabel *)deepText
{
    if (_deepText == nil) {
        _deepText = [[UILabel alloc]init];
        _deepText.text = @"0";
        _deepText.textColor = RGBColor(74, 172, 247);
        _deepText.font = kFont(35.0);
        _deepText.textAlignment = NSTextAlignmentCenter;
    }
    return _deepText;
}
- (UIImageView *)lightSleepImage
{
    if (_lightSleepImage == nil) {
        _lightSleepImage = [[UIImageView alloc]init];
        _lightSleepImage.image = [UIImage imageNamed:@"ic_poorsleep"];
    }
    return _lightSleepImage;
}
- (UILabel *)lightSleepText
{
    if (_lightSleepText == nil) {
        _lightSleepText = [[UILabel alloc]init];
        _lightSleepText.text = @"0";
        _lightSleepText.textColor = RGBColor(74, 172, 247);
        _lightSleepText.font = kFont(35.0);
        _lightSleepText.textAlignment = NSTextAlignmentCenter;
    }
    return _lightSleepText;
}
- (UILabel *)lightSleepLabel0
{
    if (_lightSleepLabel0 == nil) {
        _lightSleepLabel0 = [[UILabel alloc]init];
        _lightSleepLabel0.text = @"浅睡眠";
        _lightSleepLabel0.textColor = [UIColor lightGrayColor];
        _lightSleepLabel0.font = kFont(14.0);
        _lightSleepLabel0.textAlignment = NSTextAlignmentCenter;
    }
    return _lightSleepLabel0;
}
- (UILabel *)lightSleepLabel
{
    if (_lightSleepLabel == nil) {
        _lightSleepLabel = [[UILabel alloc]init];
        _lightSleepLabel.text = @"小时";
        _lightSleepLabel.textColor = [UIColor lightGrayColor];
        _lightSleepLabel.font = kFont(14.0);
        _lightSleepLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lightSleepLabel;
}
- (UIButton *)weekSleepbutton
{
    if (_weekSleepbutton == nil) {
        _weekSleepbutton = [[UIButton alloc]init];
        [_weekSleepbutton setTitle:@"查看周睡眠详情" forState:UIControlStateNormal];
        [_weekSleepbutton setTitleColor:[UIColor colorWithHexString:@"#71CBE5"] forState:UIControlStateNormal];
        _weekSleepbutton.titleLabel.font = kFont(18.0);
        _weekSleepbutton.layer.masksToBounds = YES;
        _weekSleepbutton.layer.cornerRadius = 24;
        _weekSleepbutton.layer.borderColor = [UIColor colorWithHexString:@"#71CBE5"].CGColor;
        _weekSleepbutton.layer.borderWidth = 2;
    }
    return _weekSleepbutton;
}
- (NSMutableArray *)sleepArray
{
    if (_sleepArray == nil) {
        _sleepArray = [[NSMutableArray alloc]init];
    }
    return _sleepArray;
}
- (NSMutableDictionary *)sleepDic
{
    if (_sleepDic == nil) {
        _sleepDic = [[NSMutableDictionary alloc]init];
    }
    return _sleepDic;
}
- (void)setSleepData:(NSMutableArray *)sleepData
{
    _sleepData = sleepData;
    [self.sleepDic setObject:sleepData forKey:@5];
    [self didClickHeadButtonAction:self.lastSelectedButton];
}
- (NSArray *)healthArray
{
    if (_healthArray == nil) {
        _healthArray = [[NSArray alloc]init];
    }
    return _healthArray;
}
@end
