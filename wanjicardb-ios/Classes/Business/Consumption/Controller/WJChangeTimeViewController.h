//
//  WJChangeTimeViewController.h
//  CardsBusiness
//
//  Created by Lynn on 16/1/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

typedef enum
{
    WJBusinessTime = 0,
    WJConsumptionTime = 1
}TimeType;

@protocol ConsumptionDelegate <NSObject>

- (void)moreTimeConsumptionWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end

#import "WJViewController.h"

@interface WJChangeTimeViewController : WJViewController

@property (nonatomic, assign) TimeType  timeType;

@property (nonatomic, weak)id<ConsumptionDelegate> delegate;

@end
