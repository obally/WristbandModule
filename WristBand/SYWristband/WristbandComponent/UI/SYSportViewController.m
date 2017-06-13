//
//  SYSportViewController.m
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYSportViewController.h"
#import "OBSportView.h"
#import "SYWeekSportViewController.h"
#import "SleepDataModel+CoreDataClass.h"
@interface SYSportViewController ()<UIGestureRecognizerDelegate,WCDSharkeyFunctionDelegate>

@property(nonatomic,strong)UIScrollView *timeScrollView; //时间滚动视图
@property(nonatomic,strong) NSMutableArray *timeArray; //时间数组
@property(nonatomic,strong)UIView *dataView; //运动 睡眠数据展示视图
@property(nonatomic,strong)OBSportView *sportView; //运动视图
@property(nonatomic,strong)UIButton *lastSelectedButton; //上一次选中的按钮
@property(nonatomic,strong)UIView *centerView; //公里跟卡路里视图
@property(nonatomic,strong) UIImageView *distantImage; //公里图片
@property(nonatomic,strong) UILabel *distantText; //公里数
@property(nonatomic,strong) UILabel *distantLabel; //公里
@property(nonatomic,strong) UIImageView *calorieImage; //卡路里图片
@property(nonatomic,strong) UILabel *calorieText; //卡路里
@property(nonatomic,strong) UILabel *calorieLabel; //卡路里
@property(nonatomic,strong)UIButton *weekSportbutton; //周运动详情

@end

@implementation SYSportViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.timeArray = @[@"12.26",@"12.27",@"12.28",@"12.29",@"12.30",@"12.31",@"01.01",@"01.06",@"今天"];
//    self.stepArray = @[@1300,@7600,@4500,@3000,@2000,@3400,@6000,];
    [self getDate];
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
    SYLoginInfoModel *infoModel = [SYUserDataManager manager].userLoginInfoModel;
    if (infoModel) {
        self.sportView.targetCount = [infoModel.targetStep integerValue]>0?[infoModel.targetStep integerValue]:10000;
    }

    
}
//获取已知数据
//-(void)requestCurrentStepDataFormWrist
//{
//    SYUserInfoModel *infoModel = [SYUserDataManager manager].userInfoModel;
//    //获取目标步数
//    if (infoModel) {
//        self.sportView.targetCount = [infoModel.sportsTarget integerValue];
//    }
//    [[WCDSharkeyFunction shareInitializationt] updatePedometerDataFromRemoteWalkNumberOfDays:0xd7];
//}
//获取这一周的时间
- (void)getDate
{
    NSDate *date = [NSDate date];
//    NSMutableArray *timeArray = [NSMutableArray array];
    NSDate *weekDate = [[date previousWeek]nextDay];
    for (int i = 0; i < 7; i++) {
        if (i == 6) {
            //今天
            [self.timeArray addObject:@"今天"];
        } else {
        NSString *str =  [self monthAndDayStringWithDate:weekDate];
        [self.timeArray addObject:str];
        weekDate = [weekDate nextDay];
        }
    }
   
    
}
- (NSString *)monthAndDayStringWithDate:(NSDate *)date
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-mm-dd"];//自定义时间格式
    NSString *currentDateStr = [date formatYMD];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    NSString *string = [NSString stringWithFormat:@"%@.%@",dateArray[1],dateArray[2]];
    return string;
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
//            [self didClickHeadButtonAction:button];
        }
        button.titleLabel.font = kFont(14.0);
        button.tag = i + 100;
