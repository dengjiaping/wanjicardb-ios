//
//  WJGoodsModel.h
//  CardsBusiness
//
//  Created by Lynn on 16/1/16.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJBaseModel.h"

@interface WJGoodsModel : WJBaseModel
//Cover = "http://182.92.11.169:8555//Assets/img/application/productcard/ZBoyUGWoNP.jpg";
//Ctype = 0;
//Facevalue = "0.01";
//Id = 142;
//Mername = "<null>";
//Name = "\U6d4b\U8bd5\U5546\U54c1";
//SaledNum = 0;
//Saleprice = "0.01";
//Status = 60;

@property (nonatomic, strong) NSURL             *imageURL;
@property (nonatomic, assign) NSInteger         colorType;
@property (nonatomic, assign) CGFloat           faceValue;
@property (nonatomic, assign) CGFloat           salePrice;
@property (nonatomic, strong) NSString          *goodsID;
@property (nonatomic, strong) NSString          *merName;
@property (nonatomic, strong) NSString          *goodsName;
@property (nonatomic, assign) NSInteger         saleNumber;
@property (nonatomic, assign) NSInteger         status;

@end
