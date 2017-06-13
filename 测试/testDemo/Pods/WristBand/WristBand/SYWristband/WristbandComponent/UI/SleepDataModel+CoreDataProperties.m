//
//  SleepDataModel+CoreDataProperties.m
//  SYWristband
//
//  Created by obally on 17/6/2.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SleepDataModel+CoreDataProperties.h"

@implementation SleepDataModel (CoreDataProperties)

+ (NSFetchRequest<SleepDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SleepDataModel"];
}

@dynamic date;
@dynamic deepSleep;
@dynamic deviceId;
@dynamic lightSleep;
@dynamic totalSleep;
@dynamic userMobile;
@dynamic totalDate;

@end
