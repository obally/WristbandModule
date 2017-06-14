//
//  SYDeviceManagerMoulde.m
//  SYWristband
//
//  Created by obally on 2017/6/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYDeviceManagerMoulde.h"
#import "SYDeviveManagerViewController.h"
@implementation SYDeviceManagerMoulde
+ (void)load
{
    [MGJRouter registerURLPattern:DeviceManagerMoulde toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *nav = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        SYDeviveManagerViewController *health = [[SYDeviveManagerViewController alloc]init];
        [nav pushViewController:health animated:YES];
        
    }];
}
@end
