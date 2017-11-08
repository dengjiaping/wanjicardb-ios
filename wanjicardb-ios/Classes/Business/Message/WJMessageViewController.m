//
//  WJMessageViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 15/12/24.
//  Copyright © 2015年 XT Xiong. All rights reserved.
//

#import "WJMessageViewController.h"
#import "WJSystemMessageController.h"

@interface WJMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView        * mainTableView;
}

@end

@implementation WJMessageViewController

#pragma mark- Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态";
    [self.view addSubview:self.tableView];
    [self hiddenBackBarButtonItem];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(70);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UIImageView *imageView = [[ UIImageView alloc]initForAutoLayout];
    [cell.contentView addSubview:imageView];
    [cell.contentView addConstraints:[imageView constraintsSize:CGSizeMake(ALD(44), ALD(44))]];
    [cell.contentView addConstraints:[imageView constraintsLeftInContainer:ALD(10)]];
    [cell.contentView addConstraint:[imageView constraintCenterYEqualToView:cell.contentView]];

    UILabel *titleLabel = [[UILabel alloc]initForAutoLayout];
    titleLabel.font = WJFont16;
    [cell.contentView addSubview: titleLabel];
    [cell.contentView addConstraints:[titleLabel constraintsLeftInContainer:ALD(60)]];
    [cell.contentView addConstraints:[titleLabel constraintsTopInContainer:ALD(15)]];
    
    UILabel *subTitleLabel = [[UILabel alloc]initForAutoLayout];
    subTitleLabel.textColor = WJColorDardGray9;
    subTitleLabel.font = WJFont12;
    [cell.contentView addSubview: subTitleLabel];
    [cell.contentView addConstraints:[subTitleLabel constraintsLeftInContainer:ALD(60)]];
    [cell.contentView addConstraints:[subTitleLabel constraintsTopInContainer:ALD(40)]];
//    cell.contentView.backgroundColor = [WJUtilityMethod randomColor];

//    if (indexPath.row == 0) {
//        imageView.image = [UIImage imageNamed:@"dynamic_Order"];
//        titleLabel.text = @"订单信息";
//        subTitleLabel.text = @"查看商户的售卡和收款消费的信息";
//    }if (indexPath.row == 1) {
//        imageView.image = [UIImage imageNamed:@"dynamic_Finance"];
//        titleLabel.text = @"财务信息";
//        subTitleLabel.text = @"查看商户账户结算，取现的动态";
//    }if (indexPath.row == 2) {
        imageView.image = [UIImage imageNamed:@"dynamic_system"];
        titleLabel.text = @"系统消息";
        subTitleLabel.text = @"查看商户的站内信，系统动态信息";
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        
//    }if (indexPath.row == 1) {
//        
//    }if (indexPath.row == 2) {
        WJSystemMessageController *SMVC = [[WJSystemMessageController alloc]init];
        [SMVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:SMVC animated:YES];
//    }
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
        mainTableView.tableFooterView = [[UIView alloc]init];
    }
    return mainTableView;
}


@end
