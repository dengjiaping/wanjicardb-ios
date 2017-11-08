//
//  WJSetPasswordController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/11.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSetPasswordController.h"
#import "CBUserClient.h"

@interface WJSetPasswordController ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView       * backgroundView;
@property(nonatomic,strong) UILabel      * psdLabel;
@property(nonatomic,strong) UITextField  * psdTF;
@property(nonatomic,strong) UIView       * line;
@property(nonatomic,strong) UILabel      * surePsdLabel;
@property(nonatomic,strong) UITextField  * surePsdTF;
@property(nonatomic,strong) UIButton     * sureBtn;


@end

@implementation WJSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新密码";
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.psdLabel];
    [self.view addSubview:self.psdTF];
    [self.view addSubview:self.line];
    [self.view addSubview:self.surePsdLabel];
    [self.view addSubview:self.surePsdTF];
    [self.view addSubview:self.sureBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.psdTF resignFirstResponder];
    [self.surePsdTF resignFirstResponder];
}

- (void)sureBtnAction
{
    if ([WJUtilityMethod isNotReachable]) {
        if ([self.psdTF.text isEqualToString:self.surePsdTF.text]) {
            NSString * acswerStr = [self.surePsdTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([self.surePsdTF.text length] == [acswerStr length]){
                if ([self.surePsdTF.text length] >= 6) {
                    [[CBUserClient shareRESTClient]findPasswordWithPhone:self.phoneStr code:self.verifyCodeStr password:self.surePsdTF.text finished:^(BOOL success, NSDictionary *data, NSString *message) {
                        if (success) {
                            ALERT(@"密码设置成功");
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else{
                            ALERT(message);
                        }
                    }];
                }else{
                    ALERT(@"密码小于6位数");
                }
            }else{
                ALERT(@"密码不能包含空格");
            }
        }else{
            ALERT(@"两次输入的密码不一致");
        }
    }else{
        ALERT(@"请连接网络设置密码");
    }
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

- (UILabel *)psdLabel
{
    if (nil == _psdLabel)
    {
        _psdLabel = [[UILabel alloc]init];
        _psdLabel.text = @"新密码";
        _psdLabel.font = WJFont14;
        _psdLabel.frame = CGRectMake(ALD(15), 2, ALD(55), ALD(45));
        _psdLabel.backgroundColor = [UIColor whiteColor];
    }
    return _psdLabel;
}

- (UITextField *)psdTF
{
    if (nil == _psdTF) {
        _psdTF = [[UITextField alloc]init];
        _psdTF.frame = CGRectMake(self.psdLabel.right + ALD(15), 2, ALD(200), ALD(45));
        _psdTF.font = WJFont14;
        _psdTF.placeholder = @"请输入新密码";
        _psdTF.secureTextEntry = YES;
        _psdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _psdTF.delegate = self;
    }
    return _psdTF;
}

- (UIView *)line
{
    if (nil == _line)
    {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.psdLabel.bottom, kScreenWidth, 1)];
        _line.backgroundColor = WJColorViewBg;
    }
    return _line;
}

- (UILabel *)surePsdLabel
{
    if (nil == _surePsdLabel)
    {
        _surePsdLabel = [[UILabel alloc]init];
        _surePsdLabel.text = @"确认新密码";
        _surePsdLabel.font = WJFont14;
        _surePsdLabel.frame = CGRectMake(ALD(15), self.line.bottom, ALD(85), ALD(45));
        _surePsdLabel.backgroundColor = [UIColor whiteColor];
    }
    return _surePsdLabel;
}

- (UITextField *)surePsdTF
{
    if (nil == _surePsdTF) {
        _surePsdTF = [[UITextField alloc]init];
        _surePsdTF.frame = CGRectMake(self.surePsdLabel.right + ALD(15), self.line.bottom, 150, ALD(45));
        _surePsdTF.font = WJFont14;
        _surePsdTF.placeholder = @"请再次输入新密码";
        _surePsdTF.secureTextEntry = YES;
        _surePsdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _surePsdTF.delegate = self;
    }
    return _surePsdTF;
}

- (UIButton *)sureBtn
{
    if (nil == _sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake((kScreenWidth - ALD(345))/2, ALD(150), ALD(345), ALD(48));
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = ALD(24);
        _sureBtn.enabled = YES;
        [_sureBtn setBackgroundColor:WJColorNavigationBar];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}



@end
