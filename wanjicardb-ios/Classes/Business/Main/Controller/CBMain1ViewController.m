//
//  CBMain1ViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/20.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBMain1ViewController.h"
#import "CBPassport.h"
#import "UserLoginViewController.h"
#import "Configure.h"
#import "MainView.h"
#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "CBShopInfoClient.h"
#import "MainHeaderView.h"
#import "CBShopInfo.h"
#import "MainCell.h"
#import "WithdrawViewController.h"
#import "MainCollectionViewCell.h"
#import "MainCollectionReusableHeaderView.h"
#import "WJMoreShopInfoModel.h"
#import "WJPayResultViewController.h"

#define kDefaultShopImage           @""
#define kLayoutLeft                 5
#define kLayoutTop                  5
#define kLayoutRight                5
#define kLayoutBottom               5

@interface CBMain1ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)NSArray                 *classArray;
@property(nonatomic, strong)YRSideViewController    *sliderVC;
@property(nonatomic, strong)NSArray                 *dataArray;
@end

@implementation CBMain1ViewController

#pragma mark - Property

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@{@"image":@"maxcard",@"title":@"扫扫扣费"},
                       @{@"image":@"quickMark",@"title":@"二维码"},
                       @{@"image":@"orders",@"title":@"订单"},
                       @{@"image":@"consumption",@"title":@"消费"},
                       @{@"image":@"goods",@"title":@"产品"},
                       @{@"image":@"finance",@"title":@"财务"}];
   
    }
    return _dataArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [_collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"mainCellID"];
        [_collectionView registerClass:[MainCollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeaderID"];
        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
        
        
        UIButton * withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        (kScreenWidth - 90, _moneyLabel.top + 4, 70, 30)
        [withdrawButton setFrame:CGRectMake(kScreenWidth- 90, 104, 70, 39)];
        [withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
        [withdrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        withdrawButton.layer.borderWidth = 1;
        withdrawButton.layer.borderColor = [[UIColor whiteColor]  CGColor];
        withdrawButton.backgroundColor = [UIColor redColor];
        [withdrawButton addTarget:self action:@selector(gotoWithdraw) forControlEvents:UIControlEventTouchUpInside];

        [_collectionView addSubview:withdrawButton];
        
    }
//    [layout setHeaderReferenceSize:CGSizeMake(320, 50)];

    return _collectionView;
}

- (YRSideViewController *)sliderVC
{
    if (!_sliderVC) {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        _sliderVC = [delegate sideViewController];
    }
    return _sliderVC;
}

- (NSArray *)classArray
{
         return @[ @"MaxCardViewController",
                   @"QuickMarkViewController",
                   @"OrdersViewController",
                   @"ConsumptionViewController",
                   @"GoodsViewController",
                   @"FinanceViewController"];

}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    if ([CBPassport userID] == 0) {
        
        UserLoginViewController * userVC = [[UserLoginViewController alloc] init];
        [self presentViewController:userVC animated:YES completion:^{
            
        }];
    }else
    {

    }
    self.sliderVC.needSwipeShowMenu = YES;
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self shopInfoRequest];
    [self addNotification];
    
    [self loadUI];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.sliderVC.needSwipeShowMenu = NO;
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [self removeNofitcation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Controller Flow
- (void)pushVC:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoVC:(UITapGestureRecognizer *)tap
{
    NSLog(@"\n%@\n%ld",tap,(long)tap.view.tag);
    id obj = [[NSClassFromString([self.classArray objectAtIndex:tap.view.tag - 10000]) alloc] init];
    
    [self pushVC:(UIViewController *)obj];
}

- (void)gotoWithdraw
{
//    WJPayResultViewController * resultVC = [[WJPayResultViewController alloc] init];
//        
//    [self pushVC:resultVC];
    
    WithdrawViewController * withdrawVC = [[WithdrawViewController alloc] init];
    [self pushVC:withdrawVC];
}

#pragma mark - Action

- (NSString *)currentTime
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    
    return locationString;
}

- (void)loadNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
//    NSString * imageName = [NSString stringWithFormat:@"navigationBar_%d.png",(int)kScreenWidth];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:imageName] forBarMetrics:UIBarMetricsDefault];

    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageNamed:@"mainMenu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [rightButton setImage:[UIImage imageNamed:@"mainmessage"] forState:UIControlStateNormal];
    //    [rightButton setFrame:CGRectMake(0, 0, 22, 22)];
    //    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)leftAction:(UIButton *)sender
{
    [self.sliderVC setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        //使用简单的平移动画
        rootView.frame = CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
    }];
    
    [self.sliderVC showLeftViewController:YES];
}

