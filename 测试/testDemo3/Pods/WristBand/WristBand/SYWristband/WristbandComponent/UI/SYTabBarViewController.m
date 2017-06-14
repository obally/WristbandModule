//
//  SYTabBarViewController.m
//  SYWristband
//
//  Created by obally on 17/5/15.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYTabBarViewController.h"
//#import "SYCardViewController.h"
#import "SYHealthViewController.h"
#import "SYDeviveManagerViewController.h"
//#import "SYMineCenterViewController.h"
#import "SYSearchDeviceViewController.h"
@interface SYTabBarViewController ()

@end

@implementation SYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    SYCardViewController *cardVC = [[SYCardViewController alloc]init];
//    SYBaseNavigationController *cardNav = [[SYBaseNavigationController alloc]initWithRootViewController:cardVC];
    SYHealthViewController *healthVC = [[SYHealthViewController alloc]init];
    SYBaseNavigationController *healthNav = [[SYBaseNavigationController alloc]initWithRootViewController:healthVC];
    
    SYDeviveManagerViewController *settingVC = [[SYDeviveManagerViewController alloc]init];
    SYBaseNavigationController *settingNav = [[SYBaseNavigationController alloc]initWithRootViewController:settingVC];
    
//    SYMineCenterViewController *mineVC = [[SYMineCenterViewController alloc]init];
//    SYBaseNavigationController *mineNav = [[SYBaseNavigationController alloc]initWithRootViewController:mineVC];
//    self.viewControllers = @[cardNav,healthNav,settingNav,mineNav];
    self.viewControllers = @[healthNav,settingNav];
    [self createTabBarItems];
}
-(void)createTabBarItems
{
    self.view.backgroundColor = [UIColor whiteColor];
    //    NSArray * itemTitleArray = @[@"热图",@"发现",@" ",@"沃摄",@"我的"];
    NSArray * itemPicArray = @[
                               @"tabbar_ic_hea",
                               @"tabbar_ic_shouhuan",
                               
                               ];
    NSArray * selectPicArray = @[
                                 @"tabbar_ic_hea_pre",
                                 @"tabbar_ic_shouhuan_pre",
                                 
                                 ];
    NSArray *titleArray = @[@"健康",@"设备管理"];
    
    for (int i = 0; i<self.tabBar.items.count; i++) {
        UITabBarItem * item = [[UITabBarItem alloc] init];
        item = self.tabBar.items[i];
        
        if ([[UIDevice currentDevice]systemVersion].floatValue>=7.0) {
            //xcode6中的一些api方法被废弃了同时tabbar上图片的渲染方式发生了改变,必须设置渲染方式
            UIImage *itemPic = [[UIImage imageNamed:itemPicArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UIImage *selectPic = [[UIImage imageNamed:selectPicArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item = [item initWithTitle:titleArray[i] image:itemPic selectedImage:selectPic];
            item.tag = i;
        }
        else
        {
            item.tag = i;
        }
    }
    
    //修改Title选中的颜色--状态是选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#57BCF9"]} forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CECECE"]} forState:UIControlStateNormal];
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom_beijing_ios"]];
    self.selectedIndex = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)
    {
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
