//
//  OBSportView.h
//  GradientLayerDemo
//
//  Created by obally on 17/4/12.
//  Copyright © 2017年 obally. All rights reserved.
// 运动环状图

#import <UIKit/UIKit.h>
#import "OBRoundView.h"
@interface OBSportView : UIView
@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,strong) OBRoundView *roundView;
@property(nonatomic,assign) CGFloat stepCount; //步数
@property(nonatomic,assign) NSInteger targetCount; //目标数

@end
