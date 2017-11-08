//
//  UserLoginViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/9.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "UserLoginViewController.h"
#import "WJMainTabbarViewController.h"
#import "WJFindPasswordViewController.h"
#import "LoginView.h"
#import "Configure.h"
#import "CBUserClient.h"

#import "WJUserLoginManager.h"

@interface UserLoginViewController()<UITextFieldDelegate,APIManagerCallBackDelegate>

@property (nonatomic, strong)LoginView          *loginView;
@property (nonatomic, strong)WJUserLoginManager *loginManager;

@end

@implementation UserLoginViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad
{
    [self loadUI];
    self.title = @"登录";
    
//    [self.loginManager loadData];
}

#pragma mark - View Controller Flow

- (void)goToMainPage
{
    
}

#pragma mark - Action

- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loginView];
}

- (void)signInRequest
{
    UserLoginViewController * weakSelf = self;
    
    [[CBUserClient shareRESTClient] loginWithPhone:self.loginView.userIconTF.text password:self.loginView.passwordIconTF.text finished:^(BOOL success, CBUser *userModel, NSString *message)
    {
        if (success) {
            [CBPassport storageUserInfo:userModel];
//            [self dismissViewControllerAnimated:YES completion:^{
//                [kDefaultCenter postNotificationName:kMainRefreshAction object:nil];
//            }];
            WJMainTabbarViewController * mainTabbarVC = [[WJMainTabbarViewController alloc] init];
//            [weakSelf.navigationController pushViewController:tabbar animated:YES];
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController = mainTabbarVC;
        }else
        {
            [[[UIAlertView alloc] initWithTitle:@"登录失败" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            NSAssert(YES, message);
        }
    }];
}

- (void)loginAction
{
    
}


- (void)signInButtonAction
{
    if(self.loginView.userIconTF.text.length == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"用户名不能为空"];
        return;
    }
    
    if (self.loginView.passwordIconTF.text.length == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码不能为空"];
        return;
    }else if ([self.loginView.passwordIconTF.text isValidPassword] == DDWeakPasswordTypeTooShort) {
//        DDWeakPasswordType weakType = [self.loginView.passwordIconTF.text isValidPassword];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"密码位数不正确"];
        return;
    };
    
    [self signInRequest];
}

- (void)signUpButtonAction
{
    NSLog(@"%s",__func__);
}

- (void)forgetButtonAction
{
    NSLog(@"%s",__func__);
    WJFindPasswordViewController * findPasswordVC = [[WJFindPasswordViewController alloc] init];
    findPasswordVC.comeFrom = @"login";
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

#pragma mark - Delegate




#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
    NSLog(@"%@",manager);
    NSLog(@"%s",__func__);
    [self hiddenLoadingView];
    
}


- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
    NSLog(@"%@",manager);
    NSLog(@"%s",__func__);
    [self hiddenLoadingView];
}


#pragma mark - TextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    if (self.loginView.userIconTF.text.length > 0 && self.loginView.passwordIconTF.text.length > 0) {
//        self.loginView.signInButton.enabled = YES;
//        self.loginView.signInButton.backgroundColor = [UIHelper colorWithHexColorString:@"ee3547"];
//    }else
//    {
//        self.loginView.signInButton.enabled = NO;
//        self.loginView.signInButton.backgroundColor = [UIHelper colorWithHexColorString:@"aaaaaa"];
//    }
//    return YES;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (self.loginView.userIconTF.text.length > 0 && self.loginView.passwordIconTF.text.length > 0) {
//        self.loginView.signInButton.enabled = YES;
//        self.loginView.signInButton.backgroundColor = [UIHelper colorWithHexColorString:@"ee3547"];
//    }else
//    {
//        self.loginView.signInButton.enabled = NO;
//        self.loginView.signInButton.backgroundColor = [UIHelper colorWithHexColorString:@"aaaaaa"];
//    }
//}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    if (self.loginView.userIconTF.text.length > 0 && self.loginView.passwordIconTF.text.length > 0) {
        self.loginView.signInButton.enabled = YES;
        self.loginView.signInButton.backgroundColor = WJMainColor;
//    }else
//    {
//        self.loginView.signInButton.enabled = NO;
//        self.loginView.signInButton.backgroundColor = [UIHelper colorWithHexColorString:@"aaaaaa"];
//    }
    return YES;
}


#pragma mark - Property
- (LoginView *)loginView
{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithFrame:self.view.frame];
        _loginView.userIconTF.delegate = self;
        _loginView.passwordIconTF.delegate = self;
        
        [_loginView.signInButton addTarget:self action:@selector(signInButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.signUpButton addTarget:self action:@selector(signUpButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_loginView.forgetButton addTarget:self action:@selector(forgetButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginView;
}

- (WJUserLoginManager *)loginManager
{
    if (!_loginManager) {
        _loginManager = [[WJUserLoginManager alloc] init];
        _loginManager.delegate = self;
        _loginManager.userName = @"13693249533";
        _loginManager.password = @"123456";
    }
    return _loginManager;
}

@end
