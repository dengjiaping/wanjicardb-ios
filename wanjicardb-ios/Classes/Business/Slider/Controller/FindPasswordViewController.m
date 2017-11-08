//
//  FindPasswordViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "Configure.h"
#import "FindPasswordTableViewCell.h"

#define kTableViewHeight    50
#define kButtonLeft         12

@interface FindPasswordViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UIButton * nextStepButton;
@end

@implementation FindPasswordViewController

#pragma mark - Property

- (NSArray *)listArray
{
    if (!_listArray) {
        _listArray = @[@{@"title":@"手机号:",@"des":[CBPassport userName]},
                       @{@"title":@"验证码:",@"des":@"请输入验证码"}
                       ];
    }
    return _listArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth,kTableViewHeight * 2) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UIButton *)nextStepButton
{
    if (!_nextStepButton) {
        _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepButton setFrame:CGRectMake(kButtonLeft, self.tableView.top + self.tableView.height + 28, kScreenWidth - 2 * kButtonLeft, 44)];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setBackgroundColor:[UIColor grayColor]];
        [_nextStepButton addTarget:self action:@selector(nextButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
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

- (void)nextButton
{
    NSLog(@"%s",__func__);
}

- (void)loadUI
{
    [self navigationAction];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
    
    [self.view addSubview:self.nextStepButton];
    
}

- (void)navigationAction
{
    self.navigationItem.title = @"找回密码";
}

#pragma mark - Delegate
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifyStr = @"accountCellID";
    FindPasswordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (!cell) {
        cell = [[FindPasswordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dic = [self.listArray  objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = dic[@"title"];
    cell.textDesTF.placeholder = dic[@"des"];
    cell.textDesTF.enabled = indexPath.row != 0;
    if(indexPath.row == 0)
    {
        cell.textDesTF.text = [CBPassport userName];
    }
    cell.textDesTF.delegate = self;
    cell.isSecureityCode = (1 == indexPath.row);
    if(cell.isSecureityCode)
    {
        [cell.securityCodeButton addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)getCode
{
    
}

#pragma mark - textfield


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
