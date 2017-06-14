//
//  UpLoadSleepDate+CoreDataProperties.m
//  SYWristband
//
//  Created by obally on 17/5/27.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "UpLoadSleepDate+CoreDataProperties.h"

@implementation UpLoadSleepDate (CoreDataProperties)

+ (NSFetchRequest<UpLoadSleepDate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UpLoadSleepDate"];
}

@dynamic date;
@dynamic deviceId;
@dynamic userMobile;

@end
