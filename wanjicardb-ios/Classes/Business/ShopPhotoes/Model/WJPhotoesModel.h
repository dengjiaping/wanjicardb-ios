//
//  WJPhotoesModel.h
//  CardsBusiness
//
//  Created by 林有亮 on 16/1/29.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaseModel.h"

@interface WJPhotoesModel : WJBaseModel

@property (nonatomic, strong)NSString       * des;
@property (nonatomic, strong)NSString       *photoID;
@property (nonatomic, assign)NSInteger      type;
@property (nonatomic, strong)NSString       *photoURL;

- (instancetype) initWithDictionary:(NSDictionary *)dictionaryValue;

@end
