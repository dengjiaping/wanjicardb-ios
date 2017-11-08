//
//  WJFindPasswordViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJFindPasswordViewController.h"
#import "WJSetPasswordController.h"
#import "WJPickView.h"
#import "CBMoneyClient.h"
#import "CBUserClient.h"

@interface WJFindPasswordViewController ()<UITextFieldDelegate>
{
    NSTimer    * verifyTimer;
    NSInteger    timeCount;
}

@property(nonatomic,strong) UIView       * backgroundView;
@property(nonatomic,strong) UILabel      * phoneLabel;
@property(nonatomic,strong) UITextField  * phoneTF;
@property(nonatomic,strong) UIView       * line;
@property(nonatomic,strong) UILabel      * verifyLabel;
@property(nonatomic,strong) UITextField  * verifyTF;
@property(nonatomic,strong) UIButton     * verifyCodeBtn;
@property(nonatomic,strong) UIButton     * nextBtn;

@end

@implementation WJFindPasswordViewController

#pragma mark- Life cycle

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //    [self navigationBarIsWhite:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneTF];
    [self.view addSubview:self.line];
    [self.view addSubview:self.verifyLabel];
    [self.view addSubview:self.verifyTF];
    [self.view addSubview:self.verifyCodeBtn];
    [self.view addSubview:self.nextBtn];

}


#pragma mark - verifyTime

- (void)backBarButton:(UIButton *)btn
{
    [super backBarButton:btn];
    [verifyTimer invalidate];
    verifyTimer = nil;
}

- (void)startTimer
{
    [self.verifyCodeBtn setTitle:@"60秒" forState:UIControlStateNormal];
    self.verifyCodeBtn.enabled = NO;
    timeCount = 60;
    verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnTitle) userInfo:nil repeats:YES];
    [verifyTimer fire];
}

- (void)changeBtnTitle
{
    if (timeCount <= 0) {
        timeCount = 60;
        [self deleteTimerWhenBack];
        [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verifyCodeBtn.enabled = YES;
    }else{
        [self.verifyCodeBtn setTitle:[NSString stringWithFormat:@"%@秒", @(timeCount--)] forState:UIControlStateNormal];
    }
}

- (void)deleteTimerWhenBack{
    [verifyTimer invalidate];
    verifyTimer = nil;
}

#pragma mark - UIButton Action

- (void)getVerifyAction
{
    if (![WJUtilityMethod isValidatePhone:self.phoneTF.text]) {
        ALERT(@"请输入正确手机号");
    }else{
        __weak WJFindPasswordViewController * weakSelf = self;
        [[CBUserClient shareRESTClient] sendSMSWithPhone:self.phoneTF.text finished:^(BOOL success, NSDictionary *data, NSString *message) {
            if (success) {
                [weakSelf startTimer];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"验证码发送成功"];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
            }
        }];
    }
    
}

- (void)nextBtnAction
{
    if (![WJUtilityMethod isValidateVerifyCode:self.verifyTF.text]) {
        ALERT(@"请输入正确格式的验证码");
        return;
    }else{
        [[CBUserClient shareRESTClient] verifyCodeWithPhone:self.phoneTF.text code:self.verifyTF.text finished:^(BOOL success, NSDictionary *data, NSString *message) {
            if (success) {
                WJSetPasswordController * setPsdVC = [[WJSetPasswordController alloc]init];
                setPsdVC.phoneStr = self.phoneTF.text;
                setPsdVC.verifyCodeStr = self.verifyTF.text;
                [self.navigationController pushViewController:setPsdVC animated:YES];
            }else{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"验证码错误"];
            }
        }];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTF resignFirstResponder];
    [self.verifyTF resignFirstResponder];
}
#pragma mark- Getter and Setter

- (UIView *)backgroundView
{
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.frame = CGRectMake(0, 2, kScreenWidth, ALD(91));
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UILabel *)phoneLabel
{
    if (nil == _phoneLabel)
    {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.text = @"手机号";
        _phoneLabel.font = WJFont14;
        _phoneLabel.frame = CGRectMake(ALD(15), 2, ALD(55), ALD(45));
        _phoneLabel.backgroundColor = [UIColor whiteColor];
    }
    return _phoneLabel;
}

- (UITextField *)phoneTF
{
    if (nil == _phoneTF) {
        _phoneTF = [[UITextField alloc]init];
        _phoneTF.frame = CGRectMake(self.phoneLabel.right + ALD(15), 2, ALD(200), ALD(45));
        _phoneTF.font = WJFont14;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.placeholder = @"请输入您的手机号";
        _phoneTF.text = [CBPassport userName];
        if ([self.comeFrom isEqualToString:@"login"]) {
            _phoneTF.userInteractionEnabled = YES;
        }else{
            _phoneTF.userInteractionEnabled = NO;
        }
        _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTF.delegate = self;
    }
    return _phoneTF;
}

- (UIView *)line
{
    if (nil == _line)
    {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.phoneLabel.bottom, kScreenWidth, 1)];
        _line.backgroundColor = WJColorViewBg;
    }
    return _line;
}

- (UILabel *)verifyLabel
{
    if (nil == _verifyLabel)
    {
        _verifyLabel = [[UILabel alloc]init];
        _verifyLabel.text = @"验证码";
        _verifyLabel.font = WJFont14;
        _verifyLabel.frame = CGRectMake(ALD(15), self.line.bottom, ALD(55), ALD(45));
        _verifyLabel.backgroundColor = [UIColor whiteColor];
    }
    return _verifyLabel;
}

- (UITextField *)verifyTF
{
    if (nil == _verifyTF) {
        _verifyTF = [[UITextField alloc]init];
        _verifyTF.frame = CGRectMake(self.verifyLabel.right + ALD(15), self.line.bottom, 150, ALD(45));
        _verifyTF.font = WJFont14;
//        _verifyTF.text = @"0000";
        _verifyTF.keyboardType = UIKeyboardTypeNumberPad;
        _verifyTF.placeholder = @"请输入您的验证码";
        _verifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyTF.delegate = self;
    }
    return _verifyTF;
}

- (UIButton *)verifyCodeBtn
{
    if (nil == _verifyCodeBtn) {
        _verifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyCodeBtn.frame = CGRectMake(kScreenWidth - ALD(100), self.verifyTF.centerY - ALD(15), ALD(90), ALD(30));
        [_verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyCodeBtn setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        _verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _verifyCodeBtn.layer.cornerRadius = ALD(15);
        _verifyCodeBtn.layer.borderColor = [WJColorNavigationBar CGColor];
        _verifyCodeBtn.layer.borderWidth = 0.5;
        [_verifyCodeBtn addTarget:self action:@selector(getVerifyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyCodeBtn;
}

- (UIButton *)nextBtn
{
    if (nil == _nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake((kScreenWidth - ALD(345))/2, ALD(150), ALD(345), ALD(48));
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius = ALD(24);
        _nextBtn.enabled = YES;
        [_nextBtn setBackgroundColor:WJColorNavigationBar];
        [_nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
