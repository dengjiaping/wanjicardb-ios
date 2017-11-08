//
//  WJPhotoesModel.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJPhotoesModel.h"

//property (nonatomic, strong)NSString       * des;
//@property (nonatomic, strong)NSString       *photoID;
//@property (nonatomic, assign)NSInteger    type;
//@property (nonatomic, strong)NSString       *photoURL;

@implementation WJPhotoesModel

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue
{
    self = [super init];
    if (self) {
        self.des = [dictionaryValue objectForKey:@"Desc"];
        self.photoID = [NSString stringWithFormat:@"%@",dictionaryValue[@"Id"]];
        self.type = [dictionaryValue[@"Type"] integerValue];
        self.photoURL = dictionaryValue[@"Url"];
    }
    return self;
}

@end
