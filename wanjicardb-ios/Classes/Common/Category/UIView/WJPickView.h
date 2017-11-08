//
//  WJPickView.h
//  CardsBusiness
//
//  Created by XT Xiong on 15/12/30.
//  Copyright © 2015年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJPickView;
@protocol WJPickViewDelegate <NSObject>

- (void)pickerView:(WJPickView *)pickerView didSelectRow:(NSString *)selectTimeString;

@end


typedef NS_ENUM(NSInteger, PickViewDataType) {
    PickViewDataTypeTime,
    PickViewDataTypeArea,
    PickViewDataTypeBusinessTime
};

@interface WJPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) NSArray                * dataArray;
@property (strong,nonatomic) NSString               * titleString;
@property (assign,nonatomic) id<WJPickViewDelegate>   delegate;


- (instancetype)initWithTitle:(NSString *)title delegate:(id <WJPickViewDelegate>)delegate pickViewDataType:(PickViewDataType)pvType;

- (void)presentViewController:(UIViewController *)controller;

@end
