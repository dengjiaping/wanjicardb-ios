//
//  WJMainViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/12/24.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "WJMainViewController.h"
#import "WJMainHeaderView.h"
#import "WJMainCollectionViewCell.h"
#import "CBShopInfoClient.h"
#import "WJMoreShopInfoModel.h"
#import "WJMerchantManageController.h"

#import "MaxCardViewController.h"


#define kLayoutLeft                 5
#define kLayoutTop                  5
#define kLayoutRight                5
#define kLayoutBottom               5

#define kNoSeeMoney                 [NSString stringWithFormat:@"%@noSee",[CBPassport userName]]

@interface WJMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIImageView       * navigationImageView;
@property (nonatomic, strong) UICollectionView  * collectionView;
@property (nonatomic, strong) WJMainHeaderView  * headerView;
@property (nonatomic, strong) NSArray           * classArray;
@property (nonatomic, strong) NSArray           * dataArray;

@property (nonatomic, assign) BOOL              notSeeMoney;
@property (nonatomic, strong) UIButton          * rightButton;

@end

@implementation WJMainViewController

#pragma mark- Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.navigationController.navigationBar.barTintColor = WJColorNavigationBar;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self notSeeMoney];
    [self UISetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.tabBarController.tabBar.hidden?@"YES":@"NO");
    
    self.navigationImageView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;

    [self navigationBarIsWhite:NO];
    [self shopInfoRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = YES;
    self.navigationImageView.hidden = NO;
//    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - View Controller Flow
- (void)pushVC:(UIViewController *)vc
{
    
//    id obj = [[NSClassFromString(@"MaxCardViewController") alloc] init];
//    if([obj isKindOfClass:vc])
    self.tabBarController.tabBar.hidden = YES;

    if([[[vc class] alloc] isMemberOfClass:[MaxCardViewController class]])
    {
        self.navigationController.navigationBarHidden = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Delegate
#pragma mark - collectionView

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.classArray count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"mainCellID";
    WJMainCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    cell.titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = kScreenWidth/3 - kLayoutLeft - kLayoutRight;
    return CGSizeMake(width, 114);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kLayoutTop, kLayoutLeft, kLayoutBottom, kLayoutRight);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.hidesBottomBarWhenPushed = YES;
    id obj = [[NSClassFromString([self.classArray objectAtIndex:indexPath.row]) alloc] init];
//    self.tabBarController.tabBar.hidden = NO;

    [self pushVC:(UIViewController *)obj];
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    return YES;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeaderID" forIndexPath:indexPath];
        reusableview = self.headerView;
    }
    
    //    if (kind == UICollectionElementKindSectionFooter)
    //    {
    //        RecipeCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    //
    //        reusableview = footerview;
    //    }
    //    reusableview.backgroundColor = [UIColor whiteColor];
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGSize size = {kScreenWidth, static_cast<CGFloat>(ALD(304))};
    return size;
}


#pragma mark- Event Response
// TODO:所有 button、gestureRecognizer、notification 的事件相应方法，与跳转到其他 controller 的出口方法都写在这里。

- (void)moreShopInfoReqeust
{
    __weak WJMainViewController * weakSelf = self;
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
                [weakSelf refreshHeaderView];
            });
        }else
        {
            
        }
    }];
}

- (void)shopInfoRequest
{
    __weak WJMainViewController * weakSelf = self;
    [[CBShopInfoClient shareRESTClient] shopinfoWithID:[NSString stringWithFormat:@"%d",[CBPassport merID]] finished:^(BOOL success, CBShopInfo *shopInfo, NSString *message) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.cover] placeholderImage:[UIImage imageNamed:kDefaultShopImage]];
//                    weakSelf.headerView.nameLabel.text = shopInfo.shopName;
//                    weakSelf.headerView.addressLabel.text = shopInfo.shopAddress;
                [weakSelf moreShopInfoReqeust];
            });
            
            if([CBPassport shopName])
            {
                //                weakSelf.headerView.nameLabel.text = [CBPassport shopName];
                weakSelf.navigationItem.title = [CBPassport shopName];
            }
        } else {
            
            if([CBPassport shopName])
            {
//                weakSelf.headerView.nameLabel.text = [CBPassport shopName];
                weakSelf.navigationItem.title = [CBPassport shopName];
            }
//            if ([CBPassport shopAddress]) {
//                weakSelf.headerView.addressLabel.text = [CBPassport shopAddress];
//            }
//            if ([CBPassport cover]) {
//                [weakSelf.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.cover] placeholderImage:[UIImage imageNamed:kDefaultShopImage]];
//            }
        }
    }];
}

