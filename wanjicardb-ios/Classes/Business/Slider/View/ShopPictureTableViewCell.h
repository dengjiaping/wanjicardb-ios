//
//  ShopPictureTableViewCell.h
//  CardsBusiness
//
//  Created by Lynn on 15/8/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PicturesDelegate <NSObject>

- (void)tapImage:(UIImage *)image;

- (void)addImage:(int)type;

- (void)deleteImage:(NSDictionary *)dic;

@end

@interface ShopPictureTableViewCell : UITableViewCell

@property (nonatomic, weak)id<PicturesDelegate> pictureDelegate;

@property (nonatomic, strong)UIView * pictureListView;

@property (nonatomic, strong)NSArray * pictureList;

@property (nonatomic, assign)int    index;

+ (CGFloat)heightWithPictures:(NSArray *)pictures;

@end
