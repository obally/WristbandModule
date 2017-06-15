//
//  SportDataModel+CoreDataProperties.m
//  SYWristband
//
//  Created by obally on 17/6/2.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SportDataModel+CoreDataProperties.h"

@implementation SportDataModel (CoreDataProperties)

+ (NSFetchRequest<SportDataModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SportDataModel"];
}

@dynamic calorie;
@dynamic date;
@dynamic deviceId;
@dynamic distant;
@dynamic totalStep;
@dynamic userMobile;
@dynamic totalDate;

@end
