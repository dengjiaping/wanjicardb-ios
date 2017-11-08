//
//  UIScreenAdditions
//  MTFramework
//
//  Created by xue hui on 3/21/13.
//  Copyright (c) 2013 Sankuai. All rights reserved.
//

#import "UIScreenAdditions.h"

@implementation UIScreen (mainScreen)

+ (CGFloat)mainScreenScale
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        return [UIScreen mainScreen].scale;
    }
    return 1.0f;
}

+ (BOOL)isMainScreenRetina
{
    if ([self mainScreenScale] > 1.0) {
        return YES;
    }
    return NO;
}

+ (NSString *)screenResolution
{
    NSString *resolution = nil;
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        CGFloat screenScale = [self mainScreenScale];
        resolution = [NSString stringWithFormat:@"%.0f*%.0f", size.width * screenScale, size.height * screenScale];
    }
    
    return resolution;
}

@end
