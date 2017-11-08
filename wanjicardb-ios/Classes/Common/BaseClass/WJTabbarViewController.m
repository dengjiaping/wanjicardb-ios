//
//  WJTabbarViewController.m
//  WanJiCard
//
//  Created by Lynn on 15/12/24.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJTabbarViewController.h"

@interface WJTabbarViewController ()

@end

@implementation WJTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tabbarAppearance
{
    [[UITabBar appearance] setTintColor:WJMainColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: WJMainColor,
                                                        NSFontAttributeName: [UIFont systemFontOfSize:20.0f]}
                                             forState:UIControlStateSelected];
    //    [[UITabBar appearance] setBackgroundImage:[UIHelper createImageWithColor:[UIHelper getMainHeaderColor]]];
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
