//
//  WJAboutUsViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/7.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJAboutUsViewController.h"

@interface WJAboutUsViewController ()

@property(strong,nonatomic) UIImageView    * logoImageView;
@property(strong,nonatomic) UILabel        * versionLabel;
@property(strong,nonatomic) UILabel        * descriptionTopLabel;
@property(strong,nonatomic) UILabel        * descriptionBottomLabel;

@end

@implementation WJAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.descriptionTopLabel];
    [self.view addSubview:self.descriptionBottomLabel];
}

#pragma mark- Getter and Setter

- (UIImageView *)logoImageView
{
    if (nil == _logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image=[UIImage imageNamed:@"About-us_logo"];
        _logoImageView.frame = CGRectMake(kScreenWidth/2 - ALD(50), ALD(112), ALD(100),ALD(100) * 1.78);
    }
    return _logoImageView;
}

- (UILabel *)versionLabel
{
    if (nil == _versionLabel) {
        _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ALD(100) + (ALD(100) * 1.78) , kScreenWidth, ALD(20))];
        _versionLabel.text = [NSString stringWithFormat:@"万集卡商户端%@",[WJUtilityMethod versionNumber]];
        _versionLabel.textColor = WJColorDardGray9;
        _versionLabel.font = WJFont14;
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

- (UILabel *)descriptionTopLabel
{
    if (nil == _descriptionTopLabel) {
        _descriptionTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,KScreenHeight - 110,kScreenWidth, ALD(20))];
        _descriptionTopLabel.text = @"©2005-2016万集融合信息技术(北京)有限公司 版权所有";
        _descriptionTopLabel.textColor = WJColorDardGray9;
        _descriptionTopLabel.font = WJFont10;
        _descriptionTopLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _descriptionTopLabel;
}

- (UILabel *)descriptionBottomLabel
{
    if (nil == _descriptionBottomLabel) {
        _descriptionBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenHeight - 90,kScreenWidth, 20)];
        _descriptionBottomLabel.text=@"京公网安备11010802016306";
        _descriptionBottomLabel.textColor = WJColorDardGray9;
        _descriptionBottomLabel.font = WJFont10;
        _descriptionBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionBottomLabel;
}

@end
