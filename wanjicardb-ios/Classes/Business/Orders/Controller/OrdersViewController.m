//
//  OrdersViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "OrdersViewController.h"
#import "DZNSegmentedControl.h"
#import "OrdersTableViewCell.h"
#import "Configure.h"
#import "CBMoneyClient.h"
#import "WJOrdersSearchViewController.h"
#import "WJRefreshTableView.h"

@interface OrdersViewController ()<DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl   *control;
@property (nonatomic, strong) NSArray               *menuItems;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) WJRefreshTableView    *tableView;

@property (nonatomic, assign) OrdersType            currentOrderType;
@property (nonatomic, assign) int                   page;
@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;

@property (nonatomic, assign) NSInteger             currentSelect;
@end

@implementation OrdersViewController


#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentOrderType = AllOrders;
    self.currentSelect = 0;
    [self setupUI];
    
//    [self ordersRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self navigationBarIsWhite:YES];
    [self refreshSegmentControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Controller Flow
#pragma mark - Action

- (void)refreshSegmentControl
{
    //    - (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
    [[DZNSegmentedControl appearance] setTitle:@"全部" forSegmentAtIndex:0];
    [[DZNSegmentedControl appearance] setTitle:@"完成" forSegmentAtIndex:1];
}

- (void)setupUI
{
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
    [[DZNSegmentedControl appearance] setTintColor:WJMainColor];
    [[DZNSegmentedControl appearance] setHairlineColor:WJMainColor];
    [[DZNSegmentedControl appearance] setFont:[UIFont systemFontOfSize:14.0]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
    [self.view addSubview:self.tableView];
    
    [self leftNavigationItem];
    [self rightNavigationItem];
    self.navigationItem.title = @"订单管理";
//    self.view.backgroundColor = [WJUtilityMethod randomColor];
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

- (void)rightNavigationItem
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, ALD(22), ALD(22))];
    //    rightButton.backgroundColor = [WJUtilityMethod randomColor];
    [rightButton setImage:[UIImage imageNamed:@"order_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchOrderAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)searchOrderAction
{
    WJOrdersSearchViewController * searchVC = [[WJOrdersSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)backView
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
//    [self.tableView reloadData];
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
            self.currentOrderType = AllOrders;//0
        }
            break;
        case 1:
        {
            self.currentOrderType = PayedOrders;//30
        }
            break;
       
        case 2:
        {
            self.currentOrderType = WaitPayOrders;//10
        }
            break;
        case 3:
        {
            self.currentOrderType = CloseOrders;//50
            break;
        }
        default:
            break;
    }
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self ordersRequest];
}

- (void)ordersRequest
{
//    __weak typeof(self) weakSelf = self;
    __weak OrdersViewController * weakSelf = self;
    self.tableView.userInteractionEnabled = NO;
    [[CBMoneyClient shareRESTClient] ordersListWithType:self.currentOrderType page:++self.page searchKey:@"" finished:^(BOOL success, NSDictionary *dic, NSString *message)
    {
        weakSelf.tableView.userInteractionEnabled = YES;
        if (success) {
            weakSelf.totalPage = [dic[@"totalPage"] intValue];
            weakSelf.totalSize = [dic[@"totalSize"] intValue];
            weakSelf.page = [dic[@"index"] intValue];
//            [weakSelf.listArray addObjectsFromArray:data[@"result"]];
            [weakSelf.dataArray addObjectsFromArray:dic[@"result"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView endFootFefresh];
                [weakSelf.tableView endHeadRefresh];
                
            });
            if ([weakSelf.dataArray count] == 0) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"暂无购卡订单"];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView endFootFefresh];
                [weakSelf.tableView endHeadRefresh];
            }
        }else
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
            --weakSelf.page;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView endFootFefresh];
            [weakSelf.tableView endHeadRefresh];
        }
    }];
}

#pragma mark - Delegate
#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

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
    return ALD(165) + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"OrderCellID";
    OrdersTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = WJColorViewBg;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if([self.dataArray count] > indexPath.row)
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.dic = dic;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

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

- (void)startHeadRefreshToDo:(UITableView *)tableView
{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self ordersRequest];
    
}
- (void)startFootRefreshToDo:(UITableView *)tableView
{
    [self ordersRequest];
}

#pragma mark - Property
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)menuItems
{
    if (!_menuItems) {
        _menuItems = @[@"全部",@"完成",@"待支付",@"已关闭"];
    }
    return _menuItems;
}

- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
        //        _control.bouncySelectionIndicator = NO;
        //        _control.showsGroupingSeparators = NO;
        //        _control.inverseTitles = YES;
        //        _control.backgroundColor = [UIColor lightGrayColor];
        //        _control.tintColor = [UIColor purpleColor];
        //        _control.hairlineColor = [UIColor purpleColor];
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

- (WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - ALD(64)) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.control;
        _tableView.automaticallyRefresh = YES;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView showFooter]; 
//        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = WJColorViewBg;
    }
    return _tableView;
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
