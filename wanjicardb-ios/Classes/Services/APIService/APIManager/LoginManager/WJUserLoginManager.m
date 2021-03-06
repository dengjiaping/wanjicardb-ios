//
//  WJUserLoginManager.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/2/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJUserLoginManager.h"

@implementation WJUserLoginManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = self;
        self.validator = self;
    }
    return self;
}

#pragma mark - APIManagerVaildator
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return [data[@"Code"] integerValue] == 0;
}
/*
 当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 
 */
- (BOOL)manager:(APIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return self.userName.length > 0 & self.password.length > 0;
}

#pragma mark - APIManagerParamSourceDelegate
//让manager能够获取调用API所需要的数据
- (NSDictionary *)paramsForApi:(APIBaseManager *)manager
{
//    UIDevice *currentDevice = [UIDevice currentDevice];
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    NSString *uuid = [WJUtilityMethod keyChainValue];
    //    NSString * alias = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    //    NSString * alias = [[NSUserDefaults standardUserDefaults] objectForKey:@"JPushRegistrationId"]?:@"";
        
#if TARGET_IPHONE_SIMULATOR
#endif
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.userName, @"merchantPhone",
            self.password, @"merchantPassword",
            nil];
}

#pragma mark - APIManager Methods
- (NSString *)methodName
{
    return @"/merchant/login";
}

- (NSString *)serviceType
{
    return @"APIServiceWanJiKa";
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypePost;
}

@end
