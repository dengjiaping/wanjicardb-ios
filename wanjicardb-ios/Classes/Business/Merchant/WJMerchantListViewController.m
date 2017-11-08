//
//  WJMerchantListViewController.m
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/20.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJMerchantListViewController.h"
#import "QuickMarkViewController.h"
#import "WJEnterLocationController.h"

@interface WJMerchantListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView        * mainTableView;
}

@end

@implementation WJMerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺信息";
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:@"ChangeShopAddress" object:nil];
}

- (void)reloadTableData
{
    [self.tableView reloadData];
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
    if (indexPath.row == 6) {
//        return [self heightForString:@"欢迎来到F工作室这里是大学生成长成才的加油站。欢迎来到F工作室这里是大学生成长成才的加油站。欢迎来到F工作室，这里是大学生成长，成才的加油站。"] + 30;
        return [self heightForString:[CBPassport detail]] + 30;
    }else{
        return ALD(45);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    return headView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = WJColorDardGray3;
    cell.textLabel.font = WJFont16;
    
    UILabel *subLabel = [[UILabel alloc]initForAutoLayout];
    subLabel.textColor = WJColorDardGray9;
    subLabel.font = WJFont14;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"商户名";
        subLabel.text = [CBPassport shopName];
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:30]];
        [cell.contentView addConstraint:[subLabel constraintCenterYEqualToView:cell.contentView]];
    }if (indexPath.row == 1) {
        cell.textLabel.text = @"联系人";
        subLabel.text = [CBPassport contacter];
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:30]];
        [cell.contentView addConstraint:[subLabel constraintCenterYEqualToView:cell.contentView]];
    }if (indexPath.row == 2) {
        cell.textLabel.text = @"店铺二维码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *imageView = [[UIImageView alloc]initForAutoLayout];
        imageView.image = [UIImage imageNamed:@"Store information_QR code"];
        [cell.contentView addSubview:imageView];
        [cell.contentView addConstraints:[imageView constraintsSize:CGSizeMake(ALD(15), ALD(15))]];
        [cell.contentView addConstraints:[imageView constraintsRightInContainer:0]];
        [cell.contentView addConstraint:[imageView constraintCenterYEqualToView:cell.contentView]];
    }if (indexPath.row == 3) {
        cell.textLabel.text = @"座机";
        subLabel.text = [CBPassport phone];
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:30]];
        [cell.contentView addConstraint:[subLabel constraintCenterYEqualToView:cell.contentView]];
    }if (indexPath.row == 4) {
        cell.textLabel.text = @"地址";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        subLabel.text = [CBPassport shopAddress];
        CGSize sourceSize = [subLabel.text sizeWithFont:WJFont14];
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsSize:CGSizeMake((sourceSize.width +1 < kScreenWidth - 130)? sourceSize.width +1:kScreenWidth - 130, ALD(20))]];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:0]];
        [cell.contentView addConstraint:[subLabel constraintCenterYEqualToView:cell.contentView]];
    }if (indexPath.row == 5) {
        cell.textLabel.text = @"营业时间";
        subLabel.text = [CBPassport businessTime];
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:30]];
        [cell.contentView addConstraint:[subLabel constraintCenterYEqualToView:cell.contentView]];
    }if (indexPath.row == 6) {
        UILabel *textLabel = [[UILabel alloc]initForAutoLayout];
        textLabel.textColor = WJColorDardGray3;
        textLabel.font = WJFont16;
        textLabel.text = @"商户介绍";
        [cell.contentView addSubview:textLabel];
        [cell.contentView addConstraints:[textLabel constraintsLeftInContainer:15]];
        [cell.contentView addConstraints:[textLabel constraintsTopInContainer:10]];
//        subLabel.text = @"欢迎来到F工作室这里是大学生成长成才的加油站。欢迎来到F工作室这里是大学生成长成才的加油站。欢迎来到F工作室，这里是大学生成长，成才的加油站。";
        
        UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(ALD(120), 0, kScreenWidth - ALD(120), [self heightForString:[CBPassport detail]])];
        [webView loadHTMLString:[CBPassport detail] baseURL:[NSURL URLWithString:@"baidu.com"]];
        webView.userInteractionEnabled = NO;
        [cell.contentView  addSubview:webView];
//        subLabel.text = [CBPassport detail];
        subLabel.numberOfLines = 0;
        [cell.contentView addSubview:subLabel];
        [cell.contentView addConstraints:[subLabel constraintsLeftInContainer:100]];
        [cell.contentView addConstraints:[subLabel constraintsRightInContainer:20]];
        [cell.contentView addConstraints:[subLabel constraintsTopInContainer:10]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        QuickMarkViewController *quickMarkVC = [[QuickMarkViewController alloc]init];
        [self.navigationController pushViewController:quickMarkVC animated:YES];
    }if (indexPath.row == 4) {
        WJEnterLocationController * enterLocationVC = [[WJEnterLocationController alloc]init];
//        enterLocationVC.tabBarController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:enterLocationVC animated:YES];
    }
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
        if(!IOS8_LATER)
        {
            [mainTableView setSeparatorColor:[UIColor clearColor]];
        }
        mainTableView.tableFooterView = [[UIView alloc]init];
    }
    return mainTableView;
}

- (CGFloat)heightForString:(NSString *)str
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGRect bound = [str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return bound.size.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
