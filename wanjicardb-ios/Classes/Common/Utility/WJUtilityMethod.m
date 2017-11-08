//
//  WJUtilityMethod.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJUtilityMethod.h"
//#import "SSKeychain.h"
#import "MBProgressHUD.h"
#import "Reachability.h"


@implementation WJUtilityMethod

+ (BOOL) createDirectoryIfNotPresent:(NSString *)dirName
{
    //创建一个目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), dirName]]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), dirName]
                                         withIntermediateDirectories:NO
                                                          attributes:nil
                                                               error:nil];
    }
    
    return YES;
}


//+ (NSString *)keyChainValue{
//    
//    NSString *strUUID = [SSKeychain passwordForService:KeychainService account:KeychainAccount];
//    if (nil == strUUID || 1 > strUUID.length)
//    {
//        CFUUIDRef uuid = CFUUIDCreate(NULL);
//        assert(uuid != NULL);
//        strUUID = [NSString stringWithFormat:@"%@", CFUUIDCreateString(NULL, uuid)];
//        [SSKeychain setPassword:strUUID forService:KeychainService account:KeychainAccount];
//    }
//    
//    return strUUID;
//}

#pragma mark 图片处理
+ (UIImage *)imageFromColor:(UIColor *)color Width:(int)width Height:(int) height{
    CGRect rect = CGRectMake(0, 0,width,height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

+(UIColor *)colorWithHexColorString:(NSString *)hexColorString{
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:1.0f];
}


+ (NSAttributedString *)convertHtmlTextToAttributedString:(NSString *)htmlText{
    htmlText = @"<bold>Wow!</bold> Now <em>iOS</em> can create <h3>NSAttributedString</h3> from HTMLs!";
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:options
                                                           documentAttributes:nil
                                                                        error:nil];
    
    return attrString;
}



+ (NSDictionary *)attributesForUserTextWithCalculateMode:(BOOL)isCalculateMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.lineBreakMode = isCalculateMode ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
    
    return @{NSFontAttributeName : [UIFont systemFontOfSize:12],
             NSParagraphStyleAttributeName : paragraphStyle,
             NSForegroundColorAttributeName: [UIColor blackColor]};
}


+ (UIColor *)getColorFromImage:(UIImage *)image
{
    return [UIColor colorWithPatternImage:image];
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)moneyFormat:(NSString *)money
{    
    NSArray * array = [money  componentsSeparatedByString:@"."];
    if ([array count] == 1) {
        money = [NSString stringWithFormat:@"%@.00",money];
    }
    
    NSString * firstStr = [[money  componentsSeparatedByString:@"."] firstObject];
    NSString * lastStr = [[money  componentsSeparatedByString:@"."] lastObject];
    NSInteger lenght  = firstStr.length;
    
    NSInteger starIndex = lenght % 3;
    NSMutableString * str = (NSMutableString *) [firstStr substringToIndex:starIndex];
    
    for(int i = 0; i < lenght/3; i++)
    {
        if (str.length > 0)
        {
            str = (NSMutableString *) [str  stringByAppendingString:@","];
        }
        
        NSString * subStr = [firstStr substringWithRange:NSMakeRange(starIndex + i*3, 3)];
        
        str =  (NSMutableString *)[str  stringByAppendingString:subStr];
    }
    NSLog(@"str = %@.%@",str,lastStr);
    
    return [NSString stringWithFormat:@"%@.%@",str,lastStr];
}

//图片裁剪
+ (UIImage *)getImageFromImage:(UIImage*) superImage
                  subImageSize:(CGSize)subImageSize
                  subImageRect:(CGRect)subImageRect {
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return returnImage;
}


+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, (float)size.width, (float)size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+ (UIColor *)randomColor
{
    return COLOR(arc4random()%256, arc4random()%256, arc4random()%256, 1);
}

+ (NSString *)currentDay
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString *)currentDateByFormatter:(NSString *)formaterStr
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formaterStr];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString *)keyChainValue
{
//    NSString *strUUID = [SSKeychain passwordForService:KeychainService account:KeychainAccount];
    NSString * strUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceUUIDwjk"];
    if (nil == strUUID || 1 > strUUID.length)
    {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        strUUID = [NSString stringWithFormat:@"%@", CFUUIDCreateString(NULL, uuid)];
//        [SSKeychain setPassword:strUUID forService:KeychainService account:KeychainAccount];
        [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:@"deviceUUIDwjk"];
    }
    
    return strUUID;
    //    return @"";
}


+ (BOOL)whetherIsFirstLoadAfterInstalled{
    
//    return YES;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppVersion"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"AppVersion"];
        return YES;
    }
    return NO;
}

+ (NSString *)floatNumberFomatter:(CGFloat)floatNumber{
    
    NSString* str;
    
    if (fmodf(floatNumber, 1)==0) {
        str = [NSString stringWithFormat:@"%.0f",floatNumber];
    } else if (fmodf(floatNumber*10, 1)==0) {
        str = [NSString stringWithFormat:@"%.1f",floatNumber];
    } else {
        str = [NSString stringWithFormat:@"%.2f",floatNumber];
    }
    return str;
}

+ (NSString *)floatNumberForMoneyFomatter:(CGFloat)floatNumber{
    
    NSString * str;
    str = [NSString stringWithFormat:@"%.2f",floatNumber];
    return str;
}

+ (NSString *)dateStringFromDate:(NSDate *)date
                 withFormatStyle:(NSString *)formatStyle{
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatStyle];
    NSString *dateStr=[dateformatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

+ (NSString *)versionNumber{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSLog(@"****** Verson : %@ ******", version);

    return version;
}

+ (BOOL)isValidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"^[1][3-8][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}


+ (BOOL)isValidateVerifyCode:(NSString *)code{
    NSString *codeRegex = @"^\\d{4}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", codeRegex];
    return [codeTest evaluateWithObject:code];
}

+ (BOOL)isNotReachable {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable && [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}


@end
