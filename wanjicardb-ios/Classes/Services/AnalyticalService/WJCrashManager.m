//
//  WJCrashManager.m
//  BuglyTest
//
//  Created by 孙明月 on 15/11/3.
//  Copyright © 2015年 SMY. All rights reserved.
//

#import "WJCrashManager.h"
#import <Bugly/CrashReporter.h>

@implementation WJCrashManager

static int exception_callback_handler() {

    NSLog(@"did crashed !!!");
    if ([WJCrashManager sharedCrashManager].buglyBlock) {
        [WJCrashManager sharedCrashManager].buglyBlock();
    }
    return 1;
}


+ (instancetype)sharedCrashManager{
    static WJCrashManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WJCrashManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self){

        _reporter = [CrashReporter sharedInstance];
        exp_call_back_func = &exception_callback_handler;
        
    }
    return self;
}

- (void)setLogEnable:(BOOL)enable
{
    [self.reporter enableLog:enable];
}
- (void)setCrashReportEnabled:(BOOL)value
{
  
}
- (void)enableBlockMonitor:(BOOL) enable
{
    [self.reporter enableBlockMonitor:enable];
}

- (void)setMonitorJudgementLoopTimeout:(NSTimeInterval) aRunloopTimeout
{
    [self.reporter setBlockMonitorJudgementLoopTimeout:aRunloopTimeout];
}

- (void)setChannel:(NSString *)channel
{
    [self.reporter setChannel:channel];
}

- (void)setAppVersion:(NSString *)appVersion
{
    [self.reporter setBundleVer:appVersion];
}

- (void)setDeviceId:(NSString *)deviceId
{
    [self.reporter setDeviceId:deviceId];
}

- (void)setBundleId:(NSString *)bundleId
{
    [self.reporter setBundleId:bundleId];
}

- (BOOL)installWithAppId:(NSString *)appId
{
    return [self.reporter installWithAppId:appId];
}

- (BOOL)installWithAppId:(NSString *)appId applicationGroupIdentifier:(NSString *)identifier
{
    return [self.reporter installWithAppId:appId applicationGroupIdentifier:identifier];
}

- (void)handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    [self.reporter handleWatchKitExtensionRequest:userInfo reply:reply];
}

- (void)setUserId:(NSString *)userid
{
    [self.reporter setUserId:userid];
}

- (void)setSceneTag:(NSUInteger) tag
{
    [self.reporter setSceneTag:tag];
}

- (void)setSceneValue:(NSString *) value forKey:(NSString *) key;
{
    [self.reporter setSceneValue:value forKey:key];
}

- (void)removeSceneValueForKey:(NSString *) key
{
    [self.reporter removeSceneValueForKey:key];
}

- (void)removeAllSceneValues
{
    [self.reporter removeAllSceneValues];
}

- (NSString *)sceneValueForKey:(NSString *) key
{
   return [self.reporter sceneValueForKey:key];
}

- (NSDictionary *)allSceneValues
{
    return [self.reporter allSceneValues];
}

- (void)sessionEvent:(NSString *)event
{
    [self.reporter sessionEvent:event];
}

- (void)reportException:(NSException *) anException reason:(NSString *) aReason extraInfo:(NSDictionary *) dict
{
    [self.reporter reportException:anException reason:aReason extraInfo:dict];
}

- (void)reportError:(NSError *) anError reason:(NSString *) aReason extraInfo:(NSDictionary *) dict
{
    [self.reporter reportError:anError reason:aReason extraInfo:dict];
}

- (void)reportException:(NSUInteger) category name:(NSString *) aName reason:(NSString *) aReason callStack:(NSString *) aStackTrace extraInfo:(NSDictionary *) dict terminateApp:(BOOL) terminate
{
    [self.reporter reportException:category name:aName reason:aReason callStack:aStackTrace extraInfo:dict terminateApp:terminate];
}

- (NSString *)sdkVersion
{
    return [self.reporter sdkVersion];
}

- (void)startBlockMonitor
{
    [self.reporter startBlockMonitor];
}

- (void)stopBlockMonitor
{
    [self.reporter stopBlockMonitor];
}

- (NSString *)deviceIdentifier
{
    return [self.reporter deviceIdentifier];
}

- (void)testThrowNSException
{
    [self.reporter testThrowNSException];
}

- (void)testSignalError
{
    [self.reporter testSignalError];
}

- (void)cleanUncaughtExceptionAndSignalHandler
{
    [self.reporter cleanUncaughtExceptionAndSignalHandler];
}

- (BOOL)checkSignalHandler
{
    return [self.reporter checkSignalHandler];
}

- (BOOL)checkNSExceptionHandler
{
    return [self.reporter checkNSExceptionHandler];
}

- (BOOL)enableSignalHandlerCheckable:(BOOL)enable
{
    return [self.reporter enableSignalHandlerCheckable:enable];
}

- (void)setAttachLog:(NSString *)attachment
{
    [self.reporter setAttachLog:attachment];
}

- (void)setUserData:(NSString *)key value:(NSString *)value
{
    [self.reporter setUserData:key value:value];
}

- (NSException *)getCurrentException
{
  return [self.reporter getCurrentException];
}

- (NSString *)getCrashStack
{
    return [self.reporter getCrashStack];
}


- (NSString *)getCrashType
{
   return [self.reporter getCrashType];
}

- (NSString *)getCrashLog
{
   return [self.reporter getCrashLog];
}

- (void)enableAppTransportSecurity:(BOOL)enable
{
    [self.reporter enableAppTransportSecurity:enable];
}

- (BOOL)checkAndUpload
{
   return [self.reporter checkAndUpload];
}

- (BOOL)checkBlockDataExistAndReport
{
    return [self.reporter checkBlockDataExistAndReport];
}

- (void)uninstall
{
    [self.reporter uninstall];
}

//*************一些和捕获以及上报相关的接口*************
- (void)setExpMergeUpload:(BOOL)isMerge
{
    [self.reporter setExpMergeUpload:isMerge];
}

- (void)setEnableSymbolicateInProcess:(BOOL)enable
{
    [self.reporter setEnableSymbolicateInProcess:enable];
}

- (BOOL)setExcludeShortName:(NSArray *)shortNames
{
    return [self.reporter setExcludeShortName:shortNames];
}

- (BOOL)setIncludeShortName:(NSArray *)shortNames
{
   return [self.reporter setIncludeShortName:shortNames];
}


- (BOOL)isLastCloseByCrash
{
    return [self.reporter isLastCloseByCrash];
}

- (BOOL)setLastCloseByIncludExclued:(BOOL)enable
{
    return [self.reporter setLastCloseByIncludExclued:enable];
}

- (void)setUserMachHandler:(BOOL)useMach
{
    [self.reporter setUserMachHandler:useMach];
}


- (BOOL)resetDBPath:(NSString *)newPath
{
    return [self.reporter resetDBPath:newPath];
}



@end
