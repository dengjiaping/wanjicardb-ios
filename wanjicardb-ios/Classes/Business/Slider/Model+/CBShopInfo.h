//
//  CBShopInfo.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface CBShopInfo : CBBaseModel<MTLJSONSerializing>

@property(nonatomic, strong) NSString             *shopID;
@property(nonatomic, strong) NSString             *shopName;
@property(nonatomic, strong) NSString             *shopAddress;
@property(nonatomic, strong) NSString             *contacter;
@property(nonatomic, strong) NSAttributedString   *detail;
@property(nonatomic, strong) NSString             *status;
@property(nonatomic, strong) NSString             *totalSale;
@property(nonatomic, strong) NSArray              *privileges;
@property(nonatomic, strong) NSString             *promotion;
@property(nonatomic, strong) NSString             *latitude;
@property(nonatomic, strong) NSString             *businessTime;
@property(nonatomic, strong) NSString             *introduction;
@property(nonatomic, strong) NSString             *productNum;
@property(nonatomic, strong) NSString             *phone;
@property(nonatomic, strong) NSString             *branchNum;
@property(nonatomic, strong) NSArray              *branch;
@property(nonatomic, strong) NSArray              *product;
@property(nonatomic, strong) NSString             *galleryNum;
@property(nonatomic, strong) NSString             *longitude;
@property(nonatomic, assign) BOOL                  isMain;
@property(nonatomic, strong) NSString             *cover;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
