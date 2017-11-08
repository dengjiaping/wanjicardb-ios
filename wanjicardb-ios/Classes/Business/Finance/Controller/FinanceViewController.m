//
//  FinanceViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "FinanceViewController.h"
#import "Configure.h"
#import "FinanceTableViewCell.h"
#import "FinanceHeaderView.h"
#import "CBMoneyClient.h"
#import "WithdrawViewController.h"
#import "DZNSegmentedControl.h"
#import "CBShopInfoClient.h"
#import "WJRefreshTableView.h"

@interface FinanceViewController ()<UITableViewDataSource, UITableViewDelegate,DZNSegmentedControlDelegate>

@property (nonatomic, strong) FinanceHeaderView     *headerView;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) WJRefreshTableView    *tableView;

@property (nonatomic, assign) int                   page;
@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;

@property (nonatomic, assign) NSInteger             currentSelect;

@property (nonatomic, strong) DZNSegmentedControl   *control;
@property (nonatomic, assign) FinanceType           currentType;

@end

@implementation FinanceViewController

#pragma mark - Property
- (FinanceHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[FinanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(150))];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 64) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        [_tableView showFooter];
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:@[@"全部",@"收入",@"提现"]];
//        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        self.currentType = AllFinanceType;
        //        _control.bouncySelectionIndicator = NO;
        
        //        _control.showsGroupingSeparators = NO;
        //        _control.inverseTitles = YES;
        //        _control.backgroundColor = [UIColor lightGrayColor];
        //        _control.tintColor = [UIColor purpleColor];
        _control.hairlineColor = [UIColor clearColor];
        _control.showsCount = NO;
        _control.autoAdjustSelectionIndicatorWidth = YES;
        _control.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"f8f8f8"];
        //        _control.selectionIndicatorHeight = _control.intrinsicContentSize.height;
        //        _control.adjustsFontSizeToFitWidth = YES;
        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self laodUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshSegmentControl];
    self.page = 0;
    [self.dataArray removeAllObjects]; 
//    [self financeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Controller Flow
#pragma mark - Action
- (void)moreShopInfoReqeust
{
    FinanceViewController * weakSelf = self;
    [[CBShopInfoClient shareRESTClient] moreShopInfoResult:^(BOOL success, WJMoreShopInfoModel *dic, NSString *message) {
        if (success) {
            //            if (!self.headerView) {
            //                double delayInSeconds = 2.0;
            //                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            //                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            //                    [CBPassport storageShopBalance:[NSString stringWithFormat:@"%@",dic[@"Balance"]]];
            //                });
            //            }else
            //            {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    [CBPassport storageShopBalance:[NSString stringWithFormat:@"%@",dic[@"Balance"]]];
                [CBPassport storageMoreShopInfo:dic];
            });
        }else
        {
            
        }
    }];
}


- (void)withdrawButtonAction
{
    WithdrawViewController * withdrawVC = [[WithdrawViewController alloc] init];
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

- (void)laodUI
{
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"财务管理";
    [self leftNavigationItem];
}

- (void)refreshSegmentControl
{
    //    - (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
    [[DZNSegmentedControl appearance] setTitle:@"全部" forSegmentAtIndex:0];
    [[DZNSegmentedControl appearance] setTitle:@"收入" forSegmentAtIndex:1];


}

- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageNamed:@"back_write"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backView
{
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)financeRequest
{
    __weak FinanceViewController * weakSelf = self;

    [[CBMoneyClient shareRESTClient] financeWithPage:++self.page  type:self.currentType finished:^(BOOL success, NSDictionary *dic, NSString *message) {
        NSLog(@"dic = %@",dic);
        if (success) {
            
            if (self.page!=0 && self.page == self.totalPage) {
                //最大页
            }
            weakSelf.totalPage = [dic[@"totalPage"] intValue];
            weakSelf.totalSize = [dic[@"totalSize"] intValue];
            weakSelf.page = [dic[@"index"] intValue];
            //        [weakSelf.listArray addObjectsFromArray:data[@"result"]];
            
            [weakSelf.dataArray addObjectsFromArray:dic[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([weakSelf.dataArray count] > 0) {
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView endFootFefresh];
                    [weakSelf.tableView endHeadRefresh];
                }else
                {
                    NSString * tipStr = @"";
                    switch (self.control.selectedSegmentIndex) {
                        case 0:
                        {
                            tipStr = @"暂无财务收支记录";
                        }
                            break;
                        case 1:
                        {
                            tipStr = @"暂无收入记录";
                        }
                            break;
                        case 2:
                        {
                            tipStr = @"暂无提现记录";
                        }
                        default:
                            break;
                    }
                    
                    [[TKAlertCenter defaultCenter]postAlertWithMessage:tipStr];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView endFootFefresh];
                    [weakSelf.tableView endHeadRefresh];
                }
            });
        }
        else
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
            [weakSelf.tableView endFootFefresh];
            [weakSelf.tableView endHeadRefresh];
            [weakSelf.tableView reloadData];
            --weakSelf.page;
        }
    }];
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    //    [self.tableView reloadData];
    self.page = 0;
    if (control.selectedSegmentIndex == self.currentSelect) {
        return;
    }
    //    [self.control setTintColor:[UIColor blueColor] forSegmentAtIndex:self.currentSelect];
    self.currentSelect = control.selectedSegmentIndex;
    //    [self.control setTintColor:[UIColor redColor] forSegmentAtIndex:self.currentSelect];
    
    [self.dataArray removeAllObjects];
    NSLog(@"%ld",(long)control.selectedSegmentIndex);
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            self.currentType = AllFinanceType;//0
        }
            break;
        case 1:
        {
            self.currentType = IncomeType;//10结算
        }
            break;
        case 2:
        {
            self.currentType = WithdrawType;//20 提现
        }
            break;
        default:
            break;
    }
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self financeRequest];
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
    NSLog(@"\n%lu\n%@",(unsigned long)[self.dataArray count],self.dataArray);
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(60);
}

- (FinanceTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"FinanceID";
    FinanceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[FinanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //        cell.backgroundColor = [UIHelper randomColor];
    }
    

    if([self.dataArray count] > indexPath.row)
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.dic = dic;
    }
    
    return cell;
}

- (UIColor *)colorWithType:(int)type
{
    UIColor * color = nil;
    switch (type) {
        case 10:
        {
            color = [UIHelper colorWithHexColorString:@"01a621"];
        }
            break;
         case 20:
        {
            color = [UIHelper colorWithHexColorString:@"db434b"];
        }
            break;
        default:
            break;
    }
    return color;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
//    
//    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    backView.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
//    
//    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.4, 30)];
//    moneyLabel.textAlignment = NSTextAlignmentCenter;
//    moneyLabel.text = @"收支金额";
//    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.4, 0, kScreenWidth * 0.6, 30)];
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    timeLabel.text = @"日期";
//    
//    //    [sectionHeaderView addSubview:tipView];
//    //    [sectionHeaderView addSubview:sectionLabel];
//    [sectionHeaderView addSubview:backView];
//    [backView addSubview:moneyLabel];
//    [backView addSubview:timeLabel];
//    
//    return sectionHeaderView;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(30))];
        [headerView addSubview:self.control];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)startHeadRefreshToDo:(UITableView *)tableView
{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self financeRequest];
    
}
- (void)startFootRefreshToDo:(UITableView *)tableView
{
    [self financeRequest];
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
