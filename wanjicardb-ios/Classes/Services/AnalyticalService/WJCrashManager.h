//
//  WJCrashManager.h
//  BuglyTest
//
//  Created by 孙明月 on 15/11/3.
//  Copyright © 2015年 SMY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bugly/CrashReporter.h>

@interface WJCrashManager : NSObject

@property (nonatomic, strong) CrashReporter *reporter;
@property (nonatomic, copy) void (^buglyBlock)(void);

+ (instancetype)sharedCrashManager;

#pragma mark - Configuration 初始化之前设置
///--------------------------------
/// @name configuration
///--------------------------------
/**
 *  是否开启sdk日志打印, 默认为No, 不打印
 *
 *  @param enabled
 */
- (void)setLogEnable:(BOOL)enable;

/** 开启CrashReport收集, 默认YES(开启状态).
 @param value 设置为NO,可关闭友盟CrashReport收集功能.
 @return void.
 */
- (void)setCrashReportEnabled:(BOOL)value;

/**
 *  是否开启主线程卡顿监控上报功能，默认值NO.
 *
 *  @param 是否开启卡顿上报
 */
- (void)enableBlockMonitor:(BOOL) enable;


/**
 *    @brief  设置卡顿场景判断的Runloop超时阀值，Runloop超时 > 阀值判定为卡顿场景
 *
 *    @param aRunloopTimeout 卡顿阀值，单位毫秒(ms)，默认值 3000 ms，可以在 1000 ms < X < 15000 ms 之间设置
 */
- (void)setMonitorJudgementLoopTimeout:(NSTimeInterval) aRunloopTimeout;

/**
 *    @brief  设置渠道标识, 默认为空值
 *
 *    如需修改设置, 请在初始化方法之前调用设置
 *
 *    @param channel 渠道标记
 */
- (void)setChannel:(NSString *)channel;

/**
 *    @brief  设置应用的版本，在初始化之前调用。
 *    SDK默认读取Info.plist文件中的版本信息,并组装成CFBundleShortVersionString(CFBundleVersion)格式
 *    如需修改设置, 请在初始化方法之前调用设置
 *
 *    @param bundleVer 自定义的版本信息
 */
- (void)setAppVersion:(NSString *)appVersion;

/**
 *    @brief  设置设备标识, SDK默认使用CFUDID标识设备
 *    注意: 平台依据deviceId统计用户数, 如果设置修改, 请保证其唯一性
 *
 *    如需修改设置, 请在初始化方法之前调用设置
 *    @param deviceId
 */
- (void)setDeviceId:(NSString *)deviceId;

/**
 *    @brief 自定义应用Bundle Identifier
 *    如需修改设置, 请在初始化方法之前调用设置
 *
 *    @param bundleId 应用Bundle Identifier
 */
- (void)setBundleId:(NSString *)bundleId;

///--------------------------------
/// @name configuration
///--------------------------------
#pragma mark -

#pragma mark -
/**
 *    @brief  初始化SDK接口并启动崩溃捕获上报功能
 *
 *    @param appId 应用标识, 在平台注册时分配的应用标识
 *
 *    @return
 */
- (BOOL)installWithAppId:(NSString *)appId;

/**
 *    @brief  初始化SDK接口并启动崩溃捕获上报功能, 如果你的App包含Application Extension或App Watch扩展，可以采用此方法初始化
 *
 *    @param appId 应用标识, 在平台注册时分配的应用标识
 *    @param identifier AppGroup标识, 开启App-Groups功能时, 定义的Identifier
 *
 *    @return
 */
- (BOOL)installWithAppId:(NSString *)appId applicationGroupIdentifier:(NSString *)identifier;

/**
 *  @brief 处理 WatchKit Extension 上报的异常信息
 *
 *    @param userInfo 异常信息
 *    @param reply    回复信息
 */
- (void)handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply;

/**
 *    @brief  设置用户标识, SDK默认值为10000
 *    建议在初始化之前使用App本地缓存的用户标识设置, 在用户登录态验证通过或切换时调用进行修改
 *    @param userid
 */
- (void)setUserId:(NSString *)userid;

/**
 *    @brief  设置场景标签, 如支付、后台等
 *
 *    @param tag 自定义的场景标签Id, 可以在服务平台页面进行配置
 */
- (void)setSceneTag:(NSUInteger) tag;

/**
 *    @brief  添加场景关键数据
 *
 *    @param value 内容, 最大长度限定为512字符
 *    @param key 自定义key(只允许字母和数字), 支持在服务平台页面进行检索
 */
- (void)setSceneValue:(NSString *) value forKey:(NSString *) key;

- (void)removeSceneValueForKey:(NSString *) key;

- (void)removeAllSceneValues;

- (NSString *)sceneValueForKey:(NSString *) key;

- (NSDictionary *)allSceneValues;

/**
 *    @brief  为一个会话周期(应用启动到进程退出)添加关键事件流程, 以记录关键场景数据
 *    一个会话记录最近20条记录, 单条记录限定最大长度为200字符
 *
 *    @param event
 */
- (void)sessionEvent:(NSString *)event;

/**
 *    @brief  上报已捕获的异常信息
 *
 *    @param anException 异常对象
 *    @param aReason    异常发生的原因
 *    @param dict        异常发生时的附加数据
 */
- (void)reportException:(NSException *) anException reason:(NSString *) aReason extraInfo:(NSDictionary *) dict;

/**
 *    @brief  上报错误
 *
 *    @param anError  错误对象
 *    @param aReason 错误发生的原因
 *    @param dict     错误发生时的附加数据
 */
- (void)reportError:(NSError *) anError reason:(NSString *) aReason extraInfo:(NSDictionary *) dict;

