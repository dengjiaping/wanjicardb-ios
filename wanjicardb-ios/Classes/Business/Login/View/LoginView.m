//
//  LoginView.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/10.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "LoginView.h"
#import "Configure.h"

#define kLogoImageTop           64.0
#define kLogoImageHeight        89.0

#define kImageTop                       10.0
#define kImageHeight                20.0
#define kImageLeft                      ALD(15)
#define kImageWidth                 ALD(60)
#define kImageGap                   ALD(15)
#define kBackGap                        20.0
#define kButtonGap                  18.0

@interface LoginView()<UITextFieldDelegate>
{
//    UIImageView * accountImageView;
//    UIImageView * passwordImageView;
    UILabel * accountLabel;
    UILabel * passwordLabel;
    UIView      * backView;
    UIView      * line;
}
@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIHelper getMainBackgroundColor];
//        accountImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signinUser"]];
//        passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signinPassword"]];

        accountLabel = [[UILabel alloc] init];
        accountLabel.text = @"用户名"; 
        accountLabel.textAlignment = NSTextAlignmentCenter;
        accountLabel.textColor = WJColorDardGray3;
        
        passwordLabel = [[UILabel alloc] init];
        passwordLabel.text = @"密   码";
        passwordLabel.textAlignment = NSTextAlignmentCenter;
        passwordLabel.textColor = WJColorDardGray3;
        
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [[UIHelper colorWithHexColorString:@"e0e0e0"] CGColor];
        
        line = [[UIView alloc] init];
        line.backgroundColor = [UIHelper colorWithHexColorString:@"e0e0e0"];
        
        _userIconTF = [[UITextField alloc] init];
        _userIconTF.placeholder = @"请输入您的用户名";
        _userIconTF.keyboardType = UIKeyboardTypeDefault;
        
        _passwordIconTF = [[UITextField alloc] init];
        _passwordIconTF.placeholder = @"请输入您的密码";
        _passwordIconTF.secureTextEntry = YES;
        
#ifdef DEBUG
//        _userIconTF.text = @"13800000000";
//        _passwordIconTF.text = @"123456";
#else
        
#endif
        _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signInButton.backgroundColor = [UIHelper colorWithHexColorString:@"aaaaaa"];
        [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signInButton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [_signInButton setTitle:@"登录" forState:UIControlStateNormal];
        _signInButton.layer.cornerRadius = ALD(22);
//        [_signInButton setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
        
        UIColor * textColor = [UIHelper colorWithHexColorString:@"797979"];

        _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signUpButton setBackgroundColor:[UIColor clearColor]];
        [_signUpButton setTitleColor:textColor forState:UIControlStateNormal];
        [_signUpButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_signUpButton setTitle:Localized(@"signup") forState:UIControlStateNormal];
        
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setBackgroundColor:[UIColor clearColor]];
        [_forgetButton setTitleColor:textColor forState:UIControlStateNormal];
        [_forgetButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_forgetButton setTitle:@"总店账户忘记密码" forState:UIControlStateNormal];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        backView.translatesAutoresizingMaskIntoConstraints = NO;
//        accountImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _userIconTF.translatesAutoresizingMaskIntoConstraints = NO;
//        passwordImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _passwordIconTF.translatesAutoresizingMaskIntoConstraints = NO;
        line.translatesAutoresizingMaskIntoConstraints = NO;
        _signUpButton.translatesAutoresizingMaskIntoConstraints = NO;
        _signInButton.translatesAutoresizingMaskIntoConstraints = NO;
        _forgetButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        
        [self addGestureRecognizer:tap];
        [backView addGestureRecognizer:tap1];
        
        self.backgroundColor = WJColorViewBg;
        
        
        [self addSubview:backView];
        [backView addSubview:accountLabel];
        [backView addSubview:_userIconTF];
        [backView addSubview:passwordLabel];
        [backView addSubview:_passwordIconTF];
        [backView addSubview:line];
        [self addSubview:_signInButton];
//        [self addSubview:_signUpButton];
        [self addSubview:_forgetButton];
    }
    return self;
}

- (void)layoutSubviews
{
//    115/640 = xx/width
    [self layoutUI];
    [super layoutSubviews];
}

- (void)tapAction
{
    [_userIconTF resignFirstResponder];
    [_passwordIconTF resignFirstResponder];
}

