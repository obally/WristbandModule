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
        SYDeviveManagerViewController *health = [[SYDeviveManagerViewController alloc]init];
        SYLoginInfoModel *loginModel = [[SYLoginInfoModel alloc]init];
        loginModel.token = routerParameters[MGJRouterParameterUserInfo][SYUserToken];
        loginModel.schoolNum = routerParameters[MGJRouterParameterUserInfo][SYUserSchoolNum];
        loginModel.baseUrl = routerParameters[MGJRouterParameterUserInfo][SYBaseUrl];
        loginModel.mobile = @"18701459982";
        [SYUserDataManager manager].userLoginInfoModel = loginModel;
        UIViewController *nav = routerParameters[MGJRouterParameterUserInfo][SYController];
        if ([nav isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)nav pushViewController:health animated:YES];
        } else {
            [(UINavigationController *)nav presentViewController:health animated:YES completion:nil];
        }
        
        
    }];
}
@end