#pragma mark- Rotation
// TODO:转屏处理写在这。
#pragma mark- Private Methods
// TODO:理论上来说，此处不应有私有方法存在，都应该在上面找到归类。这里应该放置拆分的中间方法。
-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)navigationSetup
{
    UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navigationImageView = navigationImageView;
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(0, 0, ALD(22), ALD(22))];
//    rightButton.backgroundColor = [WJUtilityMethod randomColor];
    [self.rightButton setImage:[UIImage imageNamed:@"main_order_show"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(notSeeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, ALD(22), ALD(22))];
//    [leftButton setImage:@"" forState:UIControlStateNormal];
    leftButton.userInteractionEnabled = NO;
    

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)UISetup
{
    [self navigationSetup];
    [self.view addSubview:self.collectionView];

//    UIWebView * webView = [[UIWebView alloc] initWithFrame:[self.view bounds]];
//    [self.view addSubview:webView];
//    [webView loadHTMLString:[CBPassport detail] baseURL:[NSURL URLWithString:@"baidu.com"]];
//    webView.backgroundColor = [WJUtilityMethod randomColor];
//    [self webViewDidFinishLoad:webView];

}

- (void)webViewDidFinishLoad:(UIWebView *)detailWebView
{
    CGFloat offsetHeight = [[detailWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    CGFloat scrollHeight = [[detailWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    NSLog(@"The height of offsetHeight is %f", offsetHeight);
    NSLog(@"The height of scrollHeight is %f", scrollHeight);
}

- (void)notSeeAction
{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",!self.notSeeMoney] forKey:kNoSeeMoney];
//    [self.collectionView reloadData];
    [self refreshHeaderView];
}

-(void)refreshHeaderView
{
    if (self.notSeeMoney) {
        [self hideNumber];
    }else
    {
        [self showNumber];
    }
}


- (void)hideNumber
{
    self.headerView.orderNumberLabel.text = @"****";
    self.headerView.todaySaleMoneyLabel.text = @"****";
    [self.rightButton setImage:[UIImage imageNamed:@"main_order_hidden"] forState:UIControlStateNormal];
}

- (void)showNumber
{
    self.headerView.orderNumberLabel.text = [CBPassport todayOrderNumber];
    self.headerView.todaySaleMoneyLabel.text = [CBPassport todayIncomeNumber];
    [self.rightButton setImage:[UIImage imageNamed:@"main_order_show"] forState:UIControlStateNormal];
}

#pragma mark- Getter and Setter
// TODO:所有属性的初始化，都写在这

- (BOOL)notSeeMoney
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kNoSeeMoney] boolValue];
}

- (WJMainHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[WJMainHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(304))];
//        _headerView.backgroundColor = [WJUtilityMethod randomColor];
//        _headerView.orderNumberLabel.text = @"24";
//        _headerView.todaySaleMoneyLabel.text = @"3,124.00";
    }
    
    return _headerView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [_collectionView registerClass:[WJMainCollectionViewCell class] forCellWithReuseIdentifier:@"mainCellID"];
        [_collectionView registerClass:[WJMainHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeaderID"];
        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
    }
    return _collectionView;
}

- (NSArray *)dataArray
{
    return  @[@{@"image":@"main_list_0",@"title":@"收款"},
              @{@"image":@"main_list_1",@"title":@"订单管理"},
              @{@"image":@"main_list_2",@"title":@"消费管理"},
              @{@"image":@"main_list_3",@"title":@"商品管理"},
              @{@"image":@"main_list_4",@"title":@"财务管理"},
              @{@"image":@"main_list_5",@"title":@"店铺管理"}];
}

- (NSArray *)classArray
{
    return @[ @"MaxCardViewController",
              @"OrdersViewController",
              @"ConsumptionViewController",
              @"GoodsViewController",
              @"FinanceViewController",
              @"WJMerchantManageController"];
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