- (void)loadUI
{
    [self.view addSubview:self.collectionView];
    [self loadNavigation];
}

- (void)addNotification
{
    [kDefaultCenter addObserver:self selector:@selector(notificationAction:) name:kLeftSliderAction object:nil];
    [kDefaultCenter addObserver:self selector:@selector(mainRefresh) name:kMainRefreshAction object:nil];
    [kDefaultCenter addObserver:self selector:@selector(logoutAction) name:kMainLogoutAction object:nil];
    [kDefaultCenter addObserver:self selector:@selector(addressAction:) name:kMainAddressAction object:nil];
}

- (void)removeNofitcation
{
    [kDefaultCenter removeObserver:self name:kLeftSliderAction object:nil];
    [kDefaultCenter removeObserver:self name:kMainRefreshAction object:nil];
    [kDefaultCenter removeObserver:self name:kMainLogoutAction object:nil];
    [kDefaultCenter removeObserver:self name:kMainAddressAction object:nil];
    
}

- (void)notificationAction:(NSNotification *)notification
{
    id obj = [[NSClassFromString(notification.userInfo[@"class"]) alloc] init];
    
    [self pushVC:(UIViewController *)obj];
}

- (void)addressAction:(NSNotification *)noti
{
    self.headerView.addressLabel.text = noti.userInfo[@"address"];
//    self.headerView
}

- (void)mainRefresh
{
    [self shopInfoRequest];
}

- (void)logoutAction
{
    //    [CBPassport logout];
    
    [self viewWillAppear:YES];
}

- (void)moreShopInfoReqeust
{
    CBMain1ViewController * weakSelf = self;
    [[CBShopInfoClient shareRESTClient] moreShopInfoResult:^(BOOL success, WJMoreShopInfoModel *dic, NSString *message) {
        if (success) {
            if (!self.headerView) {
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    weakSelf.headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[dic.balance floatValue]];
                    [CBPassport storageMoreShopInfo:dic];
                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.headerView.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[dic.balance floatValue]];
                    [CBPassport storageMoreShopInfo:dic];
                });
            }
        }else
        {
            
        }
    }];
}

- (void)shopInfoRequest
{
    CBMain1ViewController * weakSelf = self;
    [[CBShopInfoClient shareRESTClient] shopinfoWithID:[NSString stringWithFormat:@"%d",[CBPassport merID]] finished:^(BOOL success, CBShopInfo *shopInfo, NSString *message) {
        if (success) {
            if (!self.headerView) {
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [weakSelf.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.cover] placeholderImage:[UIImage imageNamed:kDefaultShopImage]];
                    weakSelf.headerView.nameLabel.text = shopInfo.shopName;
                    weakSelf.headerView.addressLabel.text = shopInfo.shopAddress;
                    [weakSelf moreShopInfoReqeust];

                });
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.cover] placeholderImage:[UIImage imageNamed:kDefaultShopImage]];
                    weakSelf.headerView.nameLabel.text = shopInfo.shopName;
                    weakSelf.headerView.addressLabel.text = shopInfo.shopAddress;
                    [weakSelf moreShopInfoReqeust];

                });
            }
        } else {
        
            if([CBPassport shopName])
            {
                weakSelf.headerView.nameLabel.text = [CBPassport shopName];
            }
            
            if ([CBPassport shopAddress]) {
                weakSelf.headerView.addressLabel.text = [CBPassport shopAddress];
            }
            
            if ([CBPassport cover]) {
                [weakSelf.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:shopInfo.cover] placeholderImage:[UIImage imageNamed:kDefaultShopImage]];
            }
        }
    }];
}

#pragma mark - Delegate
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
    MainCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
    cell.titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = kScreenWidth/2 -kLayoutLeft - kLayoutRight;
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
    id obj = [[NSClassFromString([self.classArray objectAtIndex:indexPath.row]) alloc] init];
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
    
    reusableview.backgroundColor = [UIColor whiteColor];
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    CGSize size = {kScreenWidth, 160};
    return size;
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
