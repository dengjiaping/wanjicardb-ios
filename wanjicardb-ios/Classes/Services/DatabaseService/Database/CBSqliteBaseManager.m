//
//  CBSqliteBaseManager.m
//  CardsBusiness
//
//  Created by Lynn on 15/12/25.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "CBSqliteBaseManager.h"

#define DATABASE_BASEDBNAME               @"Base.db"

static CBSqliteBaseManager *sharedInstance = nil;
@implementation CBSqliteBaseManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CBSqliteBaseManager alloc] initWithDBPath:DATABASE_BASEDBNAME];
    });
    
    return sharedInstance;
}

+ (void)copyBaseData{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *soruceDBPath = [[NSBundle mainBundle] pathForResource:@"Base" ofType:@"db"];
    NSString *destDBPath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), DATABASE_FOLDER, DATABASE_BASEDBNAME];
    
    NSError *error = nil;
    if([WJUtilityMethod createDirectoryIfNotPresent:DATABASE_FOLDER] && [fm fileExistsAtPath:destDBPath]){//如果已经存在，则删除已经存在的
        [fm removeItemAtPath:destDBPath error:&error];
    }
    BOOL result = [fm copyItemAtPath:soruceDBPath toPath:destDBPath error:&error];
    if(result){//拷贝，已经生成的数据库
        NSLog(@"copy success");
    }
    else{
        if(error){
            NSLog(@"error = %@",error);
        }
    }
}

- (void)upgradeTables
{
    if ([self.db open]) {
        
        NSString* sqlStr;
        
        if (![self.db tableExists:@"WJKAreaTable"]) {
            sqlStr = @"CREATE TABLE [WJKAreaTable] (\
            [AreaId] TEXT NOT NULL,\
            [Name] TEXT DEFAULT NULL,\
            [Oname] TEXT DEFAULT NULL,\
            [OrderName] TEXT DEFAULT NULL,\
            [Level] INTEGER DEFAULT NULL,\
            [Parentid] TEXT NOT NULL,\
            [Ishot] Boolean NOT NULL,\
            [Lat] FLOAT NOT NULL,\
            [Lng] FLOAT NOT NULL,\
            [Zoom] INTEGER NOT NULL,\
            [Region] INTEGER NOT NULL,\
            [IsUse] Boolean NOT NULL,\
            [Resvered1] TEXT DEFAULT NULL,\
            [Resvered2] TEXT DEFAULT NULL,\
            [Resvered3] TEXT DEFAULT NULL,\
            [Resvered4] INTEGER DEFAULT 0,\
            [Resvered5] INTEGER DEFAULT 0\
            )";
            
            [self.db executeUpdate:sqlStr];
        }
        
        if (![self.db tableExists:@"WJKVersionInfo"]) {
            sqlStr = @"create table [WJKVersionInfo] (\
            [VersionNumber] INTEGER DEFAULT '1' PRIMARY KEY AUTOINCREMENT,\
            [UpdateTime] INTEGER )";
            [self.db executeUpdate:sqlStr];
            
        }
    }
}
@end
