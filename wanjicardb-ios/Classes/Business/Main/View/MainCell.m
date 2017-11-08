//
//  MainCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/17.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "MainCell.h"
#import "Configure.h"


@implementation MainCell
- (instancetype)initWithImageNmae:(NSString *)imageName titleName:(NSString *)titleName
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//        _iconImageView.backgroundColor = [UIHelper randomColor];
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIHelper randomColor];
        _titleLabel.text = titleName;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIHelper colorWithHexColorString:@"6c798a"];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_iconImageView];
        [self addSubview:_titleLabel];
        
        self.layer.borderWidth = .5;
        self.layer.borderColor = [[UIHelper colorWithHexColorString:@"ececec"] CGColor];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGSize size = self.iconImageView.image.size;
    CGFloat x = (frame.size.width - size.width*1.5)/2;
    CGFloat y = frame.size.height/2 -10 - size.height*1.5/2;
    
    [_iconImageView setFrame:CGRectMake(x, y, size.width*1.5, size.height*1.5)];
    
    [_titleLabel setFrame:CGRectMake(0, _iconImageView.top + _iconImageView.height+6, frame.size.width, 20)];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