//        button.backgroundColor = [UIColor greenColor];
        [button addTarget:self action:@selector(didClickHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeScrollView addSubview:button];
        
    }
    [self.view addSubview:self.dataView];
    [self.dataView addSubview:self.sportView];
    [self.view addSubview:self.centerView];
    [self.centerView addSubview:self.distantImage];
    [self.centerView addSubview:self.distantText];
    [self.centerView addSubview:self.distantLabel];
    [self.centerView addSubview:self.calorieImage];
    [self.centerView addSubview:self.calorieLabel];
    [self.centerView addSubview:self.calorieText];
    [self.view addSubview:self.weekSportbutton];
    
}
- (void)addAction
{
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.dataView addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.dataView addGestureRecognizer:rightSwipeGesture];
    [self.weekSportbutton addTarget:self action:@selector(weekSportbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewframeSet
{
    self.timeScrollView.frame =CGRectMake(0, 0, kScreenWidth, kHeight(54));
    self.dataView.frame = CGRectMake(0, self.timeScrollView.bottom, kScreenWidth, kHeight(274));
    self.centerView.frame = CGRectMake(0, self.dataView.bottom, kScreenWidth, kHeight(150));
    self.distantImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    self.distantImage.centerX = kScreenWidth/4.0;
    self.distantText.frame = CGRectMake(0, self.distantImage.bottom, kScreenWidth/2.0 , kHeight(56));
    self.distantLabel.frame = CGRectMake(0, self.distantText.bottom, kScreenWidth/2.0 , kHeight(30));
    self.calorieImage.frame = CGRectMake(0, 0, kWidth(34), kHeight(34));
    self.calorieImage.centerX = kScreenWidth/4.0 * 3;
    self.calorieText.frame = CGRectMake(kScreenWidth/2.0, self.calorieImage.bottom, kScreenWidth/2.0 , kHeight(56));
    self.calorieLabel.frame = CGRectMake(kScreenWidth/2.0, self.calorieText.bottom, kScreenWidth/2.0 , kHeight(30));
    self.centerView.height = self.calorieLabel.bottom;
    
    self.weekSportbutton.frame = CGRectMake((kScreenWidth - kWidth(200))/2.0, self.centerView.bottom + kHeight(21), kWidth(180), kHeight(48));
    
    
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
    if (self.stepArray.count > index) {
        self.sportView.stepCount = [self.stepArray[index] integerValue];
        self.distantText.text = [NSString stringWithFormat:@"%.1f",[self.distantArray[index] floatValue]];
        self.calorieText.text = [NSString stringWithFormat:@"%.1f",[self.calorieArray[index] floatValue]];
    }
    if (index * (button.width + kWidth(10)) + kScreenWidth > self.timeScrollView.contentSize.width) {
        CGPoint position =  CGPointMake(self.timeScrollView.contentSize.width - kScreenWidth, 0);
        [self.timeScrollView setContentOffset:position animated:YES];
    } else {
        CGPoint position =  CGPointMake(index * (button.width + kWidth(10)), 0);
        [self.timeScrollView setContentOffset:position animated:YES];

    }
}
- (void)weekSportbuttonAction:(UIButton *)button
{
    SYWeekSportViewController *weekVC = [[SYWeekSportViewController alloc]init];
    [self.navigationController pushViewController:weekVC animated:YES];
}
#pragma mark - WCDSharkeyFunctionDelegate
//计步
//- (void)WCDPedometerDate:(NSDate *)date Count:(NSInteger)count Minute:(NSInteger)minute
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"date------%@,count------%ld,minute-----%ld",date,count,minute);
//        [self.stepArray insertObject:[NSNumber numberWithInteger:count] atIndex:0];
////        self.sportView.stepCount = count;
////        self.sportView.targetCount = 8000;
//        //查询公里数
//        CGFloat distant = [[WCDSharkeyFunction shareInitializationt] getDistanceAll:165 numStep:count];
//        //卡路里
//        CGFloat kCal = [[WCDSharkeyFunction shareInitializationt] getKcal:distant weight:50];
//        NSLog(@"distant------%f,kCal------%f",distant,kCal);
//        [self.distantArray insertObject:[NSNumber numberWithFloat:distant] atIndex:0];
//        [self.calorieArray insertObject:[NSNumber numberWithFloat:kCal] atIndex:0];
//        [self didClickHeadButtonAction:self.lastSelectedButton];
//    });
//    
//    
//}

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
        _timeScrollView.backgroundColor = [UIColor colorWithHexString:@"F7FEFF"];
    }
    return _timeScrollView;
}
- (OBSportView *)sportView
{
    if (_sportView == nil) {
        _sportView = [[OBSportView alloc]initWithFrame:CGRectMake((kScreenWidth - kWidth(250))/2.0, kHeight(20),kWidth(250), kWidth(250))];
//        _sportView.stepCount = 7000;
//        _sportView.targetCount = 12000;
        _sportView.roundView.roundWidth = 12;
        _sportView.roundView.leftEndGradientColor = RGBColor(105, 108, 224);
        _sportView.roundView.leftCenterGradientColor = [UIColor colorWithHexString:@"#8071DB"];
        _sportView.roundView.leftBeginGradientColor = [UIColor colorWithHexString:@"#71D3FA"];
        _sportView.roundView.rightCenterGradientColor = [UIColor colorWithHexString:@"#7EACEA"];
        _sportView.roundView.rightBeginGradientColor =[UIColor colorWithHexString:@"#71D3FA"];
        _sportView.roundView.rightEndGradientColor = RGBColor(105, 108, 224);
        
    }
    return _sportView;
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
- (UIImageView *)distantImage
{
    if (_distantImage == nil) {
        _distantImage = [[UIImageView alloc]init];
        _distantImage.image = [UIImage imageNamed:@"ic_km"];
    }
    return _distantImage;
}
- (UILabel *)distantLabel
{
    if (_distantLabel == nil) {
        _distantLabel = [[UILabel alloc]init];
        _distantLabel.text = @"公里";
        _distantLabel.textColor = [UIColor lightGrayColor];
        _distantLabel.font = kFont(14.0);
        _distantLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _distantLabel;
}
- (UILabel *)distantText
{
    if (_distantText == nil) {
        _distantText = [[UILabel alloc]init];
        _distantText.text = @"0";
        _distantText.textColor = RGBColor(74, 172, 247);
        _distantText.font = kFont(35.0);
        _distantText.textAlignment = NSTextAlignmentCenter;
    }
    return _distantText;
}
- (UIImageView *)calorieImage
{
    if (_calorieImage == nil) {
        _calorieImage = [[UIImageView alloc]init];
        _calorieImage.image = [UIImage imageNamed:@"ic_kal"];
    }
    return _calorieImage;
}
- (UILabel *)calorieText
{
    if (_calorieText == nil) {
        _calorieText = [[UILabel alloc]init];
        _calorieText.text = @"0";
        _calorieText.textColor = RGBColor(74, 172, 247);
        _calorieText.font = kFont(35.0);
        _calorieText.textAlignment = NSTextAlignmentCenter;
    }
    return _calorieText;
}
- (UILabel *)calorieLabel
{
    if (_calorieLabel == nil) {
        _calorieLabel = [[UILabel alloc]init];
        _calorieLabel.text = @"大卡";
        _calorieLabel.textColor = [UIColor lightGrayColor];
        _calorieLabel.font = kFont(14.0);
        _calorieLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _calorieLabel;
}
- (UIButton *)weekSportbutton
{
    if (_weekSportbutton == nil) {
        _weekSportbutton = [[UIButton alloc]init];
        [_weekSportbutton setTitle:@"查看周运动详情" forState:UIControlStateNormal];
        [_weekSportbutton setTitleColor:[UIColor colorWithHexString:@"#17C6F8"] forState:UIControlStateNormal];
        _weekSportbutton.titleLabel.font = kFont(18.0);
        _weekSportbutton.layer.masksToBounds = YES;
        _weekSportbutton.layer.cornerRadius = 24;
        _weekSportbutton.layer.borderColor = [UIColor colorWithHexString:@"#17C6F8"].CGColor;
        _weekSportbutton.layer.borderWidth = 2;
    }
    return _weekSportbutton;
}
- (void)setStepArray:(NSMutableArray *)stepArray
{
    _stepArray = stepArray;
    [self didClickHeadButtonAction:self.lastSelectedButton];
}
- (void)setDistantArray:(NSMutableArray *)distantArray
{
    _distantArray = distantArray;
    [self didClickHeadButtonAction:self.lastSelectedButton];
}
- (void)setCalorieArray:(NSMutableArray *)calorieArray
{
    _calorieArray = calorieArray;
    [self didClickHeadButtonAction:self.lastSelectedButton];
}
@end
