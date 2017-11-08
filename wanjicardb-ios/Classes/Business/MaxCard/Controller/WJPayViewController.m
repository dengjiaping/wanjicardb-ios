//
//  payController.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/7/31.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "WJPayViewController.h"
#import "UIHelper.h" 

#import "CBScanConfirmOrderClient.h"
#import "JPushPaySuccessClient.h"
#import "CBPassport.h"
#import "CBMoneyClient.h"
#import "WJPayResultViewController.h"

@interface WJPayViewController()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField       *priceTF;
@property (nonatomic, strong) CBMoneyClient     *moneyClient;
@property (nonatomic, strong) UIButton          *commitButton;
@end

@implementation WJPayViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.

    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Controller Flow
#pragma mark - Action
- (void)loadUI
{
    [self navigationAction];
    [self leftNavigationItem];
    [self.view setBackgroundColor:WJColorViewBg];
    
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(ALD(0), ALD(15), kScreenWidth - ALD(0), ALD(45))];
    bgView1.backgroundColor = [UIColor clearColor];
    bgView1.layer.borderWidth = 1;
    bgView1.layer.borderColor = [[UIColor clearColor] CGColor];
    
    UIView * bgView2 = [[UIView alloc] initWithFrame:CGRectMake(ALD(0), ALD(10) + bgView1.bottom, kScreenWidth - ALD(0), ALD(45))];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = [[UIHelper colorWithHexColorString:@"f3f6f6"] CGColor];
    
    UILabel * accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(10), 0, bgView1.width - ALD(10), ALD(45))];
    [accountLabel setText:[NSString stringWithFormat:@"消费账户：%@",[NSString stringWithFormat:@"1%@",[[self.payCode substringFromIndex:2] substringToIndex:10]]]];
    accountLabel.backgroundColor = [UIColor clearColor];
    accountLabel.textColor = WJColorDardGray3;
    accountLabel.font = WJFont14;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"消费金额：";
    priceLabel.textColor = WJColorDardGray3;
    priceLabel.font = WJFont14;
    [priceLabel sizeToFit];
    [priceLabel setFrame:CGRectMake(ALD(10), 0, CGRectGetWidth(priceLabel.frame), ALD(45))];
 
    
    [self.priceTF setFrame:CGRectMake(priceLabel.right, 0, bgView2.width - priceLabel.right , ALD(45))];
    [self.priceTF becomeFirstResponder];
    
    CGFloat height = 0;
    if(kScreenHeight == 480)
    {
        height = ALD(30);
    }
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commitButton setFrame:CGRectMake(ALD(15), bgView2.bottom + ALD(75) - height, kScreenWidth - ALD(30), ALD(40))];
    [self.commitButton setTitle:@"确认扣款" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitButton addTarget:self action:@selector(confirmCommit) forControlEvents:UIControlEventTouchUpInside];
    [self.commitButton setBackgroundColor:WJMainColor];
    self.commitButton.layer.cornerRadius = ALD(20);
    
    [self.view addSubview:bgView1];
    [self.view addSubview:bgView2];
    [self.view addSubview:self.commitButton];

    [bgView1 addSubview:accountLabel];
    [bgView2 addSubview:priceLabel];
    [bgView2 addSubview:self.priceTF];
  //  [self navigationBuild];
}
- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backView
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}

//- (void)navigationBuild
//{
//    
//    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
//    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    [leftButton setTitleColor:[UIHelper colorWithHexColorString:@"#007aff"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}

- (void)goBack:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goToControllerWithResult:(BOOL)result message:(NSDictionary *)dic
{
    WJPayResultViewController * resultVC = [[WJPayResultViewController alloc] init];
    resultVC.result = result;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void) confirmCommit
{

    if ([self.priceTF.text isEqualToString:@""]) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入消费金额"];
        return;
    }
    
    NSArray * countArray = [self.priceTF.text componentsSeparatedByString:@"."];
    
    BOOL result = ([self isPureFloat:self.priceTF.text]);//判断能不能转换为浮点型
    NSString * lastStr = [countArray lastObject];
  
    if ([self isPureInt:self.priceTF.text]) {
        
    }else
    {
        result = result && ([countArray count] == 2 && (lastStr.length <= 2));//若为浮点型 后面最多2位
    }
    
    CGFloat resultFloat = [self.priceTF.text floatValue];
    result = result && resultFloat > 0;
    
//    if (![self isPureInt:self.priceTF.text] && [countArray count] == 1) {
//        [self showHUDWithText:@"您输入的价格不正确"];
//        self.priceTF.text = @"";
//        return;
//    }
//    if( ![self isPureFloat:self.priceTF.text] || [countArray count] > 2 || ([countArray count] == 2 && ((NSString *)[countArray lastObject]).length > 2)) //判断都为int型或浮点型，且一个小数点。并 小数点后面最多2为小数
//    {
//        [self showHUDWithText:@"您输入的价格不正确"];
//        self.priceTF.text = @"";
//        return;
//    }
    
    if(!result) //判断都为int型或浮点型，且一个小数点。并 小数点后面最多2为小数
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"您输入的价格不正确"];

        self.priceTF.text = @"";
        return;
    }
    
//    if(![self isPureInt:self.priceTF.text]) //判断都为int型或浮点型，且一个小数点。并 小数点后面最多2为小数
//    {
//        [self showHUDWithText:@"您输入的价格不正确"];
//        self.priceTF.text = @"";
//        return;
//    }
//    NSString * payCode = [NSString stringWithFormat:@"1%@",[[self.payCode substringFromIndex:2] substringToIndex:10]];
    WJPayViewController *weakSelf = self;
    __block WJPayResultViewController * resultVC = [[WJPayResultViewController alloc] init];
    
    self.commitButton.userInteractionEnabled = NO;
    NSLog(@"%@",self.payCode);