/**
 *    @brief  上报自定义异常信息
 *
 *    @param category     类别，C# ＝ 4，JS ＝ 5，Lua = 6
 *    @param aName       异常名称
 *    @param aReason     异常发生的原因
 *    @param aStackTrace 异常堆栈，换行使用\n连接
 *    @param dict         异常发生时附加数据
 *    @param terminate    是否中止应用
 */
- (void)reportException:(NSUInteger) category name:(NSString *) aName reason:(NSString *) aReason callStack:(NSString *) aStackTrace extraInfo:(NSDictionary *) dict terminateApp:(BOOL) terminate;
#pragma mark -

#pragma mark - Interface More ...
/**
 *  @brief 查看SDK的版本
 *
 *  @return SDK的版本信息
 */
- (NSString *)sdkVersion;

/**
 *    @brief  当卡顿功能开启时，可调用此接口在运行时启用卡顿监控线程
 */
- (void)startBlockMonitor;

/**
 *    @brief  当卡顿功能开启时，可调用此接口在运行时停止卡顿监控线程
 */
- (void)stopBlockMonitor;

/**
 *    @brief  获取SDK记录保存的设备标识
 *
 *    @return
 */
- (NSString *)deviceIdentifier;
#pragma mark -

#pragma mark - Test case for make the crash
/**
 *    @brief  触发一个ObjC的异常
 */
- (void)testThrowNSException;

/**
 *    @brief  触发一个错误信号
 */
- (void)testSignalError;
#pragma mark -


/**
 *    @brief 清理向系统注册的UncaughtException处理函数和Signal处理函数
 *    注意: 如果你不知道此接口方法的作用，请勿乱用
 */
- (void)cleanUncaughtExceptionAndSignalHandler;

- (BOOL)checkSignalHandler;

- (BOOL)checkNSExceptionHandler;

- (BOOL)enableSignalHandlerCheckable:(BOOL)enable;

#pragma mark --CrashReport
//***********在应用发生崩溃后，如果在exp_call_back_func回调函数中需要获取当前崩溃的信息，可以从这些接口获取***********

/**
 *    @brief  崩溃发生时, 添加附件内容。 在回调方法中调用
 *
 *    @param attachment 附件内容, 字符最大长度为10 * 1024
 */
- (void)setAttachLog:(NSString *)attachment;

/**
 *    @brief 崩溃发生时, 添加场景关键数据。 在回调方法中调用
 *
 *    @param value 内容, 最大长度限定为512字符
 *    @param key 自定义key
 */
- (void)setUserData:(NSString *)key value:(NSString *)value;

/**
 *    @brief  获取当前捕获到Obj-C异常
 *
 *    @return 返回捕获的Obj-C异常，当只有信号错误时，返回nil
 */
- (NSException *)getCurrentException;

/**
 *    @brief  获取Crash线程地址堆栈
 *
 *    @return 返回Crash线程的地址堆栈
 */
- (NSString *)getCrashStack;

/**
 *    @brief  获取崩溃错误类型
 *
 *    @return 返回错误类型，Obj-C异常名称或错误信号类型
 */
- (NSString *)getCrashType;

/**
 *    @brief  获取SDK生成的崩溃日志
 *
 *    @return 返回崩溃日志文件
 */
- (NSString *)getCrashLog;

// ****
/**
 *  是否开启ATS，默认值YES.
 *  如果你确定不需要此功能，你可以在初始化sdk之前调用此接口禁用功能.
 *
 *  @param enable
 */
- (void)enableAppTransportSecurity:(BOOL)enable;

/**
 *    @brief  检查是否存在崩溃信息并执行异步上报
 *
 *    @return 是否触发异步上报任务
 */
- (BOOL)checkAndUpload;

/**
 *  检查本地是否有卡顿数据并执行上报
 *
 *  @return YES if start the reporter
 */
- (BOOL)checkBlockDataExistAndReport;

/**
 *    @brief  卸载崩溃捕获监听
 */
- (void)uninstall;


//*************一些和捕获以及上报相关的接口*************
//设置异常合并上报，当天同一个异常只会上报第一次，后续合并保存并在第二天才会上报
- (void)setExpMergeUpload:(BOOL)isMerge;

//设置进程内进行地址还原, 默认开启
//注意：当Xcode的编译设置Strip Style为ALL Symbols时，该设置会导致还原出的应用堆栈出现错误，如果您的应用设置这个选项请不要调用这个接口，请调用此接口关闭进程内还原
- (void)setEnableSymbolicateInProcess:(BOOL)enable;

//设置crash过滤，以shortname为基准（例如SogouInput）,如果包括则不进行记录和上报
- (BOOL)setExcludeShortName:(NSArray *)shortNames;

//设置只上报存在关键字的crash列表
- (BOOL)setIncludeShortName:(NSArray *)shortNames;

//上次关闭是否因为crash,用于启动后检查上次是否是发生了crash，以便做特殊提示
- (BOOL)isLastCloseByCrash;

//前面的crash过滤（Include和Exclude）影响isLastCloseByCrash
//设置NO之后， 如果crash被过滤不进行记录和上报，那么isLastCloseByCrash在下次启动返回NO
//如果设置为YES， 那么crash被过滤不进行记录和上报，但下次启动isLastCloseByCrash仍旧会返回YES
- (BOOL)setLastCloseByIncludExclued:(BOOL)enable;

// *****  越狱情况API支持, AppStore版本请不要调用 *****
// 使用mach exception捕获异常, 捕获的错误比注册sigaction更全面，默认关闭
- (void)setUserMachHandler:(BOOL)useMach;

// 一般用于越狱产品，可以重新设置数据库到特定路径
- (BOOL)resetDBPath:(NSString *)newPath;


@end
