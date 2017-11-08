//
//  AppDelegate.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "AppDelegate.h"
#import "UserLoginViewController.h"
#import "CBPassport.h"
#import "YRSideViewController.h"
#import "LeftSliderViewController.h"
#import "Configure.h"
#import "NSStringAdditions.h"
#import "JPushHelper.h"
#import "JPushPaySuccessClient.h"
#import "ConfirmOrderViewController.h"
#import "CBMain1ViewController.h"
#import "WJCrashManager.h"
#import "WJStatisticsManager.h"

#import "UserLoginViewController.h"
#import "WJNavigationController.h"

#import "WJMainTabbarViewController.h"
#import "WJUserGuideViewController.h"

@interface AppDelegate ()
{
    BOOL isFirstLoadAfterInstalled;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"8Dp8Z6wBTsZStDExjdngkIpj"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
//    CBMain1ViewController * mainVC = [[CBMain1ViewController alloc] init];
////    CBMainViewController * mainVC = [[CBMainViewController alloc] init];
//
//    UINavigationController * mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
//    
//    LeftSliderViewController * leftVC = [[LeftSliderViewController alloc] init];
//    
//    _sideViewController = [[YRSideViewController alloc] initWithNibName:nil bundle:nil];
//    _sideViewController.rootViewController = mainNav;
//    _sideViewController.leftViewController = leftVC;
//    
//    _sideViewController.showBoundsShadow = YES;
//    _sideViewController.leftViewShowWidth = kLeftSliderWidth;
//    
//    self.window.rootViewController = _sideViewController;
    
    isFirstLoadAfterInstalled = [WJUtilityMethod whetherIsFirstLoadAfterInstalled];
    
    if(isFirstLoadAfterInstalled)
    {
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用 (用户引导页面) 作为根视图
        WJUserGuideViewController *userGuideViewController = [[WJUserGuideViewController alloc] init];
        WJNavigationController * rootNav = [[WJNavigationController alloc] initWithRootViewController:userGuideViewController];
        userGuideViewController.navigationController.navigationBar.hidden = YES;
        self.window.rootViewController = rootNav;
    }
    else
    {
        NSLog(@"不是第一次启动");
        //如果不是第一次启动的话,使用CardsViewController作为根视图
//        WJNavigationController *nvc = [[WJNavigationController alloc] initWithRootViewController:self.cardsVC];
//        self.window.rootViewController = nvc;
        if ([CBPassport userToken].length == 0 || [[CBPassport userToken] isEqualToString:@""]) {
            UserLoginViewController * userLoginVC = [[UserLoginViewController alloc] init];
            WJNavigationController * userNav = [[WJNavigationController alloc ]initWithRootViewController:userLoginVC];
            self.window.rootViewController = userNav;
        }else
        {
            WJMainTabbarViewController * mainTabbarVC = [[WJMainTabbarViewController alloc] init];
            self.window.rootViewController = mainTabbarVC;
        }
    }
   
    
//    WJMainTabbarViewController * mainTabbarVC = [[WJMainTabbarViewController alloc] init];
//    self.window.rootViewController = mainTabbarVC;
    
    [self.window makeKeyAndVisible];
    
    //xx-wzj
    [JPushHelper setupWithOptions:launchOptions];
    
    //接入友盟
    [self initUMAnalytic];
  
    //bugly接入
    [self initBugly];
    
    return YES;
}


- (void)changeRootViewController{
    
    id nvc = nil;
    
    if ([CBPassport userToken].length == 0 || [[CBPassport userToken] isEqualToString:@""]) {
        UserLoginViewController * userLoginVC = [[UserLoginViewController alloc] init];
        nvc = [[WJNavigationController alloc] initWithRootViewController:userLoginVC];

//        WJNavigationController * userNav = [[WJNavigationController alloc ]initWithRootViewController:userLoginVC];
//        self.window.rootViewController = userNav;
    }else
    {
        WJMainTabbarViewController * mainTabbarVC = [[WJMainTabbarViewController alloc] init];
        nvc = mainTabbarVC;
//        self.window.rootViewController = mainTabbarVC;
    }
    
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        self.window.rootViewController = nvc;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
    
}

- (void)initUMAnalytic{
    
#if DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [[WJStatisticsManager sharedStatisManager] setLogEnabled:YES];
#endif
    
    //关闭，因为使用bugly限制
    [[WJStatisticsManager sharedStatisManager] setCrashReportEnabled:NO];
    
    // version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[WJStatisticsManager sharedStatisManager] setAppVersion:version];
    
    [[WJStatisticsManager sharedStatisManager] startWithAppkey:@"55cda8d4e0f55a675a001eb5" reportPolicy:BATCH channelId:nil];
    
}


- (void)initBugly
{
    // 注意: 在调试SDK的捕获上报功能时，请注意以下内容:
    // 1. Xcode断开编译器，否则Xcode编译器会拦截应用错误信号，让应用进程挂起，方便开发者调试定位问题。此时，SDK无法顺利进行崩溃的错误上报
    // 2. 请关闭项目存在第三方捕获工具，否则会相互产生影响。因为崩溃捕获的机制一致，系统只会保持一个注册的崩溃处理函数,比如我们的工程中用到友盟，需要将其关闭
    
    // 调试阶段开启sdk日志打印, 发布阶段请务必关闭
#if DEBUG == 1
    [[WJCrashManager sharedCrashManager] setLogEnable:YES];
#endif
    
    [[WJCrashManager sharedCrashManager] setUserId:[NSString UUID]];
    [[WJCrashManager sharedCrashManager] installWithAppId:@"900007539"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
#pragma mark -Action- jianting
//xx--wzj
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults boolForKey:DeviceTokenStringKEY])
    {
        [JPushHelper registerDeviceToken:deviceToken];
    }
    
    
    NSLog(@"上报devicetoken。。。");
    
    NSString * token=[NSString stringWithFormat:@"%@",deviceToken];
    token = [[token substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    
    [userDefaults setObject:[token stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:DeviceTokenStringKEY];
    NSLog(@"deviceToken=====%@",token);
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [JPushHelper handleRemoteNotification:userInfo completion:nil];
    NSLog(@"＝＝＝＝＝＝handleRemoteNotification。。。");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"＝＝＝＝＝＝＝handleRemoteNotification2。。。");
    
    // IOS 7 Support Required
    [JPushHelper handleRemoteNotification:userInfo completion:completionHandler];
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付消息"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        
        [alert show];
    }
    return;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPushHelper showLocalNotificationAtFront:notification];
    return;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wanjika.CardsBusiness" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CardsBusiness" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CardsBusiness.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
