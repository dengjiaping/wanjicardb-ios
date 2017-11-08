//
//  WJJudgementDefine.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJJudgementDefine_h
#define WanJiCard_WJJudgementDefine_h



#define TestData 1
#define TestRequest  ;[self performSelector:@selector(managerCallAPIDidSuccess:) withObject:nil afterDelay:0.5];



#define deviceIs6P      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define SystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)

#define IOS8_LATER SystemVersionGreaterOrEqualThan(8.0)


#define perfix ((int)[UIScreen mainScreen].scale == 1 ? @"":((int)[UIScreen mainScreen].scale == 2?@"@2x":@"@3x"))
#define resourceImagePath(imageString) [UIImage imageNamed:imageString]
// [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", imageString, perfix] ofType:@"png"]]




#endif
