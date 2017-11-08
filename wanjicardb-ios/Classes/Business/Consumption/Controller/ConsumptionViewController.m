//
//  ConsumptionViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ConsumptionViewController.h"
#import "DZNSegmentedControl.h"
#import "CBMoneyClient.h"
#import "CBShopInfoClient.h"
#import "ConsumptionTableViewCell.h"
#import "WJRefreshTableView.h"
#import "CBShopInfoClient.h"
#import "WJSearchTapCell.h"
#import "WJSearchTableViewCell.h"
#import "WJTimeOperationModel.h"
#import "WJChangeTimeViewController.h"

#import "WJConsumptionSearchViewController.h"

#define kChooceTapHeight        44

@interface ConsumptionViewController ()<DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate,SearchCellDelegate,ConsumptionWithdrawDelegate,ConsumptionDelegate,UIAlertViewDelegate>
{
    NSUInteger currentIndex;
}
//@property (nonatomic, strong) DZNSegmentedControl   *control;
//@property (nonatomic, strong) NSArray               *menuItems;
@property (nonatomic, strong) NSArray               *tabArray;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) WJRefreshTableView    *mainTableView;
@property (nonatomic, strong) WJRefreshTableView    *searchTableView;

@property (nonatomic, assign) OrdersType            currentOrderType;
@property (nonatomic, assign) int                   page;
@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;

@property (nonatomic, assign) int                   branchPage;
@property (nonatomic, assign) int                   branchTotalPage;

@property (nonatomic, strong) UIView                *tabView;

@property (nonatomic, strong) NSMutableArray        *branchArray;
@property (nonatomic, strong) NSArray               *timeArray;
@property (nonatomic, strong) NSArray               *statusArray;

@property (nonatomic, strong) NSArray               *searchArray;
@property (nonatomic, assign) int                   currentSearchIndex;

@property (nonatomic, assign) int                   branchIndex;
@property (nonatomic, assign) int                   timeIndex;
@property (nonatomic, assign) int                   statusIndex;

@property (nonatomic, assign) ConsumptionType       statusType;
@property (nonatomic, assign) ConsumptionTimeType   timeType;
@property (nonatomic, strong) NSString              *branchID;
//@property (nonatomic, assign) NSInteger             currentSelect;
//@property (nonatomic, strong) UIView                *headerView;
//@property (nonatomic, strong) UILabel               *titleLabel;
@end

@implementation ConsumptionViewController

//- (NSArray *)menuItems
//{
//    if (!_menuItems) {
//        _menuItems = @[@"已支付",@"已退款",@"日期"];
//    }
//    return _menuItems;
//}
//
//- (DZNSegmentedControl *)control
//{
//    if (!_control)
//    {
//        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
//        [_control setFrame:CGRectMake(0, 50, kScreenWidth, 40)];
//        _control.delegate = self;
//        _control.inverseTitles = YES;
//        //        _control.selectedSegmentIndex = 1;
//        _control.bouncySelectionIndicator = NO;
//        
//        _control.showsGroupingSeparators = YES;
//        _control.tintColor = [UIColor grayColor];
//        _control.showsCount = NO;
//        _control.autoAdjustSelectionIndicatorWidth = YES;
//        //        _control.selectionIndicatorHeight = _control.intrinsicContentSize.height;
//        _control.adjustsFontSizeToFitWidth = NO;
//        
//        [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
//        [[DZNSegmentedControl appearance] setTintColor:[UIHelper colorWithHexColorString:@"ee3643"]];
//        [[DZNSegmentedControl appearance] setHairlineColor:[UIHelper colorWithHexColorString:@"ee3643"]];
//        
//        [[DZNSegmentedControl appearance] setFont:[UIFont fontWithName:@"EuphemiaUCAS" size:20.0]];
//        [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
//        [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
//        
//        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _control;
//}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.branchTotalPage = -1;
    self.totalPage = -1;
