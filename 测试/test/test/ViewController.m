//
//  ViewController.m
//  test
//
//  Created by obally on 2017/6/14.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "ViewController.h"
#import <MGJRouter/MGJRouter.h>
#import "SYCommon.h"
#import "SYDeviveManagerViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.navigationController forKey:SYController];
    [dic setObject:@"6836598118444c1da36fe80abda09634" forKey:SYUserToken];
    [dic setObject:@"123" forKey:SYUserSchoolNum];
    [MGJRouter openURL:BrandTabBarMouleRouter withUserInfo:dic completion:^(id result) {
        
    }];
    

}
@end
