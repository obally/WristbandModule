//
//  SleepDataModel+CoreDataProperties.h
//  SYWristband
//
//  Created by obally on 17/6/2.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SleepDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SleepDataModel (CoreDataProperties)

+ (NSFetchRequest<SleepDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nonatomic) float deepSleep;
@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nonatomic) float lightSleep;
@property (nonatomic) float totalSleep;
@property (nullable, nonatomic, copy) NSString *userMobile;
@property (nullable, nonatomic, copy) NSDate *totalDate;

@end

NS_ASSUME_NONNULL_END
