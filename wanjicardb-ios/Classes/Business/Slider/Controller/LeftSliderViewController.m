//
//  LeftSliderViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/20.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "LeftSliderViewController.h"
#import "UIHelper.h"
#import "SlidingTableViewCell.h"
#import "Configure.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"

#define kHeaderTitleTop     36.0
#define kHeaderTitleLeft    20.0
#define kHeaderTitleHeight  15.0



@interface LeftSliderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel * phoneLabel;
}

@property (nonatomic, strong) UIView        * headerView;
@property (nonatomic, strong) UIButton      * exitButton;

@property (nonatomic, strong) NSArray       * notifycationArray;
@property (nonatomic, strong) UILabel       * currentVersionLabel;

@end

@implementation LeftSliderViewController
#pragma mark - Property
- (NSArray *)listArray
{
    if (!_listArray) {
        _listArray = @[@{@"icon":@"accountManage",  @"text":@"账号管理"},
                       @{@"icon":@"pictures",       @"text":@"相册"},
                       @{@"icon":@"shopInfo",       @"text":@"店铺信息"},
//                       @{@"icon":@"versionupdata",  @"text":@"版本更新"},
                       @{@"icon":@"sugest",         @"text":@"意见反馈"},
                       ];
    }
    return _listArray;
}

- (NSArray *)notifycationArray
{
    if (!_notifycationArray)
    {
        _notifycationArray = @[@"AccountManageViewController",@"ShopPictureViewController",@"ShopInfoViewController",/*@"VersionUpdataViewController",*/@"SugestViewController"];
    }
    return _notifycationArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self headerView];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIHelper colorWithHexColorString:@"f3f6f6"];
        [_tableView addSubview:self.currentVersionLabel];
        [_tableView addSubview:self.exitButton];
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 90)];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHeaderTitleLeft, kHeaderTitleTop, self.view.width - kHeaderTitleLeft, 15)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = @"当前登录账号";
        
        phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHeaderTitleLeft, kHeaderTitleTop + kHeaderTitleHeight+6, titleLabel.width, 22)];
        phoneLabel.textColor = [UIColor blackColor];
        phoneLabel.font = [UIFont systemFontOfSize:18];
        if([CBPassport  userName] && [CBPassport userName].length > 0)
        {
            phoneLabel.text = [CBPassport userName];
        }
        
        [_headerView addSubview:titleLabel];
        [_headerView addSubview:phoneLabel];
        _headerView.backgroundColor = [UIHelper colorWithHexColorString:@"f3f6f6"];
    }
    return _headerView;
}

- (UIButton *)exitButton
{
    if (!_exitButton)
    {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitButton setFrame:CGRectMake(0, self.tableView.height - 40, kLeftSliderWidth, 30)];
        [_exitButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitAcction) forControlEvents:UIControlEventTouchUpInside];
        [_exitButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _exitButton;
}

- (UILabel *)currentVersionLabel
{
    if (!_currentVersionLabel) {
        _currentVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.tableView.height - 80, kLeftSliderWidth - 20, 40)];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用名称
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前应用软件版本:%@",appCurVersion);
        _currentVersionLabel.text = [NSString stringWithFormat:@"版本号：v%@",appCurVersion];
        
        _currentVersionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentVersionLabel;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIHelper randomColor];
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (phoneLabel) {
        phoneLabel.text = [CBPassport userName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Controller Flow
#pragma mark - Action

- (void)loadUI
{
    [self.view addSubview:self.tableView];
}

- (void)exitAcction
{
    NSLog(@"%s",__func__);
    [CBPassport logout];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController hideSideViewController:YES];
    [kDefaultCenter postNotificationName:kMainLogoutAction object:nil];
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
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifyStr = @"cellID";
    SlidingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (!cell) {
        cell = [[SlidingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dic = [self.listArray  objectAtIndex:indexPath.row];
    
    cell.iconImageView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.nameLabel.text = dic[@"text"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController hideSideViewController:YES];
    
    [kDefaultCenter postNotification:[[NSNotification alloc] initWithName:kLeftSliderAction object:self userInfo:@{@"class":[self.notifycationArray objectAtIndex:indexPath.row]}]];
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
