//
//  WJMerchantManageController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/19.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMerchantManageController.h"
#import "WJMerchantListViewController.h"
#import "ShopPictureViewController.h"
#import "WJShopPhotoesViewController.h"
#import "CBShopInfoClient.h"

@interface WJMerchantManageController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView        * mainTableView;
}
@property(nonatomic,strong) UISwitch   * switchView;

@end

@implementation WJMerchantManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    self.title = @"店铺管理";
    
    [self leftNavigationItem];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                                                    NSForegroundColorAttributeName:WJColorDardGray3};
    [self.view addSubview:self.tableView];
}

- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backAction
{
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    return 3;
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
        cell.separatorInset = UIEdgeInsetsZero;
    }

    cell.textLabel.textColor = WJColorDardGray6;
    cell.textLabel.font = WJFont16;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"店铺信息";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }if (indexPath.row == 1) {
        cell.textLabel.text = @"相册管理";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }if (indexPath.row == 2) {
        cell.textLabel.text = @"店铺开关";
        self.switchView = [[UISwitch alloc]initForAutoLayout];
        [self verifySwitchStateWithIdenty:0];
//        [self.switchView setOn:[[CBPassport status] isEqual: @"30"]?YES:NO animated:YES];
        [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:_switchView];
        [cell.contentView addConstraints:[_switchView constraintsRightInContainer:15]];
        [cell.contentView addConstraint:[_switchView constraintCenterYEqualToView:cell.contentView]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WJMerchantListViewController * merchantListVC = [[WJMerchantListViewController alloc]init];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:merchantListVC animated:YES];
    }if (indexPath.row == 1) {
        WJShopPhotoesViewController *shopPictureVC = [[WJShopPhotoesViewController alloc] init];
//        self.tabBarController.tabBar.hidden = YES;
        [self setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:shopPictureVC animated:YES];
    }if (indexPath.row == 2) {
        
    }
}


#pragma mark - UIButton Action
-(void)switchAction:(id)sender
{
    [self verifySwitchStateWithIdenty:0];
    if (self.switchView.on) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认关闭店铺？" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [alert show];
    }else{
        [[CBShopInfoClient shareRESTClient]shopInfoWithStatus:@"30" finished:^(BOOL success, NSString *message) {
            NSLog(@"======%d",success);
            if (success) {
                [CBPassport storageStatus:@30];
                [self verifySwitchStateWithIdenty:0];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"开启店铺成功"];
            }
        }];
    }
    
}

//修改开关状态
- (void)verifySwitchStateWithIdenty:(int)num{
    if (num == 0) {
        //保持无密开关状态和存储key值状态一致
        NSLog(@"开关返回值%@",[CBPassport status]);
        [self changeSwitchIsOn];
    }
//    if (num == 1) {
//        //保持无密开关状态和存储key值状态一致
//        [self.switchView setOn:[[CBPassport status] isEqual: @"30"]?YES:NO animated:YES];
//    }
}

- (void)changeSwitchIsOn
{
    if ([[CBPassport status] isEqual:@10]) {
        self.switchView.on = NO;
    }else{
        self.switchView.on = YES;
    }
}




#pragma mark----UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 0){
            [[CBShopInfoClient shareRESTClient]shopInfoWithStatus:@"10" finished:^(BOOL success, NSString *message) {
                if (success) {
                    [CBPassport storageStatus:@10];
                    [self verifySwitchStateWithIdenty:0];
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"关闭店铺成功"];
                }
            }];
        }
        if (buttonIndex == 1) {
            [self verifySwitchStateWithIdenty:0];
        }
}

#pragma mark - Getter and Setter
-(UITableView* ) tableView
{
    if(nil == mainTableView)
    {
        mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.separatorInset = UIEdgeInsetsZero;
        mainTableView.backgroundColor = WJColorViewBg;
        
        mainTableView.tableFooterView = [[UIView alloc]init];
        
        if(!IOS8_LATER)
        {
            [mainTableView setSeparatorColor:[UIColor clearColor]];
        }
        
    }
    return mainTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
