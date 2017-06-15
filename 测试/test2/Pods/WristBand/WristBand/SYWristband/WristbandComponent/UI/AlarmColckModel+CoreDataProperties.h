//
//  AlarmColckModel+CoreDataProperties.h
//  SYWristband
//
//  Created by obally on 17/6/1.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "AlarmColckModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlarmColckModel (CoreDataProperties)

+ (NSFetchRequest<AlarmColckModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cycleDate;
@property (nullable, nonatomic, copy) NSString *dateString;
@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nullable, nonatomic, copy) NSString *userMobile;
@property (nonatomic) BOOL isOn;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
