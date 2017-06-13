//
//  SYBaseViewController.m
//  SYWristband
//
//  Created by obally on 17/5/11.
//  Copyright © 2017年 obally. All rights reserved.
//

#import "SYBaseViewController.h"

@interface SYBaseViewController ()

@end

@implementation SYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGBColor(239, 240, 241);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (self.navigationController.viewControllers.count > 1) {
        [self createCustomNav];
    }
}
- (void)createCustomNav
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#17C6F8"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    UIImage *leftButtonIcon = [UIImage imageNamed:@"back"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:leftButtonIcon
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goToBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}
- (void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"***************dealloc ***************\n");
}


@end
