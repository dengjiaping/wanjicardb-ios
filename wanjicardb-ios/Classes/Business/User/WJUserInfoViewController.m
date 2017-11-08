//
//  WJUserInfoViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 15/12/24.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "WJUserInfoViewController.h"
#import "WJAboutUsViewController.h"
#import "WJFindPasswordViewController.h"
#import "WJFeedbackViewController.h"
#import "WJUseHelpViewController.h"

#import "UserLoginViewController.h"
#import "WJNavigationController.h"

@interface WJUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView        * mainTableView;
}

@property(nonatomic,strong)    UIButton           * exitBtn;


@end

@implementation WJUserInfoViewController

#pragma mark- Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    [self.view addSubview:self.tableView];
    [self hiddenBackBarButtonItem];
    [self.view addSubview:self.exitBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(15);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(45);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return 4;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = WJColorDardGray6;
    cell.textLabel.font = WJFont16;
    if (indexPath.section == 0) {
        cell.textLabel.text = @"修改/找回密码";
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"联系客服";
        }if (indexPath.row == 1) {
            cell.textLabel.text = @"意见反馈";
        }if (indexPath.row == 2) {
            cell.textLabel.text = @"使用帮助";
        }if (indexPath.row == 3) {
            cell.textLabel.text = @"关于我们";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([CBPassport isMain]) {
            WJFindPasswordViewController *findPsd = [[WJFindPasswordViewController alloc]init];
            [findPsd setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:findPsd animated:YES];
        }else{
            ALERT(@"请联系总店重置密码");
        }
    } else {
        if (indexPath.row == 0) {
            [self cellTelephone];
        }if (indexPath.row == 1) {
            WJFeedbackViewController *feedbackVC = [[WJFeedbackViewController alloc]init];
            [feedbackVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }if (indexPath.row == 2) {
            WJUseHelpViewController *useHelpVC = [[WJUseHelpViewController alloc]init];
            [useHelpVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:useHelpVC animated:YES];
        }if (indexPath.row == 3) {
            WJAboutUsViewController *aboutUsVC = [[WJAboutUsViewController alloc]init];
            [aboutUsVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    }
}


#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            
            [CBPassport logout];
        
            UserLoginViewController * loginVC = [[UserLoginViewController alloc] init];
            WJNavigationController * userNav = [[WJNavigationController alloc ]initWithRootViewController:loginVC];
        
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController = userNav;
        
        }
            break;
            
        default:
            break;
    }

}


#pragma mark - UIButton Action

-(void)buttonAction{
    
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [av show];
    
    
}






-(void)cellTelephone{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"400-872-2002" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *allString = [NSString stringWithFormat:@"tel:4008722002"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark- Getter and Setter

-(UITableView* ) tableView
{
    if(nil == mainTableView)
    {
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorInset = UIEdgeInsetsZero;
        mainTableView.backgroundColor = WJColorViewBg;
        mainTableView.tableFooterView = [UIView new];
        
        if(!IOS8_LATER)
        {
            [mainTableView setSeparatorColor:[UIColor clearColor]];
        }
        
    }
    return mainTableView;
}

//- (UIView *) sectionFootView
//{
//    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(ALD(15), ALD(15), [UIScreen mainScreen].bounds.size.width, ALD(100))];
//    footView.backgroundColor = [UIColor clearColor];
//    self.exitBtn = [[UIButton alloc]init];
//    _exitBtn.frame = CGRectMake(0,ALD(180), ALD(345),ALD(48));
//    [_exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
//    _exitBtn.layer.cornerRadius = ALD(24);
////    _exitBtn.enabled = YES;
//    [_exitBtn setBackgroundColor:WJColorNavigationBar];
//    [_exitBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:_exitBtn];
//    return footView;
//}

- (UIButton *)exitBtn
{
    _exitBtn = [[UIButton alloc]init];
    _exitBtn.frame = CGRectMake((kScreenWidth - ALD(345))/2, kScreenHeight - ALD(220), ALD(345),ALD(48));
    [_exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    _exitBtn.layer.cornerRadius = ALD(24);
    [_exitBtn setBackgroundColor:WJColorNavigationBar];
    [_exitBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    return _exitBtn;
}


@end
