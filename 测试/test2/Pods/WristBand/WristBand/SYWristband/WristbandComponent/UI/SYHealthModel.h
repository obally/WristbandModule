//
//  SYHealthModel.h
//  SYWristband
//
//  Created by obally on 17/5/27.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHealthModel : NSObject
@property(nonatomic,strong) NSString *totalSportSteps;
@property(nonatomic,strong) NSString *sportDistance;
@property(nonatomic,strong) NSString *energyConsume;
@property(nonatomic,strong) NSString *sportTarget;
@property(nonatomic,strong) NSString *totalSleepTime;
@property(nonatomic,strong) NSString *deepSleetTime;
@property(nonatomic,strong) NSString *lightSleepTime;
@property(nonatomic,strong) NSString *date;
@end
