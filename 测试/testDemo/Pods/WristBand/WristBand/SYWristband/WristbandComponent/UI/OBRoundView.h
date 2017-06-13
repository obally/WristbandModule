//
//  OBRoundView.h
//  GradientLayerDemo
//
//  Created by obally on 17/4/12.
//  Copyright © 2017年 obally. All rights reserved.
//  环状图

#import <UIKit/UIKit.h>

@interface OBRoundView : UIView
@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,strong) UIColor *bottomLayerColor; //圆环底部颜色
@property(nonatomic,strong) UIColor *rightBeginGradientColor; //圆环上面右边开始渐变色
@property(nonatomic,strong) UIColor *rightCenterGradientColor; //圆环上面右边中间渐变色
@property(nonatomic,strong) UIColor *rightEndGradientColor; //圆环上面右边结束渐变色
@property(nonatomic,strong) UIColor *leftBeginGradientColor; //圆环上面左边开始渐变色
@property(nonatomic,strong) UIColor *leftCenterGradientColor; //圆环上面左边中间渐变色
@property(nonatomic,strong) UIColor *leftEndGradientColor; //圆环上面左边结束渐变色
@property(nonatomic,assign) CGFloat roundWidth; //圆环宽度

@end