//    self.page = 1;
//    self.branchPage = 1;
    [self loadUI];
    
    [self shopBranchesRequest];
    NSLog(@"%@",self.branchArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Controller Flow
#pragma mark - Action

- (void)tapSearchTableViewAction:(UITapGestureRecognizer *)tap
{
    self.searchTableView.hidden = YES;
    [self clearnTabViewColorWithOut:-1];
}

- (void)settingTime
{
    switch (self.timeType) {
        case BeforeThreeDays:
        {
            self.startTime = [WJTimeOperationModel currentTimePassDays:3];
            self.endTime = [WJTimeOperationModel currentTime];
        }
            break;
        case BeforWeeks:
        {
            self.startTime = [WJTimeOperationModel currentTimePassDays:7];
            self.endTime = [WJTimeOperationModel currentTime];
        }
            break;
        case Today:
        {
            self.startTime = [WJTimeOperationModel currentDayStart];
            self.endTime = [WJTimeOperationModel currentTime];
        }
            break;
        case CurrentTime:
        {
            WJChangeTimeViewController * timeVC = [[WJChangeTimeViewController alloc] init];
            timeVC.delegate = self;
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:timeVC animated:YES];
            break;
        }
            break;
        default:
            self.startTime = @"";
            self.endTime = @"";
            break;
    }
    
    NSLog(@"\nstartime = %@\nendtime = %@\n",self.startTime,self.endTime);
    
}

- (void)loadUI
{
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.searchTableView];

    self.navigationItem.title = @"消费管理";
    [self leftNavigationItem];
    [self rightNavigationItem];
}

- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, ALD(22), ALD(22))];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightNavigationItem
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, ALD(22), ALD(22))];
    //    rightButton.backgroundColor = [WJUtilityMethod randomColor];
    [rightButton setImage:[UIImage imageNamed:@"order_search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchConsumptionAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)searchConsumptionAction
{
    NSLog(@"%s",__func__);
    WJConsumptionSearchViewController * searchVC = [[WJConsumptionSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)backAction
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    NSLog(@"%ld",control.selectedSegmentIndex);
    //    [self.tableView reloadData];
    
//    if (control.selectedSegmentIndex == self.currentSelect) {
//        return;
//    }
//    self.currentSelect = control.selectedSegmentIndex;
//    [self.dataArray removeAllObjects];
//    NSLog(@"%ld",(long)control.selectedSegmentIndex);
//    switch (control.selectedSegmentIndex) {
//        case 0:
//        {
//            self.currentOrderType = AllOrders;
//        }
//            break;
//        case 1:
//        {
//            self.currentOrderType = WaitPayOrders;
//        }
//            break;
//        case 2:
//        {
//            self.currentOrderType = PayedOrders;
//        }
//            break;
//        default:
//            break;
//    }
}

- (void)consumptionRequest
{
    __weak ConsumptionViewController * weakSelf = self;
    NSLog(@"\nstartTime = %@\nendTime = %@\nstatuts = %d\npage = %d\n",self.startTime,self.endTime,self.statusType,self.page);
//    NSString * searchKey = ![[CBPassport userName] isEqualToString:@""] ? [CBPassport userName]:[CBPassport phone];
    self.mainTableView.userInteractionEnabled = NO;
    [[CBMoneyClient shareRESTClient] consumptionInfoWithPage:++self.page searchKey:@"" branch:self.branchID startTime:self.startTime endTime:self.endTime status:self.statusType finished:^(BOOL success, NSDictionary *dic, NSString *message) {
        weakSelf.mainTableView.userInteractionEnabled = YES;
        [weakSelf.mainTableView endFootFefresh];
        [weakSelf.mainTableView endHeadRefresh];
         if (self.page!=0 && self.page == self.totalPage) {
             //最大页
         }
         if(success)
         {
             weakSelf.totalPage = [dic[@"totalPage"] intValue];
             weakSelf.totalSize = [dic[@"totalSize"] intValue];
             weakSelf.page = [dic[@"index"] intValue];
//        [weakSelf.listArray addObjectsFromArray:data[@"result"]];
//      weakSelf.titleLabel.text = [NSString stringWithFormat:@"  总计消费 ：%@ 元",(dic[@"totalAmount"] == nil)?@"0":[WJUtilityMethod floatNumberFomatter:[dic[@"totalAmount"] floatValue]]];
             
//             if (weakSelf.page ) {
//                 [weakSelf.dataArray removeAllObjects];
//             }
             [weakSelf.dataArray addObjectsFromArray:dic[@"result"]];
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if ([weakSelf.dataArray count] > 0) {
                     [weakSelf.mainTableView reloadData];
                     [weakSelf.mainTableView endFootFefresh];
                     [weakSelf.mainTableView endHeadRefresh];
                 }else
                 {
                     if(weakSelf.page > 1)
                     {
                     [[TKAlertCenter defaultCenter] postAlertWithMessage:@"暂无消费订单"];
                     [weakSelf.mainTableView reloadData];
                     [weakSelf.mainTableView endFootFefresh];
                     [weakSelf.mainTableView endHeadRefresh];
                     --weakSelf.page;
                     } else if(weakSelf.page == 1)
                     {
                         [weakSelf.dataArray removeAllObjects];
                         [weakSelf.mainTableView reloadData];
                         [weakSelf.mainTableView endFootFefresh];
                         [weakSelf.mainTableView endHeadRefresh];
                         [[TKAlertCenter defaultCenter] postAlertWithMessage:@"没有更多数据了"];
                     }
                 }
             });
             
         }else
         {
             [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
             --weakSelf.page;
             [weakSelf.mainTableView reloadData];
             [weakSelf.mainTableView endFootFefresh];
             [weakSelf.mainTableView endHeadRefresh];
         }
    }];
}

- (void)requestRefundWithPaymentNo:(NSString * )noStr
{
    [[CBShopInfoClient shareRESTClient] shopRefundRequestWithPaymentNo:noStr  finish:^(BOOL success, NSString *message) {
        if (success) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"退款成功"];
            [self startHeadRefreshToDo:self.mainTableView];
        } else
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
        }
    }];
}

