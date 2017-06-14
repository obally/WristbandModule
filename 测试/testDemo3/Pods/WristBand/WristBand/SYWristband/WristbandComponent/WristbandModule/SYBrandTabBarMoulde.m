//
//  SYBrandMoulde.m
//  SYWristband
//
//  Created by obally on 2017/6/12.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYBrandTabBarMoulde.h"
#import "SYTabBarViewController.h"
@implementation SYBrandTabBarMoulde
+ (void)load
{
    [MGJRouter registerURLPattern:BrandTabBarMouleRouter toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *nav = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
        SYTabBarViewController *login = [[SYTabBarViewController alloc]init];
        [nav pushViewController:login animated:YES];
        
    }];
}

@end
