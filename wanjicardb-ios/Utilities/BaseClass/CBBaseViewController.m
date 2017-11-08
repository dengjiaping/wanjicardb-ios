//
//  CBBaseViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/16.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseViewController.h"
#import "Configure.h"
#import "TKAlertCenter.h"

#define kDelayTime    2

@interface CBBaseViewController ()<MBProgressHUDDelegate>

@end

@implementation CBBaseViewController

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _progressHUD.delegate = self;
    }
    return _progressHUD;
}

- (void)showHUDWithText:(NSString *)text
{
//    self.progressHUD.mode = MBProgressHUDModeText;
//    self.progressHUD.labelText = text;
//    [self.progressHUD show:YES];
//
//    [self.progressHUD hide:YES afterDelay:kDelayTime];
    [[TKAlertCenter defaultCenter] postAlertWithMessage:text];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIHelper randomColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
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
