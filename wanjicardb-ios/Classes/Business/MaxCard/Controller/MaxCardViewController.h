//
//  MaxCardViewController.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBBaseViewController.h"
#import "MBProgressHUD.h"
@interface MaxCardViewController : CBBaseViewController

//@property (nonatomic, strong) void (^SYQRCodeCancleBlock) (MaxCardViewController *);
//@property (nonatomic, strong) void (^SYQRCodeSuncessBlock) (MaxCardViewController *,NSString *);
//@property (nonatomic, strong) void (^SYQRCodeFailBlock) (MaxCardViewController *);

@property(nonatomic,strong) MBProgressHUD *payAlertHUD;

- (void)showCustomDialog:(NSString *)msg;
- (BOOL)isPureInt:(NSString*)string;
@end
