//
//  CBShopInfo.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/22.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBShopInfo.h"
#import "CBPrivilegeModel.h"
#import "CBProductModel.h"
#import "CBBranchModel.h"

@implementation CBShopInfo

//@property(nonatomic, strong) NSString   *shopID;
//@property(nonatomic, strong) NSString   *shopName;
//@property(nonatomic, strong) NSString   *shopAddress;
//@property(nonatomic, strong) NSString   *totalSale;
//@property(nonatomic, strong) NSArray    *privileges;
//@property(nonatomic, strong) NSString   *promotion;
//@property(nonatomic, strong) NSString   *latitude;
//@property(nonatomic, strong) NSString   *businessTime;
//@property(nonatomic, strong) NSString   *phone;
//@property(nonatomic, strong) NSString   *branchNum;
//@property(nonatomic, strong) NSArray    *branch;
//@property(nonatomic, strong) NSArray    *product;
//@property(nonatomic, strong) NSString   *galleryNum;
//@property(nonatomic, strong) NSString   *longitude;
//@property(nonatomic, assign) BOOL       isMain;
//@property(nonatomic, strong) NSString   *cover;

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"totalSale":@"TotalSale",
             @"privileges":@"privileges",
             @"promotion":@"Promotion",
             @"shopID":@"Id",
             @"contacter":@"Contacter",
             @"detail":@"Detail",
             @"status":@"Status",
             @"shopName":@"Name",
             @"latitude":@"Latitude",
             @"businessTime":@"BusinessTime",
             @"phone":@"Phone",
             @"productNum":@"ProductNum",
             @"branchNum":@"BranchNum",
             @"branch":@"Branch",
             @"product":@"Product",
             @"galleryNum":@"GalleryNum",
             @"shopAddress":@"Address",
             @"longitude":@"Longitude",
             @"isMain":@"Ismain",
             @"introduction":@"Introduction",
             @"cover":@"Cover"};

}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    
    if (self = [super init]) {
       
        
//        if ([dic[@"privileges"] isKindOfClass:[NSArray class]]) {
//            NSMutableArray * tempArray = [NSMutableArray array];
//            [dic[@"privileges"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    [tempArray addObject:[MTLJSONAdapter modelOfClass:[CBPrivilegeModel class] fromJSONDictionary:obj error:nil]];
//                }
//            }];
//            
//            self.privileges = [NSArray arrayWithArray:tempArray];
//        }
//        
//        if ([dic[@"Branch"] isKindOfClass:[NSArray class]]) {
//            NSMutableArray * tempArray = [NSMutableArray array];
//            [dic[@"Branch"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [tempArray addObject:[MTLJSONAdapter modelOfClass:[CBBranchModel class] fromJSONDictionary:obj error:nil]];
//            }];
//            self.branch = [NSArray arrayWithArray:tempArray];
//        }
//        
//        //        self.product        = dic[@"Product"];
//        
//        if ([dic[@"Product"] isKindOfClass:[NSArray class]]) {
//            NSMutableArray * tempArray = [NSMutableArray array];
//            [dic[@"Product"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [tempArray addObject:[MTLJSONAdapter modelOfClass:[CBProductModel class] fromJSONDictionary:obj error:nil]];
//            }];
//            self.product = [NSArray arrayWithArray:tempArray];
//        }
        self.totalSale      = dic[@"TotalSale"];
        self.privileges     = dic[@"privileges"];
        self.privileges     = dic[@"privileges"];
        self.branch         = dic[@"Branch"];
        self.product        = dic[@"Product"];
        self.contacter      = dic[@"Contacter"];
        self.detail         = dic[@"Detail"];
        self.status         = dic[@"Status"];
        self.promotion      = [self detection:dic[@"Promotion"]];
        self.shopID         = [self detection:dic[@"Id"]];
        self.shopName       = [self detection:dic[@"Name"]];
        self.latitude       = [self detection:dic[@"Latitude"]];
        self.businessTime   = [self detection:dic[@"BusinessTime"]];
        self.phone          = [self detection:dic[@"Phone"]];
        self.productNum     = [self detection:dic[@"ProductionNum"]];
        self.branchNum      = [self detection:dic[@"BranchNum"]];
        self.galleryNum     = [self detection:dic[@"GalleryNum"]];
        self.shopAddress    = [self detection:dic[@"Address"]];
        self.longitude      = [self detection:dic[@"Longitude"]];
        self.isMain         = [dic[@"Ismain"] boolValue];
        self.cover          = [self detection:dic[@"Cover"]];
    }
    return self;
}

- (NSString *)detection:(id)obj
{
    NSString * str = [NSString stringWithFormat:@"%@",obj];
    NSString * string =  ([str isKindOfClass:[NSNull class]] || [str isEqual:nil])?@"":str;
    
    return string;
}

@end
