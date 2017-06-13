//
//  SYBaseNavigationController.m
//  UCard
//
//  Created by huchu on 2017/3/15.
//  Copyright © 2017年 Synjones. All rights reserved.
//

#import "SYBaseNavigationController.h"

@interface SYBaseNavigationController ()

@end

@implementation SYBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:RGBColor(61, 199, 252)];
    self.navigationBar.translucent = NO;
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.navigationBar.titleTextAttributes];
    [textAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = textAttributes;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)dealloc {
    NSLog(@"dealloc %@", NSStringFromClass([self class]));
}

@end
