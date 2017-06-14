//
//  OBDataManager.h
//  WristStrapDemo
//
//  Created by obally on 17/4/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WristStrapModel.h"
@interface OBDataManager : NSObject
@property(nonatomic,strong) WristStrapModel *strapModel;
+(instancetype)shareManager;
- (WristStrapModel *)lastStrapModel; //最后一次连接的手环设备信息模型
- (void)removeLastModel;
//@property(nonatomic,strong) Sharkey *lastSharKey; //最后一次连接的手环设备

//- (Sharkey *)lastSharKey;//最后一次连接的手环设备
@end
