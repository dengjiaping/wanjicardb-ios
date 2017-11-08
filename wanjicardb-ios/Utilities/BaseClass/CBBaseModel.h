//
//  CBBaseModel.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/13.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface CBBaseModel : MTLModel<MTLJSONSerializing>

- (BOOL)isValidModel;

@end
