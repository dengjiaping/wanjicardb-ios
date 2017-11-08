 //
//  WithdrawViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/3.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawHeaderView.h"
#import "WithdrawTableViewCell.h"
#import "Configure.h"
#import "CBMoneyClient.h"

@interface WithdrawViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) WithdrawHeaderView    * headerView;
@property (nonatomic, strong) UITableView           * tableView;
@property (nonatomic, strong) NSMutableArray        * dataArray;

@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;
@property (nonatomic, assign) int                   page;

@end

@implementation WithdrawViewController

#pragma mark - Property

- (WithdrawHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WithdrawHeaderView alloc] init];
        _headerView.withdrawTF.delegate = self;
        _headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[[CBPassport balance] floatValue]];
        [_headerView.withdrawButton addTarget:self action:@selector(withdraw) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    [self loadUI];
    [self selectWithdrawWithPage:1];
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
    self.navigationItem.title = @"提现";
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

- (void)withdraw
{
    [self.headerView.withdrawTF resignFirstResponder];
    self.page = 0;
    if([self.headerView.withdrawTF.text length] > 0){
        NSLog(@"当前余额：%f",[[CBPassport balance] floatValue]);
        
        if ([self.headerView.withdrawTF.text floatValue]>0) {
            if ([self.headerView.withdrawTF.text floatValue] <= [[CBPassport balance] floatValue]) {
                __weak WithdrawViewController * weakSelf = self;
                [[CBMoneyClient shareRESTClient] withdrawWithMoney:self.headerView.withdrawTF.text finished:^(BOOL success, NSString *message) {
                    if (success) {
                        NSLog(@"成功");
                        [weakSelf showHUDWithText:@"申请成功"];
                        weakSelf.headerView.withdrawTF.text = nil;
                        [weakSelf selectWithdrawWithPage:0];
                    }else
                    {
                        [weakSelf showHUDWithText:message];
                        
                    }
                }];
                
            }else{
                [self showHUDWithText:@"提现金额不能超过当前账户余额"];
            }
        }else{
            
            [self showHUDWithText:@"您输入的金额不正确"];
        }
      
    }else{
        [self showHUDWithText:@"请输入金额"];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"."]) {
       
        NSRange inputRange = [textField.text rangeOfString:@"."];
        
        //如果length大于0,即存在指定字符串，不可以输入
        if (inputRange.length > 0) {
            
            return NO;
            
        } else {
            
            //如果没有“.”, 输入的第一个是“.”的话，将“.”替换成“0.”
            if (range.location == 0) {
                textField.text = @"0.";
                return NO;
            }else{
                
                return YES;
            }
         
        }

    }else{
        if ([string isEqualToString:@"0"]) {
            //如果是0开头，则不可以接着输入0
            if([textField.text hasPrefix:@"0"]){
                
                if (range.location == 1) {
                  return NO;
                    
                }else{
                    return YES;
                }
                
            }else{
                
                return YES;
            }
            
        }else{
            if ([textField.text hasPrefix:@"0"]) {
                if (range.location == 1) {
                    
                    textField.text = string;
                    return NO;
                    
                }else{
                    return YES;
                }
                
            }else{
                return YES;
            }
           
        }
    }
}


- (void)selectWithdrawWithPage:(int)page
{
    
    __weak WithdrawViewController * weakSelf = self;
    
    if (self.page!=0 && self.page == self.totalPage) {
        //最大页
        [weakSelf showHUDWithText:@"已是全部数据"];

    }
    
//    if (self.page == 0) {
//        [self.dataArray removeAllObjects];
//    }
    
    
    [[CBMoneyClient shareRESTClient] selectWithdrawWithPage:++self.page finished:^(BOOL success, NSDictionary * data, NSString *message) {
        NSLog(@"%@",data);
        
        weakSelf.totalPage = [data[@"totalPage"] intValue];
        weakSelf.totalSize = [data[@"totalSize"] intValue];
        weakSelf.page = [data[@"index"] intValue];
//        [weakSelf.listArray addObjectsFromArray:data[@"result"]];
        if(data[@"result"])
        {
            if (weakSelf.page == 1) {
                [weakSelf.dataArray  removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:data[@"result"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

- (NSString *)stringWithState:(int)status
{
    NSString * str = @"";
    switch (status) {
        case 15:
        {
            str = @"转账中";
        }
            break;
        case 30:
        {
            str = @"提现成功";
        }
            break;
        case 50:
        {
            str = @"提现失败";
        }
            break;
        default:
            break;
    }
    return str;
}

- (UIColor *)statusWithColor:(int)status
{
    UIColor * color = nil;
    switch (status) {
        case 15:
        {
            color = [UIHelper colorWithHexColorString:@"dc444c"];
        }
            break;
        case 30:
        {
            color = [UIHelper colorWithHexColorString:@"01911d"];
        }
            break;
        case 50:
        {
            color = [UIHelper colorWithHexColorString:@"999999"];
        }
            break;
        default:
            break;
    }
    return color;
}


#pragma mark - Delegate
#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [_listArray count];
    NSLog(@"%lu",(unsigned long)[self.dataArray count]);
    NSLog(@"%d",self.totalSize);
    return [self.dataArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"withdrawID";
    WithdrawTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell) {
        cell = [[WithdrawTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        cell.backgroundColor = [UIHelper randomColor];
    }
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    int status = [dic[@"Status"] intValue];
    
    double amount = [dic[@"Amount"] doubleValue];
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",amount];
    cell.timeLabel.text = dic[@"Applydate"];
    cell.statusLabel.text = [self stringWithState:status];
    
    cell.moneyLabel.textColor = [self statusWithColor:status];
    cell.statusLabel.textColor = [self statusWithColor:status];
    
    if (indexPath.row == [self.dataArray count] - 5) {
        [self selectWithdrawWithPage:self.page];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake( 13, 10, 4, 20)];
    tipView.backgroundColor = [UIColor redColor];
    UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 40)];
    sectionLabel.textAlignment = NSTextAlignmentLeft;
    sectionLabel.text = @"提现记录";
    sectionLabel.font = [UIFont systemFontOfSize:16];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 30)];
    backView.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
    
    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.3, 30)];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = @"提现金额";
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.3, 0, kScreenWidth * 0.4, 30)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"提现时间";
    UILabel * statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.7, 0, kScreenWidth * 0.3, 30)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"状态";
    
    [sectionHeaderView addSubview:tipView];
    [sectionHeaderView addSubview:sectionLabel];
    [sectionHeaderView addSubview:backView];
    [backView addSubview:moneyLabel];
    [backView addSubview:timeLabel];
    [backView addSubview:statusLabel];
    
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
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
