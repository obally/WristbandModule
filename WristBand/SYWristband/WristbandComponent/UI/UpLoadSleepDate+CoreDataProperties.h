//
//  UpLoadSleepDate+CoreDataProperties.h
//  SYWristband
//
//  Created by obally on 17/5/27.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UpLoadSleepDate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UpLoadSleepDate (CoreDataProperties)

+ (NSFetchRequest<UpLoadSleepDate *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nullable, nonatomic, copy) NSString *userMobile;

@end

NS_ASSUME_NONNULL_END
