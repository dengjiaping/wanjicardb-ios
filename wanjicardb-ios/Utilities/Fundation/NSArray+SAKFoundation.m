//
//  NSArray+SKFoundation.m
//  MTFramework
//
//  Created by 陈晓亮 on 13-10-17.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import "NSArray+SAKFoundation.h"

@implementation NSArray (SAKFoundation)

- (NSArray *)sak_map:(id (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:self.count];
    NSUInteger index = 0;
    for (id object in self) {
        id result = block(object, index++);
        if (!result) {
            result = [NSNull null];
        }
        [resultArray addObject:result];
    }
    return [resultArray copy];
}

- (id)reduce:(id (^)(id, id))block
{
    NSParameterAssert(block);
    id accumulated = nil;
    for (id object in self) {
        if (!accumulated) {
            accumulated = object;
        } else {
            accumulated = block(accumulated, object);
        }
    }
    return accumulated;
}

- (id)match:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    id result = nil;
    NSUInteger index = 0;
    for (id object in self) {
        if (block(object, index++)) {
            result = object;
            break;
        }
    }
    return result;
}

- (NSArray *)filter:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    NSMutableArray *resultArray = [NSMutableArray array];
    NSUInteger index = 0;
    for (id object in self) {
        if (block(object, index)) {
            [resultArray addObject:object];
        }
    }
    return [resultArray copy];
}

- (BOOL)every:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    BOOL result = YES;
    NSUInteger index = 0;
    for (id object in self) {
        result = block(object, index++);
        if (!result) {
            break;
        }
    }
    return result;
}

- (BOOL)some:(BOOL (^)(id, NSUInteger))block
{
    NSParameterAssert(block);
    BOOL result = NO;
    NSUInteger index = 0;
    for (id object in self) {
        result = block(object, index++);
        if (result) {
            break;
        }
    }
    return result;
}

- (BOOL)notAny:(BOOL (^)(id, NSUInteger))block
{
    return ![self some:block];
}

- (BOOL)notEvery:(BOOL (^)(id, NSUInteger))block
{
    return ![self every:block];
}

@end
