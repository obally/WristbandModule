//
//  SYSleepView.m
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYSleepView.h"

@interface SYSleepView ()

@property(nonatomic,strong) UILabel *sleepNum;
@property(nonatomic,strong) UILabel *targetNum;

@end
@implementation SYSleepView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        self.targetSleepCount = 12;
    }
    return self;
}
- (void)initView
{
    OBRoundView *roundView = [[OBRoundView alloc]initWithFrame:self.bounds];
    self.roundView = roundView;
    [self addSubview:roundView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight(50), self.width - kWidth(30), kHeight(30))];
    label.text = @"今日睡眠";
    label.textColor = [UIColor lightGrayColor];
    label.font = kFont(18.0);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    UILabel *sleepNum = [[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom, self.width - kWidth(20) , kHeight(80))];
    sleepNum.text = @"0";
    sleepNum.textColor = RGBColor(74, 172, 247);
    sleepNum.font = kFont(55);
    sleepNum.textAlignment = NSTextAlignmentCenter;
    self.sleepNum = sleepNum;
    [self addSubview:sleepNum];
    
    UILabel *targetNum = [[UILabel alloc]initWithFrame:CGRectMake(0, sleepNum.bottom + kHeight(10), self.width - 30 , 20)];
    targetNum.text = @"目标: 1000步";
    targetNum.textColor = [UIColor lightGrayColor];
    targetNum.font = kFont(16.0);
    targetNum.textAlignment = NSTextAlignmentCenter;
    self.targetNum = targetNum;
//    [self addSubview:targetNum];
    
    targetNum.centerX = sleepNum.centerX = label.centerX = roundView.centerX;
    sleepNum.centerY = roundView.centerY;
    targetNum.top = sleepNum.bottom;
    
}
#pragma mark - setter && getter
- (void)setSleepCount:(CGFloat)sleepCount
{
    _sleepCount = sleepCount;
    self.sleepNum.text =  [NSString stringWithFormat:@"%.1f",_sleepCount];
    self.roundView.progress = (CGFloat)self.sleepCount/self.targetSleepCount;
}
- (void)setTargetSleepCount:(NSInteger)targetSleepCount
{
    _targetSleepCount = targetSleepCount;
    self.targetNum.text = [NSString stringWithFormat:@"目标 %ld",_targetSleepCount];
   self.roundView.progress = (CGFloat)self.sleepCount/_targetSleepCount;
}

@end
