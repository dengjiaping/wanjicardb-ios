//
//  LoginView.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/10.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBIconTextField;
@interface LoginView : UIView

@property(nonatomic, strong) UITextField * userIconTF;
@property(nonatomic, strong) UITextField * passwordIconTF;
@property(nonatomic, strong) UIButton    * signInButton;
@property(nonatomic, strong) UIButton    * signUpButton;
@property(nonatomic, strong) UIButton    * forgetButton;

@end
