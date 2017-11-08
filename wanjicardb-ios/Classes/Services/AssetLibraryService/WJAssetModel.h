//
//  WJAssetModel.h
//  AssetLibrary
//
//  Created by 林有亮 on 16/1/27.
//  Copyright © 2016年 林有亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAssetModel : NSObject

@property (nonatomic, strong) NSString  * assetUrl;
@property (nonatomic, strong) UIImage   * image;

@property (nonatomic, assign) BOOL      needSelectImage;

@end
