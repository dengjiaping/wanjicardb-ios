//
//  WJOrdersSearchViewController.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/12.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJOrdersSearchViewController.h"
#import "OrdersTableViewCell.h"
#import "CBMoneyClient.h"
#import "WJRefreshTableView.h"
#define kDefaultOrderSearchText     @"请输入下单账号"


@interface WJOrdersSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) WJRefreshTableView    *tableView;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) UISearchBar           *searchBar;
@property (nonatomic, assign) int                   page;
@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;

@property (nonatomic, assign) BOOL                  canShowTK;
@end

@implementation WJOrdersSearchViewController

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
    self.view.backgroundColor = WJColorBlack;
    [self.view addSubview:self.tableView];
}

- (void)setupNavigation
{
    self.navigationItem.titleView = self.searchBar;
}

- (void)ordersRequest
{
    [self.searchBar resignFirstResponder];
    [self.tableView showFooter];
    [self.tableView showHeader];
    if (self.searchBar.text.length == 0) {
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入关键字"];
        return;
    }
    
    if (self.page >= self.totalPage  && self.totalPage != 0) {
        
        if (self.canShowTK) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"已经是全部订单"];
            self.canShowTK = NO;
            [self.tableView hiddenFooter];
        }
        return;
    }
    //    __weak typeof(self) weakSelf = self;
    __weak WJOrdersSearchViewController * weakSelf = self;
    
    [[CBMoneyClient shareRESTClient] ordersListWithType:AllOrders page:++self.page searchKey:self.searchBar.text finished:^(BOOL success, NSDictionary *dic, NSString *message)
     {
         weakSelf.canShowTK = YES;

         if (success) {
             weakSelf.totalPage = [dic[@"totalPage"] intValue];
             weakSelf.totalSize = [dic[@"totalSize"] intValue];
             weakSelf.page = [dic[@"index"] intValue];
             //        [weakSelf.listArray addObjectsFromArray:data[@"result"]];
             [weakSelf.dataArray addObjectsFromArray:dic[@"result"]];
             
             if([weakSelf.dataArray count] == 0)
             {
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:@"未搜索到订单"];
                 weakSelf.page = 0;
                 [weakSelf.tableView reloadData];
                 [weakSelf.tableView endFootFefresh];
                 [weakSelf.tableView endHeadRefresh];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.tableView reloadData];
                 [weakSelf.tableView endHeadRefresh];
                 [weakSelf.tableView endFootFefresh];
             });
         }else
         {
             if ([weakSelf.dataArray count] == 0) {
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:message];
                 [weakSelf.tableView reloadData];
                 [weakSelf.tableView endHeadRefresh];
                 [weakSelf.tableView endFootFefresh];
             }
             
         }
     }];
}

#pragma mark - Delegate
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
    return ALD(165)+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"OrderCellID";
    OrdersTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if([self.dataArray count] > indexPath.row)
    {
        NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.dic = dic;
        cell.keyWord = self.searchBar.text;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - SearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    _tableView.userInteractionEnabled = self.searchBar.text.length > 0;

    NSString * searchKey = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (searchKey.length < 3) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"关键字长度应在三位及三位以上"];
        return;
    }
    
    NSString * regex = @"^[A-Za-z0-9]{3,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:searchKey];
    
    if (!isMatch) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"您输入的关键字有误!"];
        return;
    }else
    {
        self.page = 0;
        [self.dataArray removeAllObjects];
        [self ordersRequest];
    }
}

// return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - Property
- (WJRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WJRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - ALD(64)) style:UITableViewStylePlain refreshNow:YES refreshViewType:WJRefreshViewTypeFooter];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = WJColorViewBg;
        
        _tableView.userInteractionEnabled = self.searchBar.text.length > 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView showFooter];
    }
    return _tableView;
}

- (UISearchBar *)searchBar
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
