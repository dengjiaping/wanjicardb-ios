//
//  CBImageClient.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "RESTClient.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CBImageClient : RESTClient

- (void)addImage:(UIImage *)image type:(int)type finished:(void(^)(BOOL success, NSString *message))finished;

- (void)deleteImage:(NSString *)imageID finished:(void(^)(BOOL success, NSString *message))finished;

@end
