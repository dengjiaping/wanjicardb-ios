//
//  WJShopPhotoesViewController.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#define kLayoutLeft                     5
#define kLayoutTop                      5
#define kLayoutRight                    5
#define kLayoutBottom                   5

#define kLeftGap                        15
#define kAddModelType                   -1300

#import "WJShopPhotoesViewController.h"
#import "WJPhotoCollectionViewCell.h"
#import "WJPhotoHeaderView.h"
#import "CBShopInfoClient.h"
#import "WJPhotoesModel.h"
#import "CBImageClient.h"
#import "WJPhotoesListViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface WJShopPhotoesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ImageActionDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView              * collectionView;
@property (nonatomic, strong) WJPhotoHeaderView             * headerView;
@property (nonatomic, strong) NSMutableArray                * dataArray;
@property (nonatomic, strong) WJPhotoesModel                * addPhotoModel;
@property (nonatomic, assign) BOOL                          isEditing;

@property (nonatomic, strong) NSString                      * currentImageID;

@end

@implementation WJShopPhotoesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:self.addPhotoModel];
    self.isEditing = YES;
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isEditing = YES;
    [self picturesRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)setupUI
{
    self.title = @"相册管理";
//    PhotoesEdit
    [self.view addSubview:self.collectionView];
    [self navigationSetup];
    
//    self.view.backgroundColor = [WJUtilityMethod randomColor];
}

- (void)navigationSetup
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, ALD(22), ALD(22))];
    [rightButton setImage:[UIImage imageNamed:@"PhotoesEdit"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editPictures) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)editPictures
{
    NSLog(@"%s",__func__);
    self.isEditing = !self.isEditing;
    [self.collectionView reloadData];
}

- (void)picturesRequest
{
//    Desc = "\U4ea7\U54c1\U56fe\U7247";
//    Id = 1268;
//    Type = 30;
//    Url = "http://182.92.11.169:8555//Assets/img/upload/merchant/79/qSIJbIYfaw.png?";
    __weak WJShopPhotoesViewController * weakSelf = self;
    
    [[CBShopInfoClient shareRESTClient] shopPicturesRequestWithWidth:kScreenWidth - kLeftGap * 1.5 finish:^(BOOL success, NSArray * array, NSString *message) {
        NSLog(@"%@",array);
        weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
        
        int number = 5 - (int)[weakSelf.dataArray count];
        
        weakSelf.headerView.secondtipLabel.text = [NSString stringWithFormat:@"\t商户相册（您还可以添加%d张）",MAX(number,0) ];
        [weakSelf addAddPhotoAction];

        [self.collectionView reloadData];
    }];
}

- (void)addAddPhotoAction
{
    if([self.dataArray count] < 5)
    {
        [self.dataArray addObject:self.addPhotoModel];
    }
}


- (void)deleteRequestWithImageID:(NSString * )imageID
{
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除这张图片么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    self.currentImageID = imageID;
    [av show];
}

#pragma mark - Delegate

#pragma mark - ImageActionDelegate
- (void)deleteImageWithID :(NSString *)imageID
{
    [self deleteRequestWithImageID:imageID];
}

-(void)addImageAction
{
    NSLog(@"%s",__func__);
}

#pragma mark - collectionView

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WJPhotoesModel * model = (WJPhotoesModel *)[self.dataArray objectAtIndex:indexPath.row];
    
    static NSString * CellIdentifier = @"photoCellID";
    WJPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    switch (model.type) {
        case kAddModelType:
        {
            cell.contentView.backgroundColor = [UIColor blueColor];
            cell.photoesImageView.image = [UIImage imageNamed:@"addPhotoes"];
            cell.deleteButton.hidden = YES;
            cell.alphaImageView.hidden = YES;
        }
            break;
        default:
        {
            cell.contentView.backgroundColor = [UIColor greenColor];
            [cell.photoesImageView sd_setImageWithURL:[NSURL URLWithString:model.photoURL] placeholderImage:[UIImage imageNamed:@"defaultPhotoes"]];
            [cell buttonNeedHidden:self.isEditing];
            cell.tag = 10000+[model.photoID integerValue];
        }
        break;
    }
    
//    cell.imageView.image = [UIImage imageNamed:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
//    cell.titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    //    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = kScreenWidth/2- kLayoutLeft - kLayoutRight;
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
    WJPhotoesModel * photoModel = [self.dataArray objectAtIndex:indexPath.row];
    if (photoModel.type == kAddModelType) {
//        NSLog(@" go to %s",__func__);
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前未开启相机权限，请前去设置中开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            
            [av show];
            return;
        }
        
        
        WJPhotoesListViewController * photoListVC = [[WJPhotoesListViewController alloc] init];
        [self.navigationController pushViewController:photoListVC animated:YES];
    }
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"photoHeaderID" forIndexPath:indexPath];
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
    
    CGSize size = {kScreenWidth, static_cast<CGFloat>(ALD(330))};
    return size;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        __weak WJShopPhotoesViewController * weakSelf = self;
        [[CBImageClient shareRESTClient] deleteImage:self.currentImageID finished:^(BOOL success, NSString *message) {
            if (success) {
                weakSelf.isEditing = NO;
                [weakSelf picturesRequest];
                //            [weakSelf.tableView reloadData];

            }else{
                NSLog(@"删除失败");
                //            [weakSelf showHUDWithText:@"删除失败"];
            }
        }];
    }
}



#pragma mark - Property
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight) collectionViewLayout:layout];
        [_collectionView registerClass:[WJPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCellID"];
        [_collectionView registerClass:[WJPhotoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"photoHeaderID"];
        _collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
//        _collectionView.bounces = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIHelper colorWithHexColorString:@"f6f6f9"];
    }
    
    return _collectionView;
    
}

- (WJPhotoesModel *)addPhotoModel
{
    if ( !_addPhotoModel) {
        _addPhotoModel = [[WJPhotoesModel alloc] init];
        _addPhotoModel.photoURL = @"";
        _addPhotoModel.type =  kAddModelType;
    }
    return _addPhotoModel;
}

- (WJPhotoHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[WJPhotoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(110))];
        
        
        
    }
    return _headerView;

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
