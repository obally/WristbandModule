//
//  SYSleepViewController.h
//  SYWristband
//
//  Created by obally on 17/5/18.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYBaseViewController.h"

@interface SYSleepViewController : SYBaseViewController
//-(void)requestCurrentSleepDataFormWrist; //从手环请求睡眠数据
@property(nonatomic,strong) NSMutableArray *sleepData; //睡眠数据  array[0] 表示总睡眠 array[1] 表示深睡眠 array[2] 表示浅睡眠

@end
