//
//  SYHealthMoulde.m
//  SYWristband
//
//  Created by obally on 2017/6/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYHealthMoulde.h"
#import "SYHealthViewController.h"
@implementation SYHealthMoulde
+ (void)load
{
    [MGJRouter registerURLPattern:HealthMouldeRouter toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *nav = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        SYHealthViewController *health = [[SYHealthViewController alloc]init];
        health.token = routerParameters[MGJRouterParameterUserInfo][@"token"];
        [nav pushViewController:health animated:YES];
        
    }];
}
@end
