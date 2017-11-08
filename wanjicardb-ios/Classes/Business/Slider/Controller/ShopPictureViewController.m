//
//  ShopPictureViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ShopPictureViewController.h"
#import "Configure.h"
#import "CBShopInfoClient.h"
#import "ShopPictureTableViewCell.h"
#import "PicturesHeaderView.h"
#import "ZYQAssetPickerController.h"
#import "CBImageClient.h"

#define kLeftGap     15

@interface ShopPictureViewController ()<UITableViewDataSource,UITableViewDelegate,PicturesDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)PicturesHeaderView * headerView;
@property(nonatomic, strong)NSArray * dataArray;

@property(nonatomic, strong)NSMutableArray * shopPicturesArray;
@property(nonatomic, strong)NSMutableArray * shopPhotoArray;

@property(nonatomic, assign) int       type;
@property(nonatomic, strong)NSString    * imageID;
@end

@implementation ShopPictureViewController

#pragma mark - Property
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:self.shopPhotoArray, self.shopPicturesArray, nil];//店铺环境，产品图片
    }
    return _dataArray;
}

- (NSMutableArray *)shopPhotoArray
{
    if (!_shopPhotoArray) {
        _shopPhotoArray = [NSMutableArray array];
    }
    return _shopPhotoArray;
}

