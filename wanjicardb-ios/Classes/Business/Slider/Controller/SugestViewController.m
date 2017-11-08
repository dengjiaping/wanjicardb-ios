//
//  SugestViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "SugestViewController.h"
#import "UIHelper.h"
#import "CBScanClient.h"
#import "CBUser.h"
#import "Configure.h"
#import "CBMain1ViewController.h"

@interface SugestViewController () <UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UILabel   * buildNumberLabel;

@end

@implementation SugestViewController

#pragma mark - Property
- (UILabel *)buildNumberLabel
{
    if (!_buildNumberLabel) {
        _buildNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenHeight - 50, kScreenWidth, 40)];
        
        _buildNumberLabel.text = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
        
    }
    return _buildNumberLabel;
}

-(UILabel *) adviceToplabel
{
    if(!_adviceToplabel){
        _adviceToplabel = [[UILabel alloc] init];
        [_adviceToplabel setText:@"我们期待听到你的声音，请简要描述你的问题和意见。"];
        [_adviceToplabel setFont:[UIFont systemFontOfSize:12]];
        _adviceToplabel.lineBreakMode = NSLineBreakByCharWrapping;
        _adviceToplabel.numberOfLines = 0;
        [_adviceToplabel setTextColor:[UIColor blackColor]];
        
        _adviceToplabel.enabled = YES;
        CGRect txtFrame = _adviceToplabel.frame;
        
        _adviceToplabel.frame= CGRectMake(10, 20, 350,
                                          txtFrame.size.height =[_adviceToplabel.text boundingRectWithSize:
                                                                 CGSizeMake(350, CGFLOAT_MAX)
                                                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:_adviceToplabel.font,NSFontAttributeName, nil] context:nil].size.height);
        // label.frame = CGRectMake(10, 10, 350, txtFrame.size.height);
    }
    return _adviceToplabel;
}

-(UITextView *) adviceTextView
{
    if(!_adviceTextView){
        _adviceTextView = [[UITextView alloc] init];
        _adviceTextView.frame=CGRectMake(10, 60, kScreenWidth - 20, 160);
        _adviceTextView.text=@"请输入...";
        _adviceTextView.textColor=[UIHelper colorWithHexColorString:@"#555555"];
        _adviceTextView.backgroundColor=[UIColor whiteColor];
        _adviceTextView.delegate=self;
    }
    return _adviceTextView;
}

-(UIButton*) adviceCommitBtn
{
    if(!_adviceCommitBtn){
        _adviceCommitBtn=[[UIButton alloc]init];
        _adviceCommitBtn.frame=CGRectMake(10, 230, kScreenWidth - 20, 40);
        _adviceCommitBtn.layer.cornerRadius=5;
        [_adviceCommitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
        [_adviceCommitBtn setBackgroundColor:[UIColor orangeColor]];
        [_adviceCommitBtn addTarget:self action:@selector(commitButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adviceCommitBtn;
}
-(UIAlertView*) adviceAlertButton
{
    if(!_adviceAlertButton){
        _adviceAlertButton= [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
    }
    _adviceAlertButton.delegate=self;
    return _adviceAlertButton;
}

-(MBProgressHUD*) adviceProgressButton
{
    if(!_adviceProgressButton)
    {
        
        _adviceProgressButton=[[MBProgressHUD alloc]init];
        _adviceProgressButton.mode=MBProgressHUDModeCustomView;
        _adviceProgressButton.labelText = @"操作成功";
        _adviceProgressButton.customView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark" ]];
    }
    return _adviceProgressButton;
}
#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Controller Flow
#pragma mark - Action

- (void)showCustomDialog
{
    
    
    
    [ _adviceProgressButton showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [_adviceProgressButton removeFromSuperview];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
}
//提交反馈
- (void)commitButton
{
    NSString * string  = [self.adviceTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if ([text isEqualToString:@"请输入..."] ||[text isEqualToString:@""]) {
        [self showHUDWithText:@"请输入您的宝贵意见"];
        return;
    }
    
    
    NSLog(@"%s",__func__);
    [_adviceTextView resignFirstResponder];
    
    NSLog(@"%d====CBPassport userID==",[CBPassport userID]);
    // CBPassport storageUserInfo:<#(CBUser *)#>
    
    NSString *userid=[NSString stringWithFormat:@"%d",[CBPassport userID] ];
    
    
    NSString *merid= [NSString stringWithFormat:@"%d",[CBPassport merID] ];
    NSLog(@"----merid--===:%@",merid);
    [[CBScanClient shareRESTClient] suggestWithMerID:merid UserID:userid content:self.adviceTextView.text appname:@"ios" appversion:@"1.0" finished:^(BOOL success, CBUser *userModel, NSString *message) {
        
        if(success)
        {
            [self showCustomDialog];
            //            _adviceAlertButton.message=@"提交成功！";
            //            [_adviceAlertButton show];
            
            
        }
        
    }];
    
    
}
- (void)loadUI
{
    [self navigationAction];
    [self.view setBackgroundColor:[UIHelper getMainBackgroundColor]];
    [self.view addSubview:self.adviceToplabel];
    [self.view addSubview:self.adviceTextView];
    [self.view addSubview:self.adviceCommitBtn];
    //  [self.view addSubview:self.adviceAlertButton];
    [self.view addSubview:self.adviceProgressButton];
    
#ifdef DEBUG
    [self.view addSubview:self.buildNumberLabel];
#endif
    
}

- (void)navigationAction
{
    self.navigationItem.title = @"意见反馈";
    
    [self leftNavigationItem];
  
}

- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    CBMain1ViewController *main=[[CBMain1ViewController alloc]init];
    [self.navigationController pushViewController:main animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.text){
        
        textView.textColor=[UIColor blackColor];
    }
    NSLog(@"textViewShouldEndEditing..");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    textView.textColor=[UIColor blackColor];
    textView.backgroundColor=[UIColor whiteColor];
    NSLog(@"textViewDidBeginEditing...");
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text){
        
        NSLog(@"textViewDidEndEditing...");
        
    }else{
        textView.text=@"请输入。。。";
        
        NSLog(@"textViewDidEndEditing");
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"%@",event);
    NSLog(@"%s",__func__);
    [_adviceTextView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
