//
//  WJTimeOperationModel.m
//  CardsBusiness
//
//  Created by Lynn on 16/1/21.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJTimeOperationModel.h"

@implementation WJTimeOperationModel

+ (NSString *)currentTime
{
    //    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:];
    //    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    NSString * result = [WJUtilityMethod dateStringFromDate:[NSDate date] withFormatStyle:@"yyyy-MM-dd HH:mm:ss"];
    
    return result;
}

+ (NSString *)currentTimePassDays:(int)time
{
   
    NSDate * date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSTimeInterval passInterval = timeInterval - time * 24 * 60 *60;
    
    NSDate * passDate = [NSDate dateWithTimeIntervalSince1970:passInterval];
    
    NSString * result = [WJUtilityMethod dateStringFromDate:passDate withFormatStyle:@"yyyy-MM-dd HH:mm:ss"];

    
    return result;
}

+ (NSString *)currentDayStart
{
    NSString * result = [NSString stringWithFormat:@"%@00:00:00",[WJUtilityMethod dateStringFromDate:[NSDate date] withFormatStyle:@"yyyy-MM-dd "]];
    
    return result;
}

@end
