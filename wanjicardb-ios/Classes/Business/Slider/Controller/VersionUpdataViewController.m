//
//  VersionUpdataViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "VersionUpdataViewController.h"
#import "UIHelper.h"

@interface VersionUpdataViewController ()

@end

@implementation VersionUpdataViewController

#pragma mark - Property
#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Controller Flow
#pragma mark - Action

- (void)loadUI
{
    self.view.backgroundColor = [UIHelper randomColor];
    [self navigationAction];
}

- (void)navigationAction
{
    self.navigationItem.title = @"版本更新";
}

#pragma mark - Delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
