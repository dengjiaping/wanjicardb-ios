//
//  OrdersTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/6.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "OrdersTableViewCell.h"
#import "Configure.h"

#define kLetfGap        14
#define kTopGap         10

@interface OrdersTableViewCell()
{
    UIView * backView;
    UIView * line1;
    UIView * line2;
}
@end


@implementation OrdersTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.keyWord = @"";
        
        [self.contentView setBackgroundColor:WJColorViewBg];
        self.backgroundColor = WJColorViewBg;
        
        line1 = [[UIView alloc] init];
        [line1 setFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        [line1 setBackgroundColor:WJColorViewBg];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"状态:";
        _statusLabel.textColor = WJColorDardGray9;
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusValueLabel = [[UILabel alloc] init];
        _statusValueLabel.font = [UIFont systemFontOfSize:14];
//        _statusValueLabel.textColor = [UIHelper colorWithHexColorString:@"fc8e04"];
        
        _ordersNumberLabel = [[UILabel alloc] init];
        _ordersNumberLabel.textColor = WJColorDardGray9;
        _ordersNumberLabel.textAlignment = NSTextAlignmentRight;
        _ordersNumberLabel.font = [UIFont systemFontOfSize:14];
        
        backView = [[UIView alloc] init];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [backView setFrame:CGRectMake(0, 0, kScreenWidth, ALD(165))];
        backView.layer.borderColor = [[UIHelper colorWithHexColorString:@"e0e0e0"] CGColor];
        backView.layer.borderWidth = 1;
//        backView.backgroundColor = [WJUtilityMethod randomColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = WJColorDardGray3;
        
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = WJColorDardGray3;
        _numberLabel.text = @"数量:";
        _numberLabel.font = [UIFont systemFontOfSize:14];
        
        _numberValueLabel = [[UILabel alloc] init];
        _numberValueLabel.textColor =WJColorDardGray3;
        _numberValueLabel.font = [UIFont systemFontOfSize:14];
        
        _ordersMoneyLabel = [[UILabel alloc] init];
        _ordersMoneyLabel.textColor = WJColorDardGray3;
        _ordersMoneyLabel.text = @"订单金额:";
        _ordersMoneyLabel.font = [UIFont systemFontOfSize:14];
        
        _ordersMoneyValueLabel = [[UILabel alloc] init];
        _ordersMoneyValueLabel.textColor = [UIHelper colorWithHexColorString:@"ff4400"];
        _ordersMoneyValueLabel.font = [UIFont systemFontOfSize:14];
        
        line2 = [[UIView alloc] init];
        [line2 setBackgroundColor:[UIHelper colorWithHexColorString:@"e0e0e0"]];
        
        _buyerAccountLabel = [[UILabel alloc] init];
        _buyerAccountLabel.textColor = WJColorDardGray9;
        _buyerAccountLabel.text = @"下单账号:";
        _buyerAccountLabel.font = [UIFont systemFontOfSize:14];
        
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:14];
        _phoneLabel.textColor = WJColorDardGray9;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = WJColorDardGray9;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        
        
        [self.contentView addSubview:backView];
        
        [backView addSubview:_statusLabel];
        [backView addSubview:_statusValueLabel];
        [backView addSubview:_ordersNumberLabel];
        [backView addSubview:line1];
        [backView addSubview:_titleLabel];
        [backView addSubview:_numberLabel];
        [backView addSubview:_numberValueLabel];
        [backView addSubview:_ordersMoneyLabel];
        [backView addSubview:_ordersMoneyValueLabel];
        [backView addSubview:_buyerAccountLabel];
        [backView addSubview:_phoneLabel];
        [backView addSubview:_timeLabel];
        [backView addSubview:line2];
    }
    return self;
}
//Buynum = 1;
//Cover = "http://ca.wjika.com/Assets/img/application/productcard/ZhAkc68wkm.png";
//Date = "2015/8/3 17:24:36";
//Facevalue = "0.02";
//Id = 1071;
//Name = "F\U6d4b\U8bd5\U50a8\U503c\U5361";
//OrderAmount = "0.01";
//Orderno = GK150803001071;
//Pcid = 58;
//SalePrice = "0.01";
//Status = 50;
//StatusName = "\U8ba2\U5355\U5173\U95ed";
//Type = 10;
//Username = 15311200586;
- (void)layoutSubviews
{
    [_statusLabel sizeToFit];
    
    [_statusLabel setFrame:CGRectMake(kLetfGap, 0, _statusLabel.width, ALD(35))];
    [_statusValueLabel setFrame:CGRectMake(_statusLabel.left + _statusLabel.height + 6, _statusLabel.top, 100, _statusLabel.height)];
    _statusValueLabel.text = self.dic[@"StatusName"];
    [_statusValueLabel setTextColor:[self colorWithStatus:[self.dic[@"Status"] intValue]]];

    [_ordersNumberLabel setFrame:CGRectMake(kScreenWidth/2-70, _statusLabel.top, kScreenWidth/2 - kLetfGap + ALD(70), _statusLabel.height)];
    
//    [backView setFrame:CGRectMake(0, _statusLabel.top + _statusLabel.height, kScreenWidth, 110)];
    
    [line1 setFrame:CGRectMake(line1.frame.origin.x, _ordersNumberLabel.frame.size.height + _ordersNumberLabel.frame.origin.y, line1.frame.size.width, line1.frame.size.height)];
    
    [_titleLabel setFrame:CGRectMake(kLetfGap, line1.frame.size.height + line1.frame.origin.y + ALD(10), kScreenWidth - kLetfGap * 2, ALD(20))];
    [_titleLabel setText:self.dic[@"Name"]];
    
    [_numberLabel sizeToFit];
    
    [_numberLabel setFrame:CGRectMake(kLetfGap, _titleLabel.top + _titleLabel.height + ALD(2), _numberLabel.width, ALD(20))];
    [_numberValueLabel setFrame:CGRectMake(_numberLabel.left + _numberLabel.width + 6, _numberLabel.top, ALD(100), _numberLabel.height)];
    _numberValueLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"Buynum"]];

    [_ordersMoneyLabel sizeToFit];
    [_ordersMoneyLabel setFrame:CGRectMake(kLetfGap, _numberLabel.top + _numberLabel.height + ALD(2), _ordersMoneyLabel.width, ALD(20))];
    
    [_ordersMoneyValueLabel setFrame:CGRectMake(_ordersMoneyLabel.left + _ordersMoneyLabel.width + 6, _ordersMoneyLabel.top, 100, _ordersMoneyLabel.height)];
    _ordersMoneyValueLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.dic[@"OrderAmount"] doubleValue]];
    
    [line2 setFrame:CGRectMake(0, _ordersMoneyLabel.top + _ordersMoneyLabel.height + ALD(10), kScreenWidth , 1)];
    
    [_buyerAccountLabel sizeToFit];
    [_buyerAccountLabel setFrame:CGRectMake(kLetfGap, line2.top , _buyerAccountLabel.width, ALD(40))];
    
    [_phoneLabel setFrame:CGRectMake(kLetfGap + _buyerAccountLabel.width + 6, _buyerAccountLabel.top, ALD(200), _buyerAccountLabel.height)];
   
    /* 关键字高亮
    NSString * phoneStr = self.dic[@"Username"];
    
    if (![self.keyWord isEqualToString:@""]) {
        NSRange range = [phoneStr rangeOfString:self.keyWord];
        
        if (range.location != NSNotFound) {
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:phoneStr];
            
            NSDictionary *attributesForFirstWord = @{
                                                     NSFontAttributeName : WJFont14,
                                                     NSForegroundColorAttributeName : WJMainColor,
                                                     };
            [attributedString setAttributes:attributesForFirstWord range:range];
            _phoneLabel.attributedText = attributedString;
        }else
        {
            _phoneLabel.text = self.dic[@"Username"];
        }
  
    }else
    {
        _phoneLabel.text = self.dic[@"Username"];
    }
    
    NSString * orderStr = [NSString stringWithFormat:@"订单号:%@",self.dic[@"Orderno"]];
    
    if (![self.keyWord isEqualToString:@""]) {
        NSRange range = [orderStr rangeOfString:self.keyWord];
        
        if (range.location != NSNotFound) {
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:orderStr];
            
            NSDictionary *attributesForFirstWord = @{
                                                     NSFontAttributeName : WJFont14,
                                                     NSForegroundColorAttributeName : WJMainColor,
                                                     };
            [attributedString setAttributes:attributesForFirstWord range:range];
            _ordersNumberLabel.attributedText = attributedString;
        }else
        {
            [_ordersNumberLabel setText:[NSString stringWithFormat:@"订单号:%@",self.dic[@"Orderno"] ]];
        }
    }else
    {
        [_ordersNumberLabel setText:[NSString stringWithFormat:@"订单号:%@",self.dic[@"Orderno"] ]];
    }
    */
    
    _phoneLabel.text = self.dic[@"Username"];
    [_ordersNumberLabel setText:[NSString stringWithFormat:@"订单号:%@",self.dic[@"Orderno"] ]];
    

    [_timeLabel setFrame:CGRectMake(kScreenWidth/2, _phoneLabel.frame.origin.y, kScreenWidth/2 - ALD(15), _phoneLabel.frame.size.height)];
    _timeLabel.text = self.dic[@"Date"];
    
