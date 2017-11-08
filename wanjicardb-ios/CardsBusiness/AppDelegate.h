//
//  AppDelegate.h
//  CardsBusiness
//
//  Created by Lynn on 15/7/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>

@class YRSideViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager * _mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) YRSideViewController  *sideViewController;
@property (strong, nonatomic) NSArray               *branchs;
@property (strong, nonatomic) NSArray               *products;
@property (strong, nonatomic) NSArray               *privileges;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

- (void)changeRootViewController;

@end

