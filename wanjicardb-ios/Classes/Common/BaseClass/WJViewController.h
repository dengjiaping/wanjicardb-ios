//
//  WJViewController.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UITableViewCell+SeparaitorInset.h"
#import "APIBaseManager.h"

//#import "UMAnalyticsHelper.h"
@interface WJViewController : UIViewController<APIManagerCallBackDelegate>{
    BOOL canEgeSpan;
}

/**
 *  隐藏导航栏左侧返回按钮；
 */
- (void)hiddenBackBarButtonItem;


/**
 *  添加侧滑返回手势
 */
- (void)addScreenEdgePanGesture;


/**
 *  显示LoadingView
 */
- (void)showLoadingView;

/**
 *  隐藏LoadingView
 */
- (void)hiddenLoadingView;

- (void)backBarButton:(UIButton *)btn;

/**
 * navigation 样式
 */
- (void)navigationBarIsWhite:(BOOL)boolean;


@end
