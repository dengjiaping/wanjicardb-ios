//
//  WJUseHelpViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJUseHelpViewController.h"

@interface WJUseHelpViewController ()

@end

@implementation WJUseHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用帮助";
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.wjika.com/dp/userhelp.html"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
