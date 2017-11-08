//
//  CBLog.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/9.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CBLOG_SYSTEM,
    CBLOG_ERROR,
    CBLOG_WARNING,
    CBLOG_DEBUG
}CBLogLevel;

#ifdef __cplusplus
extern "C"{
#endif
    void CBLLog(CBLogLevel logLevel, NSString *format, ...);
#define CBLog(logLevel, fmt, ...) CBLLog(logLevel, (fmt @" 【%s, %d, %s】"), ##__VA_ARGS__, __FILE__, __LINE__, __PRETTY_FUNCTION__)
#ifdef __cplusplus
}
#endif

