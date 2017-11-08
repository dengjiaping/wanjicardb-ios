//
//  WJPhotoCollectionViewCell.h
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/28.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageActionDelegate <NSObject>

- (void)deleteImageWithID :(NSString *)imageID;
-(void)addImageAction;

@end


@interface WJPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView       * photoesImageView;
@property (nonatomic, strong) UIButton          * deleteButton;
@property (nonatomic, strong) UIImageView       * alphaImageView;

@property (nonatomic, weak) id<ImageActionDelegate> delegate;

- (void)buttonNeedHidden:(BOOL)isNeedHidden;

@end
