//
//  CBLog.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/9.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBLog.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdarg.h>

void CBLLog(CBLogLevel logLevel, NSString *format, ...)
{
#if !(TARGET_IPHONE_SIMULATOR)
    
    va_list arglist;
    va_start(arglist, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:arglist];
    message = [message stringByAppendingString:@"\r\n\r\n"];
    
    va_end(arglist);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+08:00"]]; // 取北京时间
    NSString *dateTimeString = [formatter stringFromDate:[NSDate date]];
    
    NSString *level = @"DEBUG";
    switch (logLevel) {
        case CBLOG_SYSTEM:
            level = @"SYS";
            break;
        case CBLOG_ERROR:
            level = @"ERROR";
            break;
        case CBLOG_WARNING:
            level = @"WARNING";
            break;
        case CBLOG_DEBUG:
            level = @"DEBUG";
            break;
    }
    
    NSString *log = [NSString stringWithFormat:@"%@ [%@] %@", dateTimeString, level, message];
    
    
#if DEBUG
    NSLog(@"%@", log);
#endif
    
    NSString* filePath = [NSString stringWithFormat:@"%@CB_live.log", [FileHelper getTemporaryPath]];
    if (![FileHelper fileExistsWithPath:filePath]) {
        [FileHelper createFileWithPath:filePath];
    }
    
    // 日志大于 5 M，缓存日志文件 5*1024*1024
    if ( [FileHelper getFileSizeWithPath:filePath] >= 5*1024*1024 ) {
        NSString * oldLogFile = [NSString stringWithFormat:@"%@cache_CB_live.log",[FileHelper getTemporaryPath]];
        [FileHelper deleteFileWithPath:oldLogFile];
        [FileHelper moveFile:filePath ToNewFile:oldLogFile];
    }
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(handle){
        [handle seekToEndOfFile];
        [handle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    }
    
#endif
}
