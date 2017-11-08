//
//  WJAssetLibraryManager.h
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/27.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^WJAssetCallBack)( NSArray * assetArray, NSString *errorMsg);
typedef void (^WJImageCallBack)( UIImage * image, NSError *error);

@interface WJAssetLibraryManager : NSObject

- (void)reloadImagesFromLibrary:(WJAssetCallBack)finish;
- (void)imageByAssetURL: (NSString *)URL callback:(WJImageCallBack)finish;

@end
