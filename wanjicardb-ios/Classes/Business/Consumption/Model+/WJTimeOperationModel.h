//
//  WJTimeOperationModel.h
//  CardsBusiness
//
//  Created by Lynn on 16/1/21.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJTimeOperationModel : NSObject

+ (NSString *)currentTime;

+ (NSString *)currentTimePassDays:(int)days;

+ (NSString *)currentDayStart;
@end
