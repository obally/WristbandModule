//
//  SYHomeModule.m
//  WristStrapDemo
//
//  Created by obally on 17/4/19.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYHomeModule.h"
#import "SYHealthViewController.h"

@implementation SYHomeModule
+ (void)load
{
    [MGJRouter registerURLPattern:@"WS://HomePage/PushMainVC" toHandler:^(NSDictionary *routerParameters) {
//        UINavigationController *navigationVC = routerParameters[MGJRouterParameterUserInfo][@"navigationVC"];
//        SYWristStapHomeViewController *homePageVC = [[SYWristStapHomeViewController alloc] init];
//        void (^completion)(id result) = routerParameters[MGJRouterParameterCompletion];
//        homePageVC.completion = completion;
//        [navigationVC pushViewController:homePageVC animated:YES];
        
    }];
    
}
@end
