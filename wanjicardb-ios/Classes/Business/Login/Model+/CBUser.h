//
//  CBUser.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseModel.h"

@interface CBUser : CBBaseModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *isSetPayPassword;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *merID;
@property (nonatomic, strong) NSString *token;

@end
