//
//  CBConfirmOrder.h
//  CardsBusiness
//
//  Created by wangzhangjie on 15/8/4.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface CBConfirmOrder : CBBaseModel<MTLJSONSerializing>

@property(nonatomic,strong) NSString* confirmMerId;
@property(nonatomic,strong) NSString* confirmMerName;
@property(nonatomic,strong) NSString* confirmUserId;
@property(nonatomic,strong) NSString* confirmUserName;
@property(nonatomic,strong) NSString* confirmOrderId;
@property(nonatomic,strong) NSString* confirmOrderNum;
@property(nonatomic,strong) NSString* confirmAmount;
@property(nonatomic,strong) NSString* confirmDate;

@end
