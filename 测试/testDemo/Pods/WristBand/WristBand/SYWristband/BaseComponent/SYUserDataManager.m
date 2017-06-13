//
//  SYUserDataManager.m
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYUserDataManager.h"
#define SYAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/userLoginInfoModel.data"]
@implementation SYUserDataManager
+ (instancetype)manager
{
    static SYUserDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SYUserDataManager alloc]init];
    });
    return manager;
}
- (void)setUserLoginInfoModel:(SYLoginInfoModel *)userLoginInfoModel
{
    [NSKeyedArchiver archiveRootObject:userLoginInfoModel toFile:SYAccountPath];
}
- (SYLoginInfoModel *)userLoginInfoModel
{
    SYLoginInfoModel *infoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:SYAccountPath];
    return infoModel;
}
- (void)removeUserLoginData
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:SYAccountPath]) {
        [defaultManager removeItemAtPath:SYAccountPath error:nil];
    }
//    [[NSFileManager defaultManager]removeItemAtPath:file error:nil];
}
//- (void)setUserInfoModel:(SYUserInfoModel *)userInfoModel
//{
//    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/userInfoModel.data"];
//    [NSKeyedArchiver archiveRootObject:userInfoModel toFile:file];
//}
//- (SYUserInfoModel *)userInfoModel
//{
//    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingString:@"/userInfoModel.data"];
//    SYUserInfoModel *infoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//    return infoModel;
//}
@end
