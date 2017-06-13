//
//  SYAddAlarmClockViewController.h
//  SYWristband
//
//  Created by obally on 17/5/31.
//  Copyright © 2017年 obally. All rights reserved.
//  添加闹钟

#import "SYBaseViewController.h"
#import "AlarmColckModel+CoreDataClass.h"
typedef void (^ClockBlock)(NSDate *selectedDate,NSArray *selectedTimeArray,BOOL isOpen);
@interface SYAddAlarmClockViewController : SYBaseViewController
@property(nonatomic,copy) ClockBlock block;
@property(nonatomic,assign) BOOL isEdit; //是否是编辑
@property(nonatomic,strong) AlarmColckModel *clockModel;

@end
