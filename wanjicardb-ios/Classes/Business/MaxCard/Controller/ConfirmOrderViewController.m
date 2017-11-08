//
//  ConfirmOrderViewController.m
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "Configure.h"
@interface ConfirmOrderViewController ()

@end

@implementation ConfirmOrderViewController
#pragma property

- (instancetype)init
{
    if (self = [super init]) {
        
        
        _confirmReTryButton= [[UIButton alloc] init];
        _confirmReTryButton.frame=CGRectMake(20, 180, kScreenWidth - 40, 40);
        _confirmReTryButton.backgroundColor=[UIColor orangeColor];
        [_confirmReTryButton setTitle:@"重试" forState:UIControlStateNormal];
        
         //self.view.backgroundColor = [UIHelper getMainBackgroundColor];
        _confirmOrderNumLabel = [[UILabel alloc] init];
        _confirmOrderNumLabel.frame=CGRectMake(20, 20, kScreenWidth - 40, 30);
        _confirmOrderNumLabel.textColor=[UIHelper colorWithHexColorString:@"#555555"];
       // _confirmOrderNumLabel.backgroundColor=[UIHelper colorWithHexColorString:@"#cccccc"];
        
        _confirmPayUserPhoneLabel= [[UILabel alloc] init];
        _confirmPayUserPhoneLabel.frame=CGRectMake(20, 60, kScreenWidth - 40, 30);
         _confirmPayUserPhoneLabel.textColor=[UIHelper colorWithHexColorString:@"#555555"];
        //_confirmPayUserPhoneLabel.backgroundColor=[UIHelper colorWithHexColorString:@"#cccccc"];
        
        _confirmOrderAmountLabel= [[UILabel alloc] init];
        _confirmOrderAmountLabel.frame=CGRectMake(20, 100, kScreenWidth - 40, 30);
         _confirmOrderAmountLabel.textColor=[UIHelper colorWithHexColorString:@"#555555"];
       // _confirmOrderAmountLabel.backgroundColor=[UIHelper colorWithHexColorString:@"#cccccc"];
        
        _confirmPayOrNotLabel= [[UILabel alloc] init];
        _confirmPayOrNotLabel.frame=CGRectMake(0, 0, kScreenWidth, 30);
        _confirmPayOrNotLabel.center=self.view.center;
        _confirmPayOrNotLabel.textAlignment=NSTextAlignmentCenter;
         _confirmPayOrNotLabel.textColor=[UIHelper colorWithHexColorString:@"#555555"];
       // _confirmPayOrNotLabel.backgroundColor=[UIHelper colorWithHexColorString:@"#cccccc"];

        
    }
    
    return self;
}


#pragma circleLife
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Action
-(void) loadUI
{
    [self navigationAction];
    [self.view setBackgroundColor:[UIHelper getMainBackgroundColor]];
    [self.view addSubview:self.confirmOrderAmountLabel];
    [self.view addSubview:self.confirmOrderNumLabel];
    [self.view addSubview:self.confirmPayUserPhoneLabel];
    [self.view addSubview:self.confirmPayOrNotLabel];
    [self.view addSubview:self.confirmReTryButton];
    
    [self leftNavigationItem];
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) navigationAction
{
    self.navigationItem.title=@"确认订单";
}

//-(void) waitUserPay
//{
//    //
//    JPushPaySuccessClient * jpushClient=[[JPushPaySuccessClient alloc]init];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *regid= [user objectForKey:DeviceTokenStringKEY];
//    
//    NSLog(@"后台方法调用的regid的值为======%@",regid);
//    [jpushClient jpushConfirmPay:regid finished:^(BOOL success, CBMetaData *metaData, NSString *message) {
//        if (success) {
//            confirmVC.confirmPayOrNotLabel.text=[NSString stringWithFormat:@"用户支付成功！"];
//            confirmVC.confirmPayOrNotLabel.textColor=[UIColor redColor];
//            NSLog(@"支付成功了。。。。");
//        }
//        else
//        {
//            NSLog(@"jpush fail.....");
//        }
//    }];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
