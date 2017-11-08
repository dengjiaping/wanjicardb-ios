//
//  MTBarButtonItem.h
//  MTGroupCore
//
//  Created by 李帅 on 12-12-5.
//  Copyright (c) 2012年 meituan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//自定义button的tag，为了iOS7和iOS6上面barbuttonitem右边距一致，将button添加到一个UIView里面了
//通过这个tag去获取这个button的指针做各种各样的事情
extern const NSInteger kBarButtonItemCustomButtonTag;

@interface MTBarButtonContainerView : UIView

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end

@interface UIBarButtonItem (CustomBarButton)

// implement these 2 methods to customize
+ (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target
                                          action:(SEL)action;
/**
 * 如果button上只有文字，请用此方法
 * @params title, 文字内容。
 * @params target, 点击事件的接收对象。
 * @params action, 对应的点击事件。
 * @return a barButtonItem, 初始化完成的barButtonItem。
 */

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                     target:(id)target
                                     action:(SEL)action;

/**
 * 如果button上只有icon，请用此方法
 * @params iconName, 图片文件名称。
 * @params target, 点击事件的接收对象。
 * @params action, 对应的点击事件。
 * @return a barButtonItem, 初始化完成的barButtonItem。
 */

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image
                                     target:(id)target
                                     action:(SEL)action;

///////////////////////////////////////////////////////

/**
 * @warning the normal image and the selected  image must have the same size
 */

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)normalImage
                              selectedImage:(NSString *)selectedImage
                                     target:(id)target
                                     action:(SEL)action;
/**
 *
 */


+ (UIBarButtonItem *)barButtonItemWithSize:(CGSize)size
                                     image:(NSString *)image
                             selectedImage:(NSString *)selectedImage
                   imageResizableCapInsets:(UIEdgeInsets)resizableCapInsets
                                    target:(id)target
                                    action:(SEL)action;

/**
 * @abstract the button size will be identical to iconImage size
 * @warning the iconImage must have same size with selectedImage
 */

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)iconImage
                              selectedImage:(NSString *)selectedImage
                                      title:(NSString *)title
                            titleEdgeInsets:(UIEdgeInsets)titleInset
                                  titleFont:(UIFont *)font
                                     target:(id)target
                                     action:(SEL)action;

/**
 * @abstract you can config many button property. if the size is CGZeroSize and the resizableCapInsets is also zero,the button size is the same as the image
 */

+ (UIBarButtonItem *)barButtonItemWithSize:(CGSize)size
                                     image:(NSString *)imageName
                             selectedImage:(NSString *)selectedImageName
                           imageEdgeInsets:(UIEdgeInsets)imageInset
                   imageResizableCapInsets:(UIEdgeInsets)resizableCapInsets
                                     title:(NSString *)title
                           titleEdgeInsets:(UIEdgeInsets)titleInset
                                 titleFont:(UIFont *)font
                                    target:(id)target
                                    action:(SEL)action;

/**
 *  contentInset just for resolve UI bug
 */

+ (UIBarButtonItem *)barButtonItemWithSize:(CGSize)size
                                     image:(NSString *)imageName
                             selectedImage:(NSString *)selectedImageName
                           imageEdgeInsets:(UIEdgeInsets)imageInset
                   imageResizableCapInsets:(UIEdgeInsets)resizableCapInsets
                                     title:(NSString *)title
                           titleEdgeInsets:(UIEdgeInsets)titleInset
                                 titleFont:(UIFont *)font
                                    target:(id)target
                                    action:(SEL)action
                         contentEdgeInsets:(UIEdgeInsets)contentInset;
/**
 * @abstract you should provide a button with target and action.
 */

+ (UIBarButtonItem *)barButtonItemWithView:(UIView *)view;


@end