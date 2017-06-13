//
//  ViewController.m
//  testDemo
//
//  Created by obally on 2017/6/13.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "ViewController.h"
#import <OBBase/OBBase.h>
#import <WristBand/SYHealthMoulde.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
    [MGJRouter openURL:HealthMouldeRouter withUserInfo:@{@"navigationVC" : self.navigationController,@"token":@"huang"} completion:^(id result) {
        
    }];
}

@end
