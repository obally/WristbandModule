//
//  OBSportView.m
//  GradientLayerDemo
//
//  Created by obally on 17/4/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "OBSportView.h"


@interface OBSportView ()

@property(nonatomic,strong) UILabel *stepNum;
@property(nonatomic,strong) UILabel *targetNum;

@end
@implementation OBSportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    OBRoundView *roundView = [[OBRoundView alloc]initWithFrame:self.bounds];
    self.roundView = roundView;
    [self addSubview:roundView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight(50), self.width - kWidth(30), kHeight(30))];
    label.text = @"今日步数";
    label.textColor = [UIColor lightGrayColor];
    label.font = kFont(18.0);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    UILabel *stepNum = [[UILabel alloc]initWithFrame:CGRectMake(0, label.bottom, self.width - kWidth(20) , kHeight(80))];
    stepNum.text = @"0";
    stepNum.textColor = RGBColor(74, 172, 247);
    stepNum.font = kFont(55);
    stepNum.textAlignment = NSTextAlignmentCenter;
    self.stepNum = stepNum;
    [self addSubview:stepNum];
    
    UILabel *targetNum = [[UILabel alloc]initWithFrame:CGRectMake(0, stepNum.bottom + kHeight(10), self.width - 30 , 20)];
    targetNum.text = @"目标 8000";
    targetNum.textColor = [UIColor lightGrayColor];
    targetNum.font = kFont(16.0);
    targetNum.textAlignment = NSTextAlignmentCenter;
    self.targetNum = targetNum;
    [self addSubview:targetNum];
    
    targetNum.centerX = stepNum.centerX = label.centerX = roundView.centerX;
    stepNum.centerY = roundView.centerY;
    targetNum.top = stepNum.bottom;
    
}
#pragma mark - setter && getter
- (void)setStepCount:(CGFloat)stepCount
{
    _stepCount = stepCount;
    self.stepNum.text =  [NSString stringWithFormat:@"%.f",_stepCount];
    self.roundView.progress = _stepCount/_targetCount;
}
- (void)setTargetCount:(NSInteger)targetCount
{
    _targetCount = targetCount;
    self.targetNum.text = [NSString stringWithFormat:@"目标 %ld",_targetCount];
    self.roundView.progress = (CGFloat)self.stepCount/_targetCount;
}

@end
