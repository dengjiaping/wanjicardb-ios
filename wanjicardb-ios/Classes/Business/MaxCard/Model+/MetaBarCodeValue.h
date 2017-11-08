//
//  MetaBarCodeValue.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface MetaBarCodeValue  :  CBBaseModel<MTLJSONSerializing>

@property(strong,nonatomic) NSString* value;


@end
