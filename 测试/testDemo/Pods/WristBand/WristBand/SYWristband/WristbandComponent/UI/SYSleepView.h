//
//  SYSleepView.h
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
// 睡眠环状图

#import <UIKit/UIKit.h>
#import "OBRoundView.h"
@interface SYSleepView : UIView
@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,strong) OBRoundView *roundView;
@property(nonatomic,assign) CGFloat sleepCount; //睡眠时长
@property(nonatomic,assign) NSInteger targetSleepCount; //睡眠目标

@end