//    [self.progressHUD show:YES];
    
    [self.moneyClient spendNcomsumeWithAmount:self.priceTF.text payCode:self.payCode finished:^(BOOL success, NSString *message) {
        if (success) {
            resultVC.account = [NSString stringWithFormat:@"1%@",[[weakSelf.payCode substringFromIndex:2] substringToIndex:10]];
            resultVC.amount = weakSelf.priceTF.text;
            resultVC.result = YES;
        }else
        {
            resultVC.message = message;
        }
//        [self.progressHUD hide:YES];
        self.commitButton.userInteractionEnabled = YES;
        [weakSelf.navigationController pushViewController:resultVC animated:YES];
    }];
    
    //JPushPaySuccessClient * jpushClient=[[JPushPaySuccessClient alloc]init];
    
//    [cbConfirmClient addConsumeOrderWithMerid:[NSString stringWithFormat:@"%d",[CBPassport merID] ] userId:self.clientUserID Amount:self.payMoneyTF.text payCode:self.payCode Token:[CBPassport userToken] finished:^(BOOL success, CBConfirmOrder *confirmOrderModel, NSString *message) {
//        
//       if(success)
//       {
//           if(confirmOrderModel)
//           {
//               
//               NSLog(@"======%@",confirmOrderModel);
//               confirmVC.confirmOrderNumLabel.text=[NSString stringWithFormat:@"订单号:%@", confirmOrderModel.confirmOrderNum];
//               confirmVC.confirmPayUserPhoneLabel.text=[NSString stringWithFormat:@"支付用户手机号:%@",confirmOrderModel.confirmUserName];
//               
//               confirmVC.confirmOrderAmountLabel.text=[NSString stringWithFormat:@"支付金额:%@",confirmOrderModel.confirmAmount];
//               
//               confirmVC.confirmPayOrNotLabel.text=[NSString stringWithFormat:@"等待用户支付.."];
//               
//               [self.navigationController pushViewController:confirmVC animated:YES];
//              /*
//               JPushPaySuccessClient * jpushClient=[[JPushPaySuccessClient alloc]init];
//               NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//               NSString *regid= [user objectForKey:DeviceTokenStringKEY];
//               
//               
//               [jpushClient jpushConfirmPay:regid finished:^(BOOL success, CBMetaData *metaData, NSString *message) {
//               if (success) {
//               ConfirmOrderViewController *confirmVC=[[ConfirmOrderViewController alloc]init];
//               confirmVC.confirmPayOrNotLabel.text=[NSString stringWithFormat:@"用户支付成功！"];
//               //                confirmVC.confirmPayOrNotLabel.text=[NSString stringWithFormat:@"用户支付成功！"];
//               //                confirmVC.confirmPayOrNotLabel.textColor=[UIColor redColor];
//               NSLog(@"支付成功了。。。。");
//               }
//               }];
//
//               */
//           }else{
//               [self showCustomDialog:@"服务器未响应该订单"];
//           }
//           
//       }
//        else
//        {
//            [self showCustomDialog:@"确定订单失败！"];
//        }
//    }];
    
    
}

- (void)navigationAction
{
    self.navigationItem.title = @"收银台";
    
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

#pragma mark - Delegate
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"\nrange = %@\nstarting = %@ \n text = %@",[NSValue valueWithRange:range],string,textField.text);
    
    if([string isEqualToString:@""])//删除键
    {
        return YES;
    }
    
    if ([textField.text isEqualToString:@"0"] && [string isEqualToString:@"0"]) {
        return NO;
    }//连续输入0
    
    if([textField.text isEqualToString:@""] && [string isEqualToString:@"."])
    {
        textField.text = @"0";
        return YES;
    }
    
    if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"0"] && [self isPureInt:string]) {
        textField.text = @"";
        return YES;
    }//输入012 显示12
    
    if (![self isPureInt:string] && ![string isEqualToString:@"."]) {
        return NO;
    }//输入的非 数字 且非.
    
    NSArray * countArray = [self.priceTF.text componentsSeparatedByString:@"."];
    switch ([countArray count]) {
        case 1://没有小数点
        {
            if ([self isPureInt:string]) {
                if (textField.text.length >4) {
//                    [self showHUDWithText:@"消费金额最大为"];
                    return NO;//最多5位
                }
                return YES;
            }else
            {//输入点 永远可以
                if([textField.text rangeOfString:@"."].location == NSNotFound)//_roaldSearchText
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        }
            break;
        case 2://已经包含小数点
        {
            if ([string isEqualToString:@"."] ) {//再次输入小数点
                return NO;
            }else
            {
                if (((NSString *)[countArray lastObject]).length >1) {//小数点后只能2位
                    return NO;
                }
//                if ([[countArray lastObject] isEqualToString:@"0"] && [string isEqualToString:@"0"]) {
//                    return NO;
//                }
            }
            return YES;
        }
        default:
            return NO;
            break;
    }
    return NO;
}



#pragma mark - Property

- (UITextField *)priceTF
{
    if (!_priceTF) {
        _priceTF = [[UITextField alloc] init];
        [_priceTF setBorderStyle:UITextBorderStyleNone];
        _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
        _priceTF.delegate = self;
//        _priceTF.textColor = [UIHelper colorWithHexColorString:@"999999"];
        _priceTF.placeholder = @"请输入消费金额";
        _priceTF.textColor = WJColorDardGray3;
        _priceTF.font = WJFont14;
    }
    return _priceTF;
}

- (CBMoneyClient *)moneyClient
{
    if (!_moneyClient) {
        _moneyClient = [[CBMoneyClient alloc] init];
    }
    return _moneyClient;
}

@end
