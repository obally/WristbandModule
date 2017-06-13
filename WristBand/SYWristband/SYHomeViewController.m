//
//  SYHomeViewController.m
//  SYWristband
//
//  Created by obally on 2017/6/13.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYHomeViewController.h"
#import "SYHealthMoulde.h"
#import "SYBrandTabBarMoulde.h"
@interface SYHomeViewController ()

@end

@implementation SYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [MGJRouter openURL:HealthMouldeRouter withUserInfo:@{@"navigationVC" : self.navigationController,@"token":@"huang"} completion:^(id result) {
//        
//    }];
    [MGJRouter openURL:BrandTabBarMouleRouter withUserInfo:@{@"navigationVC" : self.navigationController,@"token":@"huang"} completion:^(id result) {
        
    }];
}

@end
