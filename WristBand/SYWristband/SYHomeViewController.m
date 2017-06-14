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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.navigationController forKey:SYController];
    [dic setObject:@"f4546f9cf77c44219da2ee2e04c5fc11" forKey:SYUserToken];
    [dic setObject:@"123" forKey:SYUserSchoolNum];
    [MGJRouter openURL:DeviceManagerMoulde withUserInfo:dic completion:^(id result) {
        
    }];
}

@end
