//
//  WJPayResultViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/11/3.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "WJPayResultViewController.h"
#import "Configure.h"

//设备宽/高/坐标
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenFrame [UIScreen mainScreen].bounds


#define ALD(x)      (x * kScreenWidth/375.0)

#define kButtonTop   ALD(300)
@interface WJPayResultViewController ()

@property (nonatomic, strong)UILabel    *accountLable;
@property (nonatomic, strong)UILabel    *salePrice;
@property (nonatomic, strong)UILabel    *accountValueLabel;
@property (nonatomic, strong)UILabel    *salePriceValueLabel;
@property (nonatomic, strong)UIButton   *closeButton;

@end

@implementation WJPayResultViewController


#pragma mark- ClassMethods
// TODO:这里实现类方法。
#pragma mark- Initialization
#pragma mark- Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易结果";
        
    if (self.result) {
        self.accountValueLabel.text = self.account;
        
        self.salePriceValueLabel.text = [NSString stringWithFormat:@"¥%@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.amount floatValue]]];
    }
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Delegate
#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。
#pragma mark- Rotation
// TODO:转屏处理写在这。
#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。
- (void)setUI
{
    if(self.result)
    {
        [self.view addSubview:[self successUI]];

        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(70), kScreenWidth, 1)];
        line1.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e4e4e4"];
        
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(100), kScreenWidth, 1)];
        line2.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e4e4e4"];
        
        [self.view addSubview:self.accountLable];
        [self.view addSubview:self.salePrice];
        [self.view addSubview:self.accountValueLabel];
        [self.view addSubview:self.salePriceValueLabel];
        
        [self.view addSubview:line1];
        [self.view addSubview:line2];
    } else {
        [self.view addSubview:[self falseUI]];
    }
    
    self.view.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f3f6f6"];
    [self.view addSubview:self.closeButton];
    self.navigationItem.hidesBackButton = YES;
}

- (UIView *)successUI
{
    UIView      * bgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(0), ALD(0), kScreenWidth - ALD(0),ALD(130))];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIHelper colorWithHexColorString:@"ebebeb"] CGColor];
    
    UIImageView * tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(117), ALD(22), ALD(24), ALD(24))];
    tipImageView.image = [UIImage imageNamed:@"payResultSuccess"];
    
    UILabel     * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15) + tipImageView.right, tipImageView.top, ALD(100), tipImageView.height)];
    tipLabel.font = WJFont20;
    tipLabel.textColor = WJMainColor;
    tipLabel.text = @"收款成功";
    
    [tipLabel sizeToFit];
    
    CGFloat width = ALD(24)+ ALD(15)+tipLabel.width;
    
    [tipImageView setFrame:CGRectMake((kScreenWidth - width)/2, ALD(22), ALD(24), ALD(24))];
    [tipLabel setFrame:CGRectMake(ALD(15) + tipImageView.right, tipImageView.top, ALD(100), tipImageView.height)];
    
    
    [bgView addSubview:tipImageView];
    [bgView addSubview:tipLabel];
    bgView.backgroundColor = [UIColor whiteColor];
    return bgView;
}

- (UIView *)falseUI
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(ALD(0), ALD(0), kScreenWidth-ALD(0), ALD(120))];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIHelper colorWithHexColorString:@"ebebeb"] CGColor];
    UIImageView * tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(117), ALD(ALD(23)), ALD(24), ALD(24))];
    tipImageView.image = [UIImage imageNamed:@"payResultFalse"];
    
    UILabel     * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15) + tipImageView.right, tipImageView.top, ALD(100), tipImageView.height)];
    tipLabel.font = WJFont20;
    tipLabel.textColor = WJMainColor;
    tipLabel.text = @"收款失败";
    
    [tipLabel sizeToFit];
    
    CGFloat width = ALD(24)+ ALD(15)+tipLabel.width;
    
    [tipImageView setFrame:CGRectMake((kScreenWidth - width)/2, ALD(22), ALD(24), ALD(24))];
    [tipLabel setFrame:CGRectMake(ALD(15) + tipImageView.right, tipImageView.top, ALD(100), tipImageView.height)];
    
    UILabel     * reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), tipImageView.bottom + ALD(24), bgView.width - ALD(30), 30)];
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    reasonLabel.numberOfLines = 0;
    [reasonLabel setText:[NSString stringWithFormat:@"失败原因：%@",self.message]];
    reasonLabel.font = WJFont13;
    [reasonLabel setTextColor:WJColorDardGray3];
    
    [bgView addSubview:tipImageView];
    [bgView addSubview:tipLabel];
    [bgView addSubview:reasonLabel];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    [self.closeButton setFrame:CGRectMake(ALD(15), bgView.bottom + ALD(75), kScreenWidth - ALD(30), ALD(40))];

    
    return bgView;
}

- (void)backAction
{
//    if(self.result)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }else
//    {
    self.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
}

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这
- (UILabel *)accountLable
{
    if (nil == _accountLable) {
        _accountLable = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(70), kScreenWidth / 2 - ALD(15), ALD(30))];
        _accountLable.textColor = WJColorDardGray3;
        _accountLable.font = WJFont13;
        _accountLable.text = @"消费账户";
    }
    return _accountLable;
}

- (UILabel *)salePrice
{
    if (nil == _salePrice) {
        _salePrice = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(100), kScreenWidth / 2 - ALD(15), ALD(30))];
        _salePrice.textColor = WJColorDardGray3;
        _salePrice.font = WJFont13;
        _salePrice.text = @"消费金额";
    }
    return _salePrice;
}

- (UILabel *)accountValueLabel
{
    if (!_accountValueLabel) {
        _accountValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, ALD(70), kScreenWidth / 2 - ALD(15), ALD(30))];
        _accountValueLabel.textColor = WJColorDardGray3;
        _accountValueLabel.font = WJFont13;
        _accountValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _accountValueLabel;
}

- (UILabel *)salePriceValueLabel
{
    if (!_salePriceValueLabel) {
        _salePriceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2, ALD(100), kScreenWidth / 2 - ALD(10), ALD(30))];
        _salePriceValueLabel.textColor = WJColorDardGray3;
        _salePriceValueLabel.font = WJFont18;
        _salePriceValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _salePriceValueLabel;
}

- (UIButton *)closeButton
{
    if (nil == _closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setFrame:CGRectMake(ALD(15), kButtonTop, kScreenWidth - ALD(30), ALD(40))];
        [_closeButton setBackgroundColor:WJMainColor];
        _closeButton.layer.cornerRadius = ALD(20);
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
@end
