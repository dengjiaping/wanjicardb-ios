//
//  SlidingTableViewCell.m
//  RDMApp
//
//  Created by luther.cui on 14/12/3.
//  Copyright (c) 2014年 Youku.Inc. All rights reserved.
//

#import "SlidingTableViewCell.h"
#import "UIHelper.h"
#import "Configure.h"

#define kCellTop        17.0
#define kIconLeft       22.0
#define kIconGap        15.0
#define kIconWidth      24.0

@interface SlidingTableViewCell (){
    
    UILabel      *titleLabel;
    UIImageView  *iconImageView;
    
    UIView       *backGroundView;
    
}
@end
@implementation SlidingTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _iconImageView = [[UIImageView alloc] init];
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIHelper colorWithHexColorString:@"595959"];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = [UIHelper colorWithHexColorString:@"a5a5a5"];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview: _iconImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_desLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
//    NSMutableArray * tempConstraints = [NSMutableArray array];
//    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat: @"V:|-%f-[_iconImageView(==%f)]",kCellTop,18.0] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconImageView)]];
//     [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat: @"V:|-%f-[_nameLabel(%f)]",kCellTop,18.0] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
//    
//    [tempConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_iconImageView(%f)]-%f-[_nameLabel]-0-|",kIconLeft,kIconWidth,kIconGap]options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconImageView,_nameLabel)]];
//    [self.contentView addConstraints:tempConstraints];
    
    [self.iconImageView setFrame:CGRectMake(kIconLeft, kCellTop, kIconWidth, 22)];
    float left = kIconLeft + kIconWidth + kIconGap;
    [self.nameLabel setFrame:CGRectMake(left, kCellTop+2, self.width - left , 18)];
    
    if (_desLabel.text && _desLabel.text.length > 0) {
        [self.nameLabel sizeToFit];
        float desLeft = self.nameLabel.left + self.nameLabel.width;
        [self.desLabel setFrame:CGRectMake(desLeft, self.nameLabel.top, self.width - desLeft, self.nameLabel.height)];
    }
    
    [super layoutSubviews];
}


@end
