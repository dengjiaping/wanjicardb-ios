//
//  WJBaseModel.h
//  CardsBusiness
//
//  Created by Lynn on 16/1/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "MTLModel.h"

@interface WJBaseModel : MTLModel<MTLJSONSerializing>

- (BOOL)isValidModel;

@end
