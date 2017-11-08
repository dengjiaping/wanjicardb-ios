//
//  WJPhotoesListViewController.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/2/1.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPhotoesListViewController.h"
#import "WJAssetLibraryManager.h"
#import "WJAssetModel.h"
#import "WJPhotoListCollectionViewCell.h"
#import "WJTailorPictureViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kLayoutLeft                     5
#define kLayoutTop                      5
#define kLayoutRight                    5
#define kLayoutBottom                   5


@interface WJPhotoesListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong) UICollectionView          *collectionView;
@property (nonatomic, strong) NSMutableArray            *assetArray;

@end

@implementation WJPhotoesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.assetArray = [NSMutableArray array];
    [self setUI];
    [self reloadAsset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
- (void)setUI
{
    self.title = @"选择照片";
    [self.view addSubview:self.collectionView];
}

- (void)reloadAsset
{
    __weak WJPhotoesListViewController * weakSelf = self;
    [[WJAssetLibraryManager alloc] reloadImagesFromLibrary:^(NSArray *assetArray, NSString *errorMsg) {
        if (errorMsg.length == 0) {
//            NSLog(@"assetArray%@",assetArray);
            
            [weakSelf.assetArray removeAllObjects];
            
//            weakSelf.assetArray = [NSMutableArray arrayWithArray:assetArray];
            
            for( int i = 0; i < [assetArray count];i++)
            {
                [weakSelf.assetArray insertObject:[assetArray objectAtIndex:i] atIndex:0];
            }
            
            NSLog(@"%@",self.assetArray);
            WJAssetModel * assetModel = [[WJAssetModel alloc] init];
            assetModel.image = [UIImage imageNamed:@"makePhotoes"];
            
            [weakSelf.assetArray insertObject:assetModel atIndex:0];
            
            [weakSelf.collectionView reloadData];
        }else
        {
            NSLog(@"error = %@",errorMsg);
        }
    }];
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
    return [self.assetArray count];
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PhotoListCellID";
   __block WJPhotoListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    WJAssetModel * assetModel = (WJAssetModel *)[self.assetArray objectAtIndex:indexPath.row];
    NSLog(@"%@",assetModel);
//   [ [WJAssetLibraryManager alloc] imageByAssetURL:assetModel.assetUrl callback:^(UIImage *image, NSError *error) {
//       cell.imageView.image = image;
//    }];
    cell.assetModel = assetModel;
//    cell.backgroundColor = [WJUtilityMethod randomColor];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = kScreenWidth/4 - kLayoutLeft - kLayoutRight;
    return CGSizeMake(width, width);
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
    NSLog(@"%s---%@",__func__,indexPath);
    
    if (indexPath.row == 0)
    {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您当前未开启相机权限，请前去设置中开启"
                                                                delegate:self
                                                       cancelButtonTitle:@"知道了"
                                                       otherButtonTitles:nil, nil];
            [alertView show];
        }else
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //设置拍照后的图片可被编辑
                //            picker.allowsEditing = YES;
                picker.sourceType = sourceType;
                [self.navigationController presentViewController:picker animated:YES completion:^{
                    
                }];
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
        }
    } else
    {
        WJAssetModel * assetModel = (WJAssetModel *)[self.assetArray objectAtIndex:indexPath.row];
        WJTailorPictureViewController * tailorVC = [[WJTailorPictureViewController alloc] init];
        tailorVC.assetModel = assetModel;
        [self.navigationController pushViewController:tailorVC animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    return YES;
}

//- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader)
//    {
//        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeaderID" forIndexPath:indexPath];
//        reusableview = self.headerView;
//    }
//    
//    //    if (kind == UICollectionElementKindSectionFooter)
//    //    {
//    //        RecipeCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//    //
//    //        reusableview = footerview;
//    //    }
//    //    reusableview.backgroundColor = [UIColor whiteColor];
//    return reusableview;
//}
//
//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    
//    CGSize size = {kScreenWidth, static_cast<CGFloat>(ALD(304))};
//    return size;
//}
//

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存图片到照片库        
        
        
       [self dismissViewControllerAnimated:YES completion:^{
           WJTailorPictureViewController * tailorPicture = [[WJTailorPictureViewController alloc] init];
           tailorPicture.assetModel = [[WJAssetModel alloc] init];
           tailorPicture.assetModel.needSelectImage = YES;
           tailorPicture.assetModel.image = image;
           [self.navigationController pushViewController:tailorPicture animated:NO];
       }];
    }
}



#pragma mark - Property
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [_collectionView registerClass:[WJPhotoListCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoListCellID"];
//        [_collectionView registerClass:[WJMainHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainHeaderID"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
