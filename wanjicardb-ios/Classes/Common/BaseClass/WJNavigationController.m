//
//  WJNavigationController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJNavigationController.h"

@interface WJNavigationController ()

@end

@implementation WJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = WJColorNavigationBar;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                               NSForegroundColorAttributeName:WJColorDardGray3};

}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)replaceCurrentControllerWithController:(UIViewController *)vc{
    [self popViewControllerAnimated:NO];
    [self pushViewController:vc animated:YES];
}

- (void)navigationBarIsWhite:(BOOL)boolean
{
    if (boolean) {
        self.navigationBar.barTintColor = WJColorNavigationBar;
        //    self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                                   NSForegroundColorAttributeName:WJColorWhite};
    }else
    {
        self.navigationBar.barTintColor = WJColorWhite;
        //    self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                                   NSForegroundColorAttributeName:WJColorBlack};
    }
}


@end
