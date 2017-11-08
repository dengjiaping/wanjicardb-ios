//
//  WJConsumptionSearchViewController.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJConsumptionSearchViewController.h"
#import "ConsumptionTableViewCell.h"
#import "CBMoneyClient.h"
#import "WJRefreshTableView.h"
#import "CBShopInfoClient.h"


#define kDefaultOrderSearchText     @"请输入下单账号"
@interface WJConsumptionSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ConsumptionWithdrawDelegate,ConsumptionWithdrawDelegate,UIAlertViewDelegate>
{
    NSUInteger currentIndex;
}

@property (nonatomic, strong) WJRefreshTableView                        *tableView;
@property (nonatomic, strong) NSMutableArray                            *dataArray;
@property (nonatomic, strong) UISearchBar                               *searchBar;
@property (nonatomic, assign) int                                       page;
@property (nonatomic, assign) int                                       totalSize;
@property (nonatomic, assign) int                                       totalPage;

@property (nonatomic, assign) BOOL                                      canShowTK;
@property (nonatomic, strong) UIView                                    *headerView;
@end

@implementation WJConsumptionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)setupUI
{
    [self setupNavigation];
    self.view.backgroundColor = WJColorViewBg;
    [self.view addSubview:self.tableView];
}

- (void)setupNavigation
{
    self.navigationItem.titleView = self.searchBar;
}

- (void)consumptionRequest
{
    [self.searchBar resignFirstResponder];
    
    if (self.searchBar.text.length == 0) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入关键字"];
        return;
    }
    
    if (self.page >= self.totalPage  && self.totalPage != 0) {
        
        if (self.canShowTK) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"已经是全部订单"];
            self.canShowTK = NO;
        }
        return;
    }
    
    
    //    __weak typeof(self) weakSelf = self;
    __weak WJConsumptionSearchViewController * weakSelf = self;
    
    //    NSString * searchKey = ![[CBPassport userName] isEqualToString:@""] ? [CBPassport userName]:[CBPassport phone];
    [[CBMoneyClient shareRESTClient] consumptionInfoWithPage:++self.page searchKey:self.searchBar.text branch:@""  startTime:@"" endTime:@"" status:ConsumptionAllType finished:^(BOOL success, NSDictionary *dic, NSString *message) {
        [weakSelf.tableView endFootFefresh];
        [weakSelf.tableView endHeadRefresh];
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
            if (weakSelf.page == 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:dic[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([weakSelf.dataArray count] > 0) {
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView endFootFefresh];
                    [weakSelf.tableView endHeadRefresh];
//                    weakSelf.tableView.tableHeaderView CGRectMake(0, 0, kScreenWidth, ALD(0))
                }else
                {
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"未搜索到消费订单"];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView endFootFefresh];
                    [weakSelf.tableView endHeadRefresh];
                }
            });
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

- (void)requestRefundWithPaymentNo:(NSString * )noStr
{
    
    [[CBShopInfoClient shareRESTClient] shopRefundRequestWithPaymentNo:noStr  finish:^(BOOL success, NSString *message) {
        if (success) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"退款成功"];
            self.page = 0;
            [self.dataArray removeAllObjects];
            [self consumptionRequest];
        } else
        {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
        }
    }];
}

#pragma mark - Delegate

#pragma mark - WJRefreshAction
- (void)startHeadRefreshToDo:(UITableView *)tableView
{
    NSLog(@"%s",__func__);
    self.page = 0;
    [self.dataArray removeAllObjects];
    [self consumptionRequest];
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
    //    return [_listArray count];
    NSLog(@"\n%lu\n%@",(unsigned long)[self.dataArray count],self.dataArray);
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(130) + ALD(15);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"OrderCellID";
    ConsumptionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[ConsumptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //        cell.backgroundColor = [UIHelper randomColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.dataArray count] > indexPath.row) {
        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.keyWord = self.searchBar.text.length == 0?@"":self.searchBar.text;
        cell.dic = dic;
        cell.delegate = self;
        cell.tag = 10000+indexPath.row;
        //    if(indexPath.row == [self.dataArray count] - 2){
        //        [self consumptionRequest];
        //    }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(15))];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ALD(0);
}

#pragma mark - ConsumptionWithdrawDelegate


- (void)withdrawIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
    currentIndex = index;
    if ([self.dataArray count] - 1 < index) {
        return;
    } else {
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要退款吗？"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
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

#pragma mark - SearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    
    NSString * string  = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString * acswerStr = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self.searchBar.text length] == [acswerStr length]){
        if (string.length < 3) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"关键字长度应在三位及三位以上"];
//            return;
        }else{
            _tableView.userInteractionEnabled = self.searchBar.text.length > 0;
            self.page = 0;
            [self.dataArray removeAllObjects];
            [self consumptionRequest];
        }
    }else{
        ALERT(@"输入不能包含空格");
    }
}

// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _tableView.userInteractionEnabled = searchBar.text.length > 0;

}

#pragma mark - Property
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, ALD(15), kScreenWidth, kScreenHeight - ALD(69)) style:UITableViewStylePlain refreshNow:NO refreshViewType:WJRefreshViewTypeBoth];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView showFooter];
        _tableView.userInteractionEnabled = self.searchBar.text.length > 0;
        _tableView.backgroundColor = WJColorViewBg;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _headerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _headerView;
}

- (UISearchBar *) searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ALD(300), ALD(30))];
        _searchBar.delegate = self;
        //    searchBar.barStyle = UIBarStyleDefault;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.placeholder = kDefaultOrderSearchText;
        _searchBar.keyboardType =  UIKeyboardTypeASCIICapable;
        _searchBar.barTintColor = [UIColor lightGrayColor];
        //    searchBar.layer.masksToBounds = YES;
        //    [searchBar setSearchFieldBackgroundImage:
        //     [WJUtilityMethod imageFromColor:[WJUtilityMethod colorWithHexColorString:@"f8f8f8"] Width:ALD(300) Height:ALD(30)] forState:UIControlStateNormal];
        UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
        txfSearchField.backgroundColor = WJColorViewBg2;
        txfSearchField.layer.borderColor = [WJColorViewBg CGColor];
        txfSearchField.layer.borderWidth = 1;
        txfSearchField.layer.cornerRadius = ALD(15);
    }
    return _searchBar;
}

@end
