//
//  WJNavigationController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJNavigationController : UINavigationController

- (void)replaceCurrentControllerWithController:(UIViewController *)vc;

- (void)navigationBarIsWhite:(BOOL)boolean;

@end
