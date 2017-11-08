//
//  WJChoiceMapViewController.h
//  CardsBusiness
//
//  Created by 熊向天 on 16/1/21.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>

@protocol WJChoiceMapVCDelegate <NSObject>

-(void)returnPoiMessage:(BMKPoiInfo *)poi;

@end

@interface WJChoiceMapViewController : WJViewController

@property(nonatomic,strong) NSString     * addressStr;
@property(nonatomic,strong) NSString     * city;

@property(nonatomic,assign)id<WJChoiceMapVCDelegate> delegate;

@end
