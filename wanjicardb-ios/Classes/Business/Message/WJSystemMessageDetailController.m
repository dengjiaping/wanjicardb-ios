//
//  WJSystemMessageDetailController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJSystemMessageDetailController.h"

@interface WJSystemMessageDetailController ()

@property(nonatomic,strong) UIView       * backgroundView;
@property(nonatomic,strong) UILabel      * textLabel;
@property(nonatomic,strong) UILabel      * timeLabel;

@end

@implementation WJSystemMessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"Title"]];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addConstraints:[self.timeLabel constraintsRightInContainer:ALD(15)]];
    [self.view addConstraints:[self.timeLabel constraintsTopInContainer:[self heightForString] + ALD(30)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- Getter and Setter

- (UIView *)backgroundView
{
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.frame = CGRectMake(0, 1, kScreenWidth, [self heightForString] + ALD(50));
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}

- (UILabel *)textLabel
{
    if (nil == _textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.frame = CGRectMake(ALD(15), ALD(17), kScreenWidth - ALD(30), [self heightForString]);
        _textLabel.font = WJFont14;
        _textLabel.textColor = WJColorDardGray6;
        _textLabel.numberOfLines = 0;
        _textLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"Content"]];
    }
    return _textLabel;
}

- (UILabel *)timeLabel
{
    if (nil == _timeLabel) {
        _timeLabel = [[UILabel alloc]initForAutoLayout];
        _timeLabel.font = WJFont12;
        _timeLabel.textColor = WJColorDardGray9;
        _timeLabel.numberOfLines = 0;
        _timeLabel.text = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"Date"]];
    }
    return _timeLabel;
}

- (CGFloat)heightForString
{
    NSString *str = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"Content"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(ALD(375), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.height;
}


@end
