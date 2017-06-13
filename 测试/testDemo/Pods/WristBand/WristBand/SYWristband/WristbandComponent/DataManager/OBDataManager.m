//
//  OBDataManager.m
//  WristStrapDemo
//
//  Created by obally on 17/4/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "OBDataManager.h"

@implementation OBDataManager
+(instancetype)shareManager
{
    static OBDataManager *mar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mar = [[OBDataManager alloc]init];
    });
    return mar;
}
- (void)setStrapModel:(WristStrapModel *)strapModel
{
    _strapModel = strapModel;
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"strapModel.data"];
    [NSKeyedArchiver archiveRootObject:_strapModel toFile:file];
}
- (WristStrapModel *)lastStrapModel
{
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"strapModel.data"];
    WristStrapModel *lastStrapModel = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    return lastStrapModel;
}
- (void)removeLastModel
{
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"strapModel.data"];
    [[NSFileManager defaultManager]removeItemAtPath:file error:nil];
}
//- (void)setLastSharKey:(Sharkey *)lastSharKey
//{
////    _lastSharKey = lastSharKey;
//    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sharKey.data"];
//    [NSKeyedArchiver archiveRootObject:lastSharKey toFile:file];
//    
//}
//- (Sharkey *)lastSharKey
//{
//    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"sharKey.data"];
//    Sharkey *lastSharKey= [NSKeyedUnarchiver unarchiveObjectWithFile:file];
//    return lastSharKey;
//}
@end
