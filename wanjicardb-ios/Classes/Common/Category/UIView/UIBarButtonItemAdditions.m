//
//  MTBarButtonItem.m
//  MTGroupCore
//
//  Created by 李帅 on 12-12-5.
//  Copyright (c) 2012年 meituan.com. All rights reserved.
//

#import "UIBarButtonItemAdditions.h"
#import "UIViewAdditions.h"
#import "UIHelper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation MTBarButtonContainerView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end

const NSInteger kBarButtonItemCustomButtonTag = 0x999;
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIBarButtonItem (CustomBarButton)

//+ (UIBarButtonItem *)backBarButtonItemWithTarget:(id)target
//                                          action:(SEL)action
//{
//    return [self barButtonItemWithTitle:@"返回"
//                                 target:target
//                                 action:action];
//}
//
//+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
//                                     target:(id)target
//                                     action:(SEL)action
//{
//    return [[self alloc] initWithTitle:title
//                                 style:UIBarButtonItemStyleBordered
//                                target:target
//                                action:action];
//}

#pragma clang diagnostic pop

#pragma mark -
#pragma mark custom view
// notice we need deal with title and image

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)image
                                     target:(id)target
                                     action:(SEL)action
{
    return [self barButtonItemWithSize:CGSizeZero
                                 image:image
                         selectedImage:nil
               imageResizableCapInsets:UIEdgeInsetsZero
                                target:target
                                action:action];
}

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)normalImage
                              selectedImage:(NSString *)selectedImage
                                     target:(id)target
                                     action:(SEL)action
{
    return [self barButtonItemWithSize:CGSizeZero
                                 image:normalImage
                         selectedImage:selectedImage
               imageResizableCapInsets:UIEdgeInsetsZero
                                target:target
                                action:action];
}

+ (UIBarButtonItem *)barButtonItemWithSize:(CGSize)size
                                     image:(NSString *)image
                             selectedImage:(NSString *)selectedImage
                   imageResizableCapInsets:(UIEdgeInsets)resizableCapInsets
                                    target:(id)target
                                    action:(SEL)action
{
    return [self barButtonItemWithSize:size
                                 image:image
                         selectedImage:selectedImage
                       imageEdgeInsets:UIEdgeInsetsZero
               imageResizableCapInsets:resizableCapInsets
                                 title:nil
                       titleEdgeInsets:UIEdgeInsetsZero
                             titleFont:nil
                                target:target
                                action:action];
}

+ (UIBarButtonItem *)barButtonItemWithImage:(NSString *)iconImage
                              selectedImage:(NSString *)selectedImage
                                      title:(NSString *)title
                            titleEdgeInsets:(UIEdgeInsets)titleInset
                                  titleFont:(UIFont *)font
                                     target:(id)target
                                     action:(SEL)action
{
    return [self barButtonItemWithSize:CGSizeZero
                                 image:iconImage
                         selectedImage:selectedImage
                       imageEdgeInsets:UIEdgeInsetsZero
               imageResizableCapInsets:UIEdgeInsetsZero
                                 title:title
                       titleEdgeInsets:titleInset
                             titleFont:font
                                target:target
                                action:action];
}

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
{
    return [self barButtonItemWithSize:size
                                 image:imageName
                         selectedImage:selectedImageName
                       imageEdgeInsets:imageInset
               imageResizableCapInsets:resizableCapInsets
                                 title:title
                       titleEdgeInsets:titleInset
                             titleFont:font
                                target:target
                                action:action
                     contentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
}

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
                         contentEdgeInsets:(UIEdgeInsets)contentInset
{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (CGSizeEqualToSize(size, CGSizeZero) && UIEdgeInsetsEqualToEdgeInsets(resizableCapInsets, UIEdgeInsetsZero)) {
        size = normalImage.size;
    }
    MTBarButtonContainerView *buttonContainer = [[MTBarButtonContainerView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, size.width, size.height);
    //black magic for resolve UE's requirement
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) {
        customButton.left = 0;
        buttonContainer.hitTestEdgeInsets = UIEdgeInsetsZero;
    } else {
        customButton.left = contentInset.right - contentInset.left;
        customButton.top = contentInset.bottom - contentInset.top;
        buttonContainer.hitTestEdgeInsets = UIEdgeInsetsMake(-contentInset.top,
                                                             -contentInset.left,
                                                             -contentInset.bottom,
                                                             -contentInset.right);
    }
    customButton.imageEdgeInsets = imageInset;
    customButton.titleEdgeInsets = titleInset;
    customButton.tag = kBarButtonItemCustomButtonTag;
    if (!UIEdgeInsetsEqualToEdgeInsets(resizableCapInsets, UIEdgeInsetsZero)) {
        normalImage = [normalImage resizableImageWithCapInsets:resizableCapInsets];
        selectedImage = [selectedImage resizableImageWithCapInsets:resizableCapInsets];
    }
    [customButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [customButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    customButton.titleLabel.font = font ? font : [UIFont systemFontOfSize:12];
    customButton.titleLabel.shadowColor = [UIHelper getUIColorWithRed:0 green:0 blue:0 alpha:0.4];
    customButton.titleLabel.shadowOffset = CGSizeMake(0, -0.5);
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [buttonContainer addSubview:customButton];
    return [self barButtonItemWithView:buttonContainer];
}

+ (UIBarButtonItem *)barButtonItemWithView:(UIView *)view
{
    return [[self alloc] initWithCustomView:view];
}

@end