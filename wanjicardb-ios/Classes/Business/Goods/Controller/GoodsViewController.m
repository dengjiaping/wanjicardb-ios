//
//  GoodsViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "GoodsViewController.h"
#import "DZNSegmentedControl.h"
#import "GoodsTableViewCell.h"
#import "Configure.h"
#import "CBMoneyClient.h"
#import "WJRefreshTableView.h"

@interface GoodsViewController ()<DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate,GoodsChangeStatusActionDelegate>

@property (nonatomic, strong) DZNSegmentedControl   *control;
@property (nonatomic, strong) NSArray               *menuItems;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) WJRefreshTableView    *tableView;

@property (nonatomic, assign) GoodsType             currentGoodsType;
@property (nonatomic, assign) int                   page;
@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;

@property (nonatomic, assign) NSInteger             currentSelect;
@end

@implementation GoodsViewController

#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    self.currentGoodsType = SalingGoods;
//    [self goodsRequest];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self refreshSaleNumberWithOn:@"0" off:@"0"];    
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
    self.navigationItem.title = @"商品管理";
    self.view.backgroundColor = WJColorViewBg;
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
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    //    [self.tableView reloadData];
    if (control.selectedSegmentIndex == self.currentSelect) {
        return;
    }
    
    self.currentSelect = control.selectedSegmentIndex;
    
    NSLog(@"%ld",(long)control.selectedSegmentIndex);
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            self.currentGoodsType = SalingGoods;
        }
            break;
        case 1:
        {
            self.currentGoodsType = SaledGoods;
        }
            break;
       
        default:
            break;
    }
    [self.tableView startHeadRefresh];
//    [self startHeadRefreshToDo:self.tableView];
}

- (void)goodsRequest
{
    __weak GoodsViewController * weakSelf = self;
    self.tableView.userInteractionEnabled = NO;
    [[CBMoneyClient shareRESTClient] goodsListWithType:self.currentGoodsType page:++self.page finished:^(BOOL success, NSDictionary *dic, NSString *message) {
        weakSelf.tableView.userInteractionEnabled = YES;
        if (success) {
//            weakSelf.totalPage = [dic[@"totalPage"] intValue];
//            weakSelf.totalSize = [dic[@"totalSize"] intValue];
//            weakSelf.page = [dic[@"index"] intValue];
//        [weakSelf.listArray addObjectsFromArray:data[@"result"]];
            [weakSelf.dataArray addObjectsFromArray:dic[@"result"]];
            [weakSelf refreshSaleNumberWithOn:dic[@"onsale"] off:dic[@"offsale"]];
//            [weakSelf refreshSaleNumberWithOn:@"4" off:@"2"];

            if ([weakSelf.dataArray count] == 0)
            {
                NSString * tipStr = @"";
                
                switch (self.currentGoodsType) {
                    case SalingGoods:
                    {
                        tipStr = @"暂无上架商品卡";
                    }
                        break;
                    case SaledGoods:
                    {
                        tipStr = @"暂无下架商品卡";
                    }
                        break;
                    default:
                        break;
                }
                
                [[TKAlertCenter defaultCenter] postAlertWithMessage:tipStr];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView endHeadRefresh];
                [weakSelf.tableView endFootFefresh];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView endHeadRefresh];
                [weakSelf.tableView endFootFefresh];
            });
            weakSelf.control.userInteractionEnabled = YES;
        }else
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
            --weakSelf.page;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView endHeadRefresh];
            [weakSelf.tableView endFootFefresh];
            weakSelf.control.userInteractionEnabled = YES;
        }
    }];
}

- (void)updateGoodsStatusRequest:(int)status index:(int)index
{
    NSDictionary * dataDic = @{};
    if ([self.dataArray count]>index) {
        dataDic = [self.dataArray objectAtIndex:index];
    }else
    {
        return;
    }
    __weak GoodsViewController * weakSelf = self;
    
    [[CBMoneyClient shareRESTClient] updateGoodsStatusWithGoodsID:dataDic[@"Id"] status:status finished:^(BOOL success, NSString *message) {
        if (success) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf goodsRequest];
            
        }else
        {
            
        }
    }];
}

- (void)operationButtonAction:(UIButton *)button
{
    int temp = (int)button.tag/1000;
    
    int index = (int)(button.tag - temp * 1000);
    
    int status  = 0;
    switch (temp) {
        case 6:
        {
            status = 70;
            break;
        }
        case 7:
        {
            status = 60;
            break;
        }
        default:
            break;
    }
    
    if ([self.dataArray count] < index) {
        return;
    }
    
    [self updateGoodsStatusRequest:status index:index];
    
}

#pragma mark - Delegate


- (void)startHeadRefreshToDo:(UITableView *)tableView
{
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self goodsRequest];
    self.control.userInteractionEnabled = NO;
}

- (void)startFootRefreshToDo:(UITableView *)tableView
{
    [self goodsRequest];
    self.control.userInteractionEnabled = NO;
}


#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

#pragma mark - GoodsCellDelegate
- (void)goodsCell:(GoodsTableViewCell *)goodsCell status:(GoodsType)goodsType index:(NSInteger)index
{
    [self updateGoodsStatusRequest:goodsType index:(int)index];
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
    return ALD(95) + 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"OrderCellID";
    GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //        cell.backgroundColor = [UIHelper randomColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodsDelegate = self;
    }
    
    if([self.dataArray count] > indexPath.row)
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.dic = dic;
        cell.tag = 10000 + indexPath.row;
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

- (void)refreshSaleNumberWithOn:(NSString *)onSale off:(NSString *)offSale
{
//    - (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
    [[DZNSegmentedControl appearance] setTitle:[NSString stringWithFormat:@"出售中(%@)",onSale == nil?@"0":onSale] forSegmentAtIndex:0];
    [[DZNSegmentedControl appearance] setTitle:[NSString stringWithFormat:@"已下架(%@)",offSale == nil?@"0":offSale] forSegmentAtIndex:1];
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
        _menuItems = @[@"出售中(0)",@"已下架(0)"];
    }
    return _menuItems;
}

- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
//        _control.inverseTitles = YES;
        //        _control.selectedSegmentIndex = 1;
        _control.bouncySelectionIndicator = NO;
        _control.hairlineColor = [UIColor clearColor];
        _control.showsGroupingSeparators = YES;
        _control.tintColor = WJMainColor;
        _control.showsCount = NO;
        _control.autoAdjustSelectionIndicatorWidth = YES;
        //        _control.selectionIndicatorHeight = _control.intrinsicContentSize.height;
        _control.adjustsFontSizeToFitWidth = NO;
        
        [[DZNSegmentedControl appearance] setBackgroundColor:WJColorViewBg];
//        [[DZNSegmentedControl appearance] setTintColor:WJMainColor];
//        [[DZNSegmentedControl appearance] setHairlineColor:WJMainColor];
        
        [[DZNSegmentedControl appearance] setFont:[UIFont systemFontOfSize:14.0]];
        [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
        [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

- (WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 64) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.control;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIHelper colorWithHexColorString:@"f3f3f6"];
        
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
