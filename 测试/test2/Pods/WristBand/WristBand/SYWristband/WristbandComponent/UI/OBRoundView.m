//
//  OBRoundView.m
//  GradientLayerDemo
//
//  Created by obally on 17/4/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "OBRoundView.h"

#define  CENTER   CGPointMake(self.width *.5, self.height *.5)
@interface OBRoundView ()
/** 外圈  */
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property(nonatomic,strong) CAShapeLayer *bottomLayer;
@property(nonatomic,strong) CAShapeLayer *topLayer;
@property(nonatomic,strong) CAGradientLayer *leftGradient;
@property(nonatomic,strong) CAGradientLayer *rightGradient;
@end
@implementation OBRoundView
- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        CAShapeLayer *bottomLayer = [CAShapeLayer layer];
        bottomLayer.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:self.width/2.0 - 10 startAngle:(M_PI_2) * 3.0 endAngle:(M_PI_2) * 3.0 + M_PI * 2 clockwise:1].CGPath;
        bottomLayer.fillColor = [UIColor clearColor].CGColor;
        bottomLayer.strokeColor = [UIColor purpleColor].CGColor;
        bottomLayer.lineWidth = 15;
        bottomLayer.strokeStart = 0;
        bottomLayer.strokeEnd = 0;
        self.topLayer = bottomLayer;
//        [bottomLayer setLineDashPattern:[NSArray arrayWithObjects:@5,@1, nil]];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        
        //左边渐变
        CAGradientLayer *lay1 = [CAGradientLayer layer];
        self.leftGradient = lay1;
        lay1.frame = CGRectMake(0, 0, self.width/2.0, self.height);
        UIColor *leftBeginColor = self.leftBeginGradientColor?self.leftBeginGradientColor:[UIColor colorWithRed:107/255.0 green:205/255.0 blue:255/255.0 alpha:1];
        UIColor *leftEndColor = self.leftEndGradientColor?self.leftEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
        lay1.colors = [NSArray arrayWithObjects:(__bridge id)leftBeginColor.CGColor,(__bridge id)leftEndColor.CGColor, nil];
        
        lay1.startPoint = CGPointMake(0.5, 0);
        lay1.endPoint = CGPointMake(0.5, 1);
        [_gradientLayer addSublayer:lay1];
        
        //右边渐变
        CAGradientLayer *lay2 = [CAGradientLayer layer];
        self.rightGradient = lay2;
        lay2.frame = CGRectMake(self.width/2.0, 0, self.width/2.0, self.height);
        UIColor *rightBeginColor = self.rightBeginGradientColor?self.rightBeginGradientColor:[UIColor orangeColor];
        UIColor *rightEndColor = self.rightEndGradientColor?self.rightEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
        lay2.colors = [NSArray arrayWithObjects:(__bridge id)rightBeginColor.CGColor,(__bridge id)rightEndColor.CGColor, nil];
        lay2.startPoint = CGPointMake(0.5, 0);
        lay2.endPoint = CGPointMake(0.5, 1);
        [_gradientLayer addSublayer:lay2];
        
        _gradientLayer.mask = bottomLayer;
        
    }
    return _gradientLayer;
}
- (CAShapeLayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.path = [UIBezierPath bezierPathWithArcCenter:CENTER radius:self.width/2.0 - 10 startAngle:0 endAngle:M_PI * 2 clockwise:1].CGPath;
        _bottomLayer.fillColor = [UIColor clearColor].CGColor;
        _bottomLayer.strokeColor = [UIColor colorWithRed:223/255.0 green:246/255.0 blue:252/255.0 alpha:0.8].CGColor;
        if (self.bottomLayerColor) {
            _bottomLayer.strokeColor = self.bottomLayerColor.CGColor;
        }
        
        _bottomLayer.lineWidth = 15;
//        [_bottomLayer setLineDashPattern:[NSArray arrayWithObjects:@5,@1, nil]];
        
    }
    return _bottomLayer;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.topLayer.strokeEnd = progress;
}
- (void)setRoundWidth:(CGFloat)roundWidth
{
    _roundWidth = roundWidth;
    self.topLayer.lineWidth = _roundWidth;
    self.bottomLayer.lineWidth = _roundWidth;
}
- (void)setLeftBeginGradientColor:(UIColor *)leftBeginGradientColor
{
    _leftBeginGradientColor = leftBeginGradientColor;
    UIColor *leftBeginColor = self.leftBeginGradientColor?self.leftBeginGradientColor:[UIColor colorWithRed:107/255.0 green:205/255.0 blue:255/255.0 alpha:1];
    UIColor *leftCenterColor = self.leftCenterGradientColor?self.leftCenterGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    UIColor *leftEndColor = self.leftEndGradientColor?self.leftEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    self.leftGradient.colors = [NSArray arrayWithObjects:(__bridge id)leftBeginColor.CGColor,(__bridge id)leftCenterColor.CGColor,(__bridge id)leftEndColor.CGColor, nil];
}
- (void)setLeftEndGradientColor:(UIColor *)leftEndGradientColor
{
    _leftEndGradientColor = leftEndGradientColor;
    UIColor *leftBeginColor = self.leftBeginGradientColor?self.leftBeginGradientColor:[UIColor colorWithRed:107/255.0 green:205/255.0 blue:255/255.0 alpha:1];
    UIColor *leftCenterColor = self.leftCenterGradientColor?self.leftCenterGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    UIColor *leftEndColor = self.leftEndGradientColor?self.leftEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    self.leftGradient.colors = [NSArray arrayWithObjects:(__bridge id)leftBeginColor.CGColor,(__bridge id)leftCenterColor.CGColor,(__bridge id)leftEndColor.CGColor, nil];
}
- (void)setLeftCenterGradientColor:(UIColor *)leftCenterGradientColor
{
    _leftCenterGradientColor = leftCenterGradientColor;
    UIColor *leftBeginColor = self.leftBeginGradientColor?self.leftBeginGradientColor:[UIColor colorWithRed:107/255.0 green:205/255.0 blue:255/255.0 alpha:1];
     UIColor *leftCenterColor = self.leftCenterGradientColor?self.leftCenterGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    UIColor *leftEndColor = self.leftEndGradientColor?self.leftEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    self.leftGradient.colors = [NSArray arrayWithObjects:(__bridge id)leftBeginColor.CGColor,(__bridge id)leftCenterColor.CGColor,(__bridge id)leftEndColor.CGColor, nil];
}