- (void)layoutUI
{
    float width =([[UIScreen mainScreen] bounds].size.width - 88)/2;
    float height = 0;
    if(KScreenHeight == 480)//适配4S 
    {
         height = 30;
    }else
    {
         height = 0;
    }

    
    [backView setFrame:CGRectMake(0, ALD(15)  , [UIScreen mainScreen].bounds.size.width, 88)];
    [accountLabel setFrame:CGRectMake(kImageLeft, kImageTop, kImageWidth, kImageHeight)];
    

    
    CGFloat tfX = kImageLeft + kImageWidth + kImageGap;
    [_userIconTF setFrame:CGRectMake(tfX, 6, kScreenWidth - tfX -kImageGap, 30)];
    
    [line setFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    
    [passwordLabel setFrame:CGRectMake(kImageLeft, 44 + kImageTop, kImageWidth, kImageHeight)];
    [_passwordIconTF setFrame:CGRectMake(tfX, 6 + 44, _userIconTF.width, _userIconTF.height)];
    
    [_signInButton setFrame:CGRectMake(kImageLeft, backView.top + backView.height + ALD(75), kScreenWidth - 2 * kImageLeft, ALD(44))];
    [_signUpButton setFrame:CGRectMake(kImageLeft, backView.top + backView.height + kBackGap, kScreenWidth /2 -kImageLeft,20)];
    [_forgetButton setFrame:CGRectMake(kScreenWidth/2, _signUpButton.top, _signUpButton.width, _signUpButton.height)];
}
/*
- (void)VFLlayout
{
    float width =([[UIScreen mainScreen] bounds].size.width - 88)/2;
    NSMutableArray * tempConstraints = [NSMutableArray array];
    
    NSString * backViewVString = [NSString stringWithFormat:@"V:|-%f-[backView(%f)]",ALD(15),88.0f];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:backViewVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
    
    
    NSString * backViewHString = [NSString stringWithFormat:@"H:|[backView(==%f)]|",[[UIScreen mainScreen] bounds].size.width];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:backViewHString options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView)]];
    
    NSString * accountImageViewVString = [NSString stringWithFormat:@"V:|-%f-[accountImageView(%f)]",kImageTop,kImageHeight];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:accountImageViewVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(accountImageView)]];
    
    NSString * accountTFVString = [NSString stringWithFormat:@"V:|-%f-[_userIconTF(30)]",6.0];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:accountTFVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userIconTF,accountImageView)]];
    
    NSString * accountImageViewHString = [NSString stringWithFormat:@"H:|-%f-[accountImageView(%f)]-%f-[_userIconTF]-%f-|",kImageLeft,kImageWidth,kImageGap,kImageLeft];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:accountImageViewHString options:0 metrics:nil views:NSDictionaryOfVariableBindings(accountImageView,_userIconTF)]];
    
    NSString * lineVString = [NSString stringWithFormat:@"V:|-40-[line(1)]"];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:lineVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
    
    NSString * lineHString = [NSString stringWithFormat:@"H:|-%f-[line]-%f-|",kImageLeft,kImageLeft];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:lineHString options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
    
    NSString * passwordImageViewVString = [NSString stringWithFormat:@"V:[line]-%f-[passwordImageView(%f)]",kImageTop,kImageHeight];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordImageViewVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(line,passwordImageView)]];
    
    NSString * passwordTFVString = [NSString stringWithFormat:@"V:[line]-6-[_passwordIconTF(==30.0)]"];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordTFVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(line,_passwordIconTF,passwordImageView)]];
    
    NSString * passwordHString = [NSString stringWithFormat:@"H:|-%f-[passwordImageView(%f)]-%f-[_passwordIconTF]-%f-|",kImageLeft,kImageWidth,kImageGap,kImageLeft];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordHString options:0 metrics:nil views:NSDictionaryOfVariableBindings(passwordImageView,_passwordIconTF)]];
    
    NSString * signInButtonVString = [NSString stringWithFormat:@"V:[backView]-%f-[_signInButton(44)]-%f-[_signUpButton(20)]",kButtonGap,kButtonGap];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:signInButtonVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(backView,_signInButton,_signUpButton)]];
    
    NSString * signInButtonHString = [NSString stringWithFormat:@"H:|-%f-[_signInButton]-%f-|",kImageLeft,kImageLeft];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:signInButtonHString options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signInButton)]];
    
    NSString * forgetButtonVString = [NSString stringWithFormat:@"V:[_signInButton]-%f-[_forgetButton(_signUpButton)]",kButtonGap];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:forgetButtonVString options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signInButton,_forgetButton,_signUpButton)]];
    
    NSString * signUpButtonHString = [NSString stringWithFormat:@"H:|-%f-[_signUpButton]-0-[_forgetButton(_signUpButton)]-%f-|",kImageLeft,kImageLeft];
    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:signUpButtonHString options:0 metrics:nil views:NSDictionaryOfVariableBindings(_signUpButton,_forgetButton)]];
    
    [self addConstraints:tempConstraints];
}
*/
@end
