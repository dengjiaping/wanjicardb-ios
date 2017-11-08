//
//  CBImageClient.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "CBImageClient.h"
#import "Configure.h"
#import <AFNetworking/AFNetworking.h>

@interface CBImageClient()

@property (nonatomic, strong) RESTClient * client;

@end

@implementation CBImageClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = [RESTClient shareRESTClient];
    }
    return self;
}

- (void)addImage:(UIImage *)image type:(int)type finished:(void(^)(BOOL success,NSString *message))finished
{
    NSString *requestURL = CBURLWithPath(kUploadImage);
    NSDictionary * dic = @{@"id":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"app_id":kAppID,
                           @"token":[CBPassport userToken],
                           @"type":[NSString stringWithFormat:@"%d",type]
                           };
    
    NSString * sign = [self signWithDic:dic];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];

    NSData * data = nil;
    data = UIImageJPEGRepresentation(image,.5);
  
    NSLog(@"data = %@",data);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];    
    
    [manager POST:requestURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        [formData appendPartWithFileData :data name:@"1" fileName:@"1.png" mimeType:@"image/jpeg"];
        
        
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        if ([[responseObject objectForKey:@"Code"] intValue]== 0) {
            finished(YES,responseObject[@"Msg"]);
        }else{
            finished(NO,responseObject[@"Msg"]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        finished(NO,@"上传失败");
    }];
}

- (void)deleteImage:(NSString *)imageID finished:(void(^)(BOOL success, NSString *message))finished
{
    NSDictionary * dic = @{@"app_id":kAppID,
                           @"merid":[NSString stringWithFormat:@"%d",[CBPassport merID]],
                           @"token":[CBPassport userToken],
                           @"id":imageID
                           };
    NSString * requestURL = CBURLWithPath(kDeleteImage);
    NSString * sign = [self signWithDic:dic];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params setObject:sign forKey:@"sign"];
    
    [_client postToURL:requestURL withURLParams:nil bodyParams:params finished:^(CBMetaData *meta, id data, NSError *error) {
        
        if (!meta) {
            finished(NO,kNetworkErrorString);
            return ;
        }
        
        if ([meta.code intValue] == 0) {
            NSLog(@"%@",meta.code);
            
            if (data) {
                finished(YES,nil);
            } else {
                finished(NO, meta.message);
            }
        } else {
            if (meta) {
                finished(NO, meta.message);
                NSLog(@"%@",meta.code);
            } else {
                
            }
        }

    }];
}


@end
