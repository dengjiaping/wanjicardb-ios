//
//  AccountManageViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/21.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "AccountManageViewController.h"
#import "Configure.h"
#import "AccountTableViewCell.h"
#import "FindPasswordViewController.h"

#define kTableViewHeight    50

@interface AccountManageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSArray * listArray;

@end

@implementation AccountManageViewController


#pragma mark - Property

-(NSArray *)listArray
{
    if (!_listArray) {
        _listArray = @[@{@"title":@"账号",@"des":[CBPassport userName]},
                       @{@"title":@"密码",@"des":@"******"}];
    }
    return _listArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth,kTableViewHeight * [self.listArray count]) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
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

- (void)loadUI
{
    [self navigationAction];
    [self leftNavigationItem];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
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

- (void)navigationAction
{
    self.navigationItem.title = @"账号管理";
}

#pragma mark - Delegate
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifyStr = @"accountCellID";
    AccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (!cell) {
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr];
    }
    NSDictionary * dic = [self.listArray  objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = dic[@"title"];
    cell.textDesLabel.text = dic[@"des"];
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 1) {
        FindPasswordViewController * vc = [[FindPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
