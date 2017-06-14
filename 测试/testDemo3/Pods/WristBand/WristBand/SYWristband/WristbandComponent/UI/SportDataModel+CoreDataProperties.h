//
//  SportDataModel+CoreDataProperties.h
//  SYWristband
//
//  Created by obally on 17/6/2.
//  Copyright © 2017年 obally. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SportDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SportDataModel (CoreDataProperties)

+ (NSFetchRequest<SportDataModel *> *)fetchRequest;

@property (nonatomic) float calorie;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nonatomic) float distant;
@property (nonatomic) int32_t totalStep;
@property (nullable, nonatomic, copy) NSString *userMobile;
@property (nullable, nonatomic, copy) NSDate *totalDate;

@end

NS_ASSUME_NONNULL_END
