//
//  WJSearchTapCell.h
//  WanJiCard
//
//  Created by Lynn on 15/9/17.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WJSearchTapCell;

@protocol SearchCellDelegate <NSObject>

- (void)searchTap:(WJSearchTapCell *)cell  didSelectWithindex:(int)index;

@end

@interface WJSearchTapCell : UIView
@property (nonatomic, assign)BOOL   isSelected;
@property (nonatomic, assign)BOOL   canSelected;
@property(nonatomic, weak) id<SearchCellDelegate> delegate;

- (void)setTapText:(NSString *)text;

@end
