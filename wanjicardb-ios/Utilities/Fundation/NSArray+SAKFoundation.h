//
//  NSArray+SKFoundation.h
//  MTFramework
//
//  Created by 陈晓亮 on 13-10-17.
//  Copyright (c) 2013年 Sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SAKFoundation)

/**
 *  Apply BLOCK to each element and collect the results into a new array.
 *
 *  @param block block to be applied to elements, it passes an element and its index as parameters
 *
 *  @return a new array containing the results
 */
- (NSArray *)sak_map:(id (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to first two elements, get the result, then apply block to the result and the next element and so on.
 *
 *  @param block block to be applied to elements, it passes the last result and the current element as parameters
 *
 *  @return a result object
 */
- (id)reduce:(id (^)(id accumulated, id object))block;

/**
 *  Find the first object with which BLOCK takes as parameter and returns YES.
 *
 *  @param block block to be tested on elements
 *
 *  @return the first object passes testing
 */
- (id)match:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Apply BLOCK to each element and collect the ones passes testing by performed by BLOCK.
 *
 *  @param block block to be tested on elements
 *
 *  @return a new array containing objects pass the testisg
 */
- (NSArray *)filter:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether each element passes testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if every elements pass the testing, NO otherwise. If array is empty, returns YES
 */
- (BOOL)every:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether any element passes testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if there is at least one element passes the testing, NO otherwise. If array is empty, returns NO
 */
- (BOOL)some:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether no elements pass the testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if there is no elements pass the testing, YES otherwise. If array is empty, returns YES.
 */
- (BOOL)notAny:(BOOL (^)(id object, NSUInteger index))block;

/**
 *  Determine whether any element doesn't pass the testing.
 *
 *  @param block block to be tested on elements
 *
 *  @return YES if there is at least one element doesn't pass the testing, NO otherwise. If array is empty, returns NO
 */
- (BOOL)notEvery:(BOOL (^)(id object, NSUInteger index))block;

@end
