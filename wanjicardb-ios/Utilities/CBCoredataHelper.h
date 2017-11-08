//
//  CBCoredataHelper.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/29.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kEntityNameBranch       @"Branch"
#define kEntityNamePrivileges   @"Privilege"
#define kEntityNameProduct      @"Product"

@interface CBCoredataHelper : NSObject

- (void)save:(NSString *)entityName obj:(id)someModel;

- (NSArray *)read:(NSString *)entityName;

- (void)clearShopInfo;

@end
