//
//  AlarmColckModel+CoreDataProperties.m
//  SYWristband
//
//  Created by obally on 17/6/1.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "AlarmColckModel+CoreDataProperties.h"

@implementation AlarmColckModel (CoreDataProperties)

+ (NSFetchRequest<AlarmColckModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AlarmColckModel"];
}

@dynamic cycleDate;
@dynamic dateString;
@dynamic deviceId;
@dynamic userMobile;
@dynamic isOn;
@dynamic date;

@end