- (NSMutableArray *)shopPicturesArray
{
    if (!_shopPicturesArray) {
        _shopPicturesArray = [NSMutableArray array];
    }
    return _shopPicturesArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (PicturesHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[PicturesHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    }
    return _headerView;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUI];
    [self picturesRequest];
    
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
    self.navigationItem.title = @"相册管理";
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)picturesRequest
{
    
    [[CBShopInfoClient shareRESTClient] shopPicturesRequestWithWidth:kScreenWidth - kLeftGap * 1.5 finish:^(BOOL success, NSArray * array, NSString *message) {
        [self.shopPicturesArray removeAllObjects];
        [self.shopPhotoArray removeAllObjects];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
               
                switch ([obj[@"Type"] intValue]) {
                    case 10:
                    {
                        [self.shopPhotoArray addObject:obj];
                    }
                        break;
                    case 30:
                    {
                        [self.shopPicturesArray addObject:obj];
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
        if ([self.shopPhotoArray count] < 8 ) {
            [self.shopPhotoArray addObject:@{@"Type":@"-10",@"Url":@""}];
        }
        
        if ([self.shopPicturesArray count] < 8 ) {
            [self.shopPicturesArray addObject:@{@"Type":@"-30",@"Url":@""}];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [_listArray count];
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [ShopPictureTableViewCell heightWithPictures:[self.dataArray objectAtIndex:indexPath.section]];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"PicturesCellID";
    ShopPictureTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShopPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.pictureDelegate = self;
        //        cell.backgroundColor = [UIHelper randomColor];
    }
    cell.pictureList = [self.dataArray objectAtIndex:indexPath.section];
    NSLog(@"-------%lu",(unsigned long)[cell.pictureList count]);
    cell.index = (int)indexPath.section +1;
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    sectionHeaderView.layer.borderColor = [[UIHelper colorWithHexColorString:@"e0e0e0"] CGColor];
    sectionHeaderView.layer.borderWidth = 1;
    sectionHeaderView.backgroundColor = [UIHelper colorWithHexColorString:@"f4f5f7"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    [sectionHeaderView addSubview:label];
    switch (section) {
        case 0:
            label.text = @"店铺内部环境";
            break;
        case 1:
            label.text = @"产品图片";
            break;
        default:
            break;
    }
//    sectionHeaderView.backgroundColor = [UIHelper randomColor];
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    sectionFooterView.backgroundColor = [UIHelper randomColor];
    sectionFooterView.backgroundColor = [UIHelper colorWithHexColorString:@"f4f5f7"];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 30)];
    [sectionFooterView addSubview:label];
    label.text = @"提示：1、最多只能上传8张图片；2、长按图片进行删除";
    label.font = [UIFont systemFontOfSize:10];
    return sectionFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark PictureDelegare

- (void)addImage:(int)type
{
    self.type = type;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)deleteImage:(NSString *)imageID;
{
    self.imageID = [NSString stringWithFormat:@"%@",imageID];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

- (void)deleteRequestWithImageID:(NSString * )imageID
{
    __weak ShopPictureViewController * weakSelf = self;
    [[CBImageClient shareRESTClient] deleteImage:imageID finished:^(BOOL success, NSString *message) {
        if (success) {
//            NSLog(@"成功");
//            [weakSelf showHUDWithText:@"删除成功"];
            //            for (int i = 0 ; i < [self.dataArray count]; i++) {
            //                for ( int j = 0; j < [[self.dataArray objectAtIndex:i] count]; j++) {
            //
            //                    NSDictionary * dic = [[self.dataArray objectAtIndex:i]objectAtIndex:j];
            //                    if ([dic[@"Type"] intValue] < 0) {
            //                        continue;
            //                    }
            //                    if ([dic[@"Id"] intValue] == 0) {
            //                        continue;
            //                    }
            //
            //                    if ([dic[@"Id"] intValue] == [imageID intValue]) {
            //                        [[self.dataArray objectAtIndex:i] removeObject:[[self.dataArray objectAtIndex:i]objectAtIndex:j]];
            //                        [weakSelf.tableView reloadData];
            //                    }
            //
            //                }
            //            }
            [self.shopPhotoArray removeAllObjects];
            [self.shopPicturesArray removeAllObjects];
            [weakSelf picturesRequest];
            //            [weakSelf.tableView reloadData];
        }else{
            NSLog(@"删除失败");
//            [weakSelf showHUDWithText:@"删除失败"];

        }
    }];

}


#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSLog(@"%s",__func__);
    NSLog(@"%d",self.type);
    
    switch (self.type) {
        case -30:
        {
            if([[[self.shopPicturesArray lastObject] objectForKey:@"Type"] intValue] < 0)
            {
                [self.shopPicturesArray removeLastObject];
            }
            
            if ([self.shopPicturesArray count] + [assets count] > 8) {
                NSLog(@"最多只能上传8张图片");
            } else
            {
                [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[ALAsset class]]) {
                        UIImage * image =  [UIImage imageWithCGImage: ((ALAsset *)obj).thumbnail];
                        
                        NSLog(@"%d",abs(self.type));
                        __weak ShopPictureViewController * weakSelf = self;
//                        abs(self.type)
                        [[CBImageClient shareRESTClient] addImage:image type:30 finished:^(BOOL success, NSString *message) {
                            if (success) {
                                [weakSelf picturesRequest];
                            }else
                            {
                                
                            }
                        }];
                    }
                }];
            }
        }
            break;
        case -10:
        {
            if([[[self.shopPhotoArray lastObject] objectForKey:@"Type"] intValue] < 0)
            {
                [self.shopPhotoArray removeLastObject];
            }
            
            if ([self.shopPhotoArray count] + [assets count] > 8) {
                NSLog(@"最多只能上传8张图片");
            } else
            {
                [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[ALAsset class]]) {
                        UIImage * image =  [UIImage imageWithCGImage: ((ALAsset *)obj).thumbnail];
                        __weak ShopPictureViewController * weakSelf = self;

                        [[CBImageClient shareRESTClient] addImage:image type:10 finished:^(BOOL success, NSString *message) {
                            if (success) {
                                [weakSelf picturesRequest];
                            }else
                            {
                                
                            }
                        }];
                    }
                }];
            }

        }
            break;
        default:
            break;
    }
    
}

#pragma AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //取消删除
            self.imageID = nil;
        }
            break;
        case 1:
        {
            //确认删除
            if (!([self.imageID length] > 0)) {
                return;
            }
            
            [self deleteRequestWithImageID:self.imageID];
            
        }
        default:
            break;
    }
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
