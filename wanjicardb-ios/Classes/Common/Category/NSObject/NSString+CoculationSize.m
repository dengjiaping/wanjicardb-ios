//
//  NSString+CoculationSize.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/31.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "NSString+CoculationSize.h"
#import <CoreText/CoreText.h>


@implementation NSString (CoculationSize)

- (CGSize)sizeWithAttributes:(NSDictionary *)attrs constrainedToSize:(CGSize)size
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self
                                                                           attributes:attrs];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attributedString);
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, NULL);
    CFRelease(framesetter);
    return fitSize;
}


- (BOOL)isMobilePhoneNumber
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^1[\\d\\*]{10}$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    if (1 == numberOfMatches) {
        return YES;
    }
    return NO;
}

-(NSString *)EncodeUTF8Str{
    
    NSLog(@"content:%@", self);
    NSString *newContent =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,  NULL, CFSTR(":/?#[]@!$’()*+,;"), kCFStringEncodingUTF8));
    
    return newContent;
}

- (NSString *)chinaString:(NSString *)utfString
{
    NSString *transString = [NSString stringWithString:[utfString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return transString;
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

//字符串反转
- (NSString *)stringByReversed
{
    NSMutableString *s = [NSMutableString string];
    
    for (NSUInteger i = self.length; i>0; i--)
    {
        [s appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}
@end
