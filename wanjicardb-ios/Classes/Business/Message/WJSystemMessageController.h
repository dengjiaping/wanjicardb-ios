//
//  WJSystemMessageController.h
//  CardsBusiness
//
//  Created by XT Xiong on 16/1/6.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJViewController.h"

@interface WJSystemMessageController : WJViewController

@property (nonatomic, assign) int                   page;
@property (nonatomic, assign) int                   totalSize;
@property (nonatomic, assign) int                   totalPage;
@property (nonatomic, strong) NSMutableArray        *dataArray;

@end