//    [backView setFrame:CGRectMake(0, _statusLabel.top + _statusLabel.height, kScreenWidth, _phoneLabel.top + _phoneLabel.height)];
//    [backView setFrame:CGRectMake(0, 0, kScreenWidth, _phoneLabel.top + _phoneLabel.height)];

    
}

- (NSString *)stringWithStatus:(int)status
{
    NSString * str = @"";
    switch (status) {
        case 15:
        {
            str = @"待支付";
        }
            break;
        case 30:
        {
            str = @"已处理";
        }
            break;
        case 45:
        {
            str = @"已退回";
        }
            break;
            case 50:
        {
            str = @"已失效";
        }
        default:
            break;
    }
    return str;
}

- (UIColor *)colorWithStatus:(int)status
{
    UIColor * color = nil;
//    switch (status) {
//        case 15:
//        {
//            color = [UIHelper colorWithHexColorString:@"ff8f02"];
//        }
//            break;
//        case 30:
//        {
//            color = [UIHelper colorWithHexColorString:@"dd434d"];
//        }
//            break;
//        case 45:
//        case 50:
//        {
//            color = [UIHelper colorWithHexColorString:@"999999"];
//        }
//        default:
//            break;
//    }
    color = WJColorDardGray9;
    return color;
}

@end
