//
//  CBMetaData.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CBMetaData : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber      *code;
@property (nonatomic, strong) NSDictionary  * value;
@property (nonatomic, strong) NSString      *message;

@end