- (void)shopBranchesRequest
{
    if (self.branchPage == self.branchTotalPage) {
        NSLog(@"-------");
    }
    __weak ConsumptionViewController * weakSelf = self;
    [[CBShopInfoClient shareRESTClient] shopBranchesRequestWithPage:++self.page finish:^(BOOL success, NSDictionary *dic, NSString *message) {
        if (success) {
            weakSelf.branchPage = [dic[@"index"] intValue];
            weakSelf.branchTotalPage = [dic[@"totalPage"] intValue];
            
            if (weakSelf.branchPage != 1) {
                [weakSelf.branchArray addObjectsFromArray:dic[@"result"]];
            } else {
                NSDictionary * dictionary =     @{@"Address":@"",
                                                  @"BusinessTime":@"",
                                                  @"Category":[NSArray array],
                                                  @"Cover":@"",
                                                  @"DistanceStr":@"",
                                                  @"Id":@"0",
                                                  @"Latitude":@"",
                                                  @"Longitude":@"",
                                                  @"Name":@"全部门店",
                                                  @"Phone":@"",
                                                  @"TotalSale":@""};
                
                if([CBPassport isMain])
                {
                    weakSelf.branchArray = [NSMutableArray arrayWithObject:dictionary];
      
                } else {
                    NSArray * array = dic[@"result"];
                    if ([array count] > 0) {
                        NSDictionary * dic = [array objectAtIndex:0];
                        [weakSelf setTabViewText:dic[@"Name"] Index:0];
                    }
                }
                [weakSelf.branchArray addObjectsFromArray:dic[@"result"]];
            }
            [CBPassport setBranch:weakSelf.branchArray];
        }else {
            if([CBPassport isMain])
            {
                NSDictionary * dictionary =     @{@"Address":@"",
                                                  @"BusinessTime":@"",
                                                  @"Category":[NSArray array],
                                                  @"Cover":@"",
                                                  @"DistanceStr":@"",
                                                  @"Id":@"0",
                                                  @"Latitude":@"",
                                                  @"Longitude":@"",
                                                  @"Name":@"全部门店",
                                                  @"Phone":@"",
                                                  @"TotalSale":@""};
                weakSelf.branchArray = [NSMutableArray arrayWithObject:dictionary];
            }
            [weakSelf.branchArray addObjectsFromArray:[CBPassport branchs]];
        }
        //        [self.searchTableView reloadData];
    }];
}


