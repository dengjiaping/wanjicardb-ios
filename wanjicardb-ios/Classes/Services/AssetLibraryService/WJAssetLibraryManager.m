//
//  WJAssetLibraryManager.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJAssetLibraryManager.h"
#import "WJAssetModel.h"

@implementation WJAssetLibraryManager

- (void)reloadImagesFromLibrary:(WJAssetCallBack)finish
{
    NSMutableArray * images = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location != NSNotFound) {
                //                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                finish(nil,@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                //                NSLog(@"相册访问失败.");
                finish(nil,@"相册访问失败.");
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            NSLog(@"%@",[group valueForProperty:ALAssetsGroupPropertyName]);
            
            if (![[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"])
            {
                return ;
            }
            
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                NSArray *arr=[[NSArray alloc] init];
                arr=[g1 componentsSeparatedByString:@","];
                NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                if ([g2 isEqualToString:@"Camera Roll"]) {
                    g2=@"相机胶卷";
                }
//                NSString *groupName=g2;//组的name
//                NSLog(@"%@",group);
//                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                NSUInteger count = group.numberOfAssets;
                //                __block NSMutableArray * assetArray = [NSMutableArray array];
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result!=NULL) {
                        
                        if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                            WJAssetModel * assetModel = [[WJAssetModel alloc] init];
                            assetModel.assetUrl  = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
                            assetModel.image = [UIImage imageWithCGImage:[result aspectRatioThumbnail]];
//                          assetModel = (WJAssetModel *)result;
//                          NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
//                          NSLog(@"%ld",index);
                            [images addObject:assetModel];
                        }
                        if (index == count - 1) {
                            //                        NSLog(@"image = %@",images);
                            finish(images,@"");
                        }
                    }else
                    {
                        finish(@[],@"");
                    }
                    
                 
                    
                }];
                
//                NSLog(@"%ld",group.numberOfAssets);
                
            }
            
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    [images addObject:urlstr];
                }
            }
            if (result == NULL) {
                NSLog(@"%@",images);
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
}


- (void)imageByAssetURL:(NSString *)URL callback:(WJImageCallBack)finish
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:[NSURL URLWithString:URL] resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage * image = [UIImage imageWithCGImage:imgRef
                                              scale:assetRep.scale
                                        orientation:(UIImageOrientation)assetRep.orientation];
//        UIImage * image = asset f        
        finish(image,nil);
    } failureBlock:^(NSError *error) {
        finish(nil,error);
    }];
}








@end
