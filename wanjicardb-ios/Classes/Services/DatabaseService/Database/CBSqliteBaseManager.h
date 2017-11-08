//
//  CBSqliteBaseManager.h
//  CardsBusiness
//
//  Created by Lynn on 15/12/25.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "SqliteManager.h"

@interface CBSqliteBaseManager : SqliteManager

+ (instancetype)sharedManager;

+ (void)copyBaseData;

@end