#pragma mark - Delegate
#pragma mark - SearchCellDelegate
- (void)searchTap:(WJSearchTapCell *)cell  didSelectWithindex:(int)index
{
    if (self.currentSearchIndex == index) {
        self.searchTableView.hidden = YES;
        cell.isSelected = NO;
        self.currentSearchIndex = -1;
        
        return;
    }
    self.currentSearchIndex = index;
    
    [self clearnTabViewColorWithOut:index];
    [self.searchTableView reloadData];
    self.searchTableView.hidden = NO;
    
    NSLog(@"%d",index);
}

#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

#pragma mark - ConsumptionDelegate
- (void)moreTimeConsumptionWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    self.startTime = startTime;
    self.endTime = endTime;
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self consumptionRequest];
}

#pragma mark - WJRefreshAction
- (void)startHeadRefreshToDo:(UITableView *)tableView
{
    NSLog(@"%s",__func__);
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self consumptionRequest];
    
//    if (tableView == self.mainTableView) {
//        
//    }else if(tableView == self.searchTableView){
//    
//    }
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    NSLog(@"%s",__func__);
    [self consumptionRequest];
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 0;
//    NSLog(@"\n%lu\n%@",(unsigned long)[self.dataArray count],self.dataArray);
    
    if(tableView == self.mainTableView)
    {
        return [self.dataArray count];

    }else if(tableView == self.searchTableView){
        return [[self.searchArray objectAtIndex:self.currentSearchIndex] count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mainTableView)
    {
        return ALD(130) + 10;

    }else if(tableView == self.searchTableView){
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(tableView == self.searchTableView)
    {
        static NSString * cellID = @"SearchCellID";
        WJSearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WJSearchTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (self.currentSearchIndex) {
            case 0:
            {
                NSDictionary * dic = [[self.searchArray objectAtIndex:self.currentSearchIndex] objectAtIndex:indexPath.row];
                cell.searchLabel.text = dic[@"Name"];
            }
                break;
                
            default:
                cell.searchLabel.text = [[[self.searchArray objectAtIndex:self.currentSearchIndex] objectAtIndex:indexPath.row] objectForKey:@"text"];
                break;
        }
        
//        if ([[self.tabArray objectAtIndex:self.currentSearchIndex] isEqualToString:cell.searchLabel.text]) {
//            cell.searchLabel.textColor = WJMainColor;
//        }else{
//            cell.searchLabel.textColor = WJColorDardGray9;
//        }
        
        switch (self.currentSearchIndex) {
            case 0:
            {
                if (indexPath.row == self.branchIndex) {
                    cell.searchLabel.textColor = WJMainColor;
                }else{
                    cell.searchLabel.textColor = WJColorDardGray9;
                }
            }
                break;
            case 1:
            {
                if (indexPath.row == self.timeIndex) {
                    cell.searchLabel.textColor = WJMainColor;
                }else{
                    cell.searchLabel.textColor = WJColorDardGray9;
                }
            }
                break;
            case 2:
            {
                if (indexPath.row == self.statusIndex) {
                    cell.searchLabel.textColor = WJMainColor;
                }else{
                    cell.searchLabel.textColor = WJColorDardGray9;
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }else if(tableView == self.mainTableView){
        static NSString * cellID = @"CunsumptionID";
        ConsumptionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[ConsumptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            //        cell.backgroundColor = [UIHelper randomColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if([self.dataArray count] > indexPath.row)
        {
            NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
            cell.tag = 10000 + indexPath.row;
            cell.dic = dic;
            cell.delegate = self;
        }
//        if(indexPath.row == [self.dataArray count] - 5){
//            //        [self consumptionRequest];
//        }
        return cell;
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
////    
////    UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake( 13, 10, 4, 20)];
////    tipView.backgroundColor = [UIColor redColor];
////    UILabel * sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 40)];
////    sectionLabel.textAlignment = NSTextAlignmentLeft;
////    sectionLabel.text = @"提现记录";
////    sectionLabel.font = [UIFont systemFontOfSize:16];
//    
//    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    backView.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
//    
//    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.3, 30)];
//    moneyLabel.textAlignment = NSTextAlignmentCenter;
//    moneyLabel.text = @"手机号";
//    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.3, 0, kScreenWidth * 0.3, 30)];
//    timeLabel.textAlignment = NSTextAlignmentCenter;
//    timeLabel.text = @"消费金额";
//    UILabel * statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth * 0.6, 0, kScreenWidth * 0.4, 30)];
//    statusLabel.textAlignment = NSTextAlignmentCenter;
//    statusLabel.text = @"日期";
//    
////    [sectionHeaderView addSubview:tipView];
////    [sectionHeaderView addSubview:sectionLabel];
//    [sectionHeaderView addSubview:backView];
//    [backView addSubview:moneyLabel];
//    [backView addSubview:timeLabel];
//    [backView addSubview:statusLabel];
//    
//    return sectionHeaderView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == self.searchTableView)
    {
        switch (self.currentSearchIndex) {
            case 0:
            {
                self.branchID = [[self.branchArray objectAtIndex:indexPath.row] objectForKey:@"Id"];
                [self setTabViewText:[[self.branchArray objectAtIndex:indexPath.row] objectForKey:@"Name"] Index:self.currentSearchIndex];
                self.branchIndex = (int)indexPath.row;
                self.page = 0;
                [self.dataArray removeAllObjects];

            }
                break;
            case 1:
            {
                [self setTabViewText:[[self.timeArray objectAtIndex:indexPath.row] objectForKey:@"text"] Index:self.currentSearchIndex];
                self.timeType = (ConsumptionTimeType)[[[self.timeArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue];
                [self.dataArray removeAllObjects];
                self.page = 0;
                self.timeIndex = (int)indexPath.row;

                [self settingTime];

            }
                break;
            case 2:
            {
                [self setTabViewText:[[self.statusArray objectAtIndex:indexPath.row] objectForKey:@"text"] Index:self.currentSearchIndex];
                self.statusType = (ConsumptionType)[[[self.statusArray objectAtIndex:indexPath.row] objectForKey:@"status"] intValue];
                self.statusIndex = (int)indexPath.row;
                self.page = 0;
                [self.dataArray removeAllObjects];

            }
                break;
            default:
                break;
        }
        self.searchTableView.hidden = YES;
//        [self.dataArray removeAllObjects];
        [self consumptionRequest];
        [self clearnTabViewColorWithOut:-1];
    }else if(tableView == self.mainTableView){
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && tableView == self.mainTableView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(30))];
        [headerView addSubview:self.tabView];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && tableView == self.mainTableView)
    {
        return ALD(40);
    }
    return 0;
}


#pragma mark - ConsumptionWithdrawDelegate
- (void)withdrawIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    currentIndex = index;
    if ([self.dataArray count] - 1 < index) {
        return;
    } else {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示 " message:[NSString stringWithFormat:@"您确定要退款吗？"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alertView show];
    }
    
    
}


#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            NSDictionary * dic = [self.dataArray objectAtIndex:currentIndex];
            
            [self requestRefundWithPaymentNo:[dic objectForKey:@"Paymentno"]];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - Property

- (WJRefreshTableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, [[UIScreen mainScreen] bounds].size.height- 64) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _mainTableView.tableHeaderView = self.tabView;
        _mainTableView.backgroundColor = WJColorViewBg;

//        _mainTableView.tableFooterView = [[UIView alloc] init];
        [_mainTableView showFooter];
        self.searchTableView.hidden = YES;
    }
    return _mainTableView;
}

- (WJRefreshTableView *)searchTableView
{
    if (!_searchTableView) {
        _searchTableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, ALD(40), kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 64) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeNone];
        _searchTableView.backgroundColor = [UIColor clearColor];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.scrollEnabled = NO;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //        _mainTableView.tableHeaderView = self.headerView;
        
        UIView * footView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [footView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        
        _searchTableView.tableFooterView = footView;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchTableViewAction:)];
        [footView addGestureRecognizer:tap];
    }
    return _searchTableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)tabView
{
    if (nil == _tabView) {
        _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(kChooceTapHeight))];
        _tabView.backgroundColor = [UIColor whiteColor];
        for(int i = 0; i< 3; i++)
        {
            WJSearchTapCell * cell = [[WJSearchTapCell alloc] initWithFrame:CGRectMake( (kScreenWidth / 3) * i, 0, kScreenWidth / 3, ALD(kChooceTapHeight))];
            cell.tag = 30000 + i;
            [cell setTapText:[self.tabArray objectAtIndex:i]];
            
//            if (i == 0 && ![CBPassport isMain]) {
//                cell.userInteractionEnabled = NO;
//            }
            
            cell.delegate = self;
            [_tabView addSubview:cell];
        }
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(kChooceTapHeight) - 1, kScreenHeight, 1)];
        line.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"e5e5e5"];
        [_tabView addSubview:line];
    }
    return _tabView;
}

