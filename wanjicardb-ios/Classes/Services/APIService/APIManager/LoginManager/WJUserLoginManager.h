//
//  WJUserLoginManager.h
//  CardsBusiness
//
//  Created by 林有亮 on 16/2/24.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "APIBaseManager.h"

@interface WJUserLoginManager : APIBaseManager<APIManagerParamSourceDelegate,APIManagerVaildator,APIManager>

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * password;

@end