- (void)setRightEndGradientColor:(UIColor *)rightEndGradientColor
{
    _rightEndGradientColor = rightEndGradientColor;
    UIColor *rightBeginColor = self.rightBeginGradientColor?self.rightBeginGradientColor:[UIColor orangeColor];
    UIColor *rightEndColor = self.rightEndGradientColor?self.rightEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    UIColor *rightCenterColor = self.rightCenterGradientColor?self.rightCenterGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    self.rightGradient.colors = [NSArray arrayWithObjects:(__bridge id)rightBeginColor.CGColor,(__bridge id)rightCenterColor.CGColor,(__bridge id)rightEndColor.CGColor, nil];
}
- (void)setRightCenterGradientColor:(UIColor *)rightCenterGradientColor
{
    _rightCenterGradientColor = rightCenterGradientColor;
    UIColor *rightBeginColor = self.rightBeginGradientColor?self.rightBeginGradientColor:[UIColor orangeColor];
    UIColor *rightEndColor = self.rightEndGradientColor?self.rightEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    UIColor *rightCenterColor = self.rightCenterGradientColor?self.rightCenterGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    self.rightGradient.colors = [NSArray arrayWithObjects:(__bridge id)rightBeginColor.CGColor,(__bridge id)rightCenterColor.CGColor,(__bridge id)rightEndColor.CGColor, nil];
}
- (void)setRightBeginGradientColor:(UIColor *)rightBeginGradientColor
{
    _rightBeginGradientColor = rightBeginGradientColor;
    UIColor *rightBeginColor = self.rightBeginGradientColor?self.rightBeginGradientColor:[UIColor orangeColor];
    UIColor *rightEndColor = self.rightEndGradientColor?self.rightEndGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    UIColor *rightCenterColor = self.rightCenterGradientColor?self.rightCenterGradientColor:[UIColor colorWithRed:197/255.0 green:201/255.0 blue:131/255.0 alpha:1];
    self.rightGradient.colors = [NSArray arrayWithObjects:(__bridge id)rightBeginColor.CGColor,(__bridge id)rightCenterColor.CGColor,(__bridge id)rightEndColor.CGColor, nil];
}

@end