- (NSArray *)tabArray
{
    return @[@"全部门店",@"全部时间",@"全部状态"];//所有分店  状态：全部状态，消费成功，已退款，冲正关闭
}

- (void)clearnTabViewColorWithOut:(int)index
{
//    for(int i = 30000; i<[self.tabArray count] + 30000;i++)
//    {
//        WJSearchTapCell * cell = (WJSearchTapCell *)[self.view viewWithTag:i];
//        cell.isSelected = (index + 30000) == i;
//    }
}

- (void)setTabViewText:(NSString *)text Index:(NSInteger)index
{
    NSInteger tag = 30000 + index;
    WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:tag];
    [cell setTapText:text];
    
}

- (void)setTabViewEnable:(BOOL)isEnable Index:(NSInteger)index
{
    NSInteger tag = 30000 + index;
    WJSearchTapCell * cell = (WJSearchTapCell *)[self.tabView viewWithTag:tag];
    cell.userInteractionEnabled = isEnable;
}

//@property (nonatomic, strong) NSArray               *branchArray;
//@property (nonatomic, strong) NSArray               *timeArray;
//@property (nonatomic, strong) NSArray               *statusArray;

- (NSMutableArray *)branchArray
{
    if(!_branchArray)
    {
        _branchArray = [NSMutableArray array];
    }
    return _branchArray;
}

- (NSArray *)timeArray
{
    return @[@{@"text":@"全部时间",@"status":@"0"},
             @{@"text":@"今天",@"status":@"1"},
             @{@"text":@"近三天",@"status":@"2"},
             @{@"text":@"近一周",@"status":@"3"},
             @{@"text":@"更多时间",@"status":@"4"}];
}

- (NSArray *)statusArray
{
    return @[@{@"text":@"全部状态",@"status":@"0"},
             @{@"text":@"消费成功",@"status":@"30"},
             @{@"text":@"已退款",@"status":@"40"},
             @{@"text":@"冲正关闭",@"status":@"60"}];
}

- (NSArray *)searchArray
{
    return @[self.branchArray,self.timeArray,self.statusArray];
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
