//
//  ConsumptionTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/11.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ConsumptionTableViewCell.h"
#import "Configure.h"

@interface ConsumptionTableViewCell()

@property (nonatomic, strong) UILabel   * statusLabel;
@property (nonatomic, strong) UILabel   * timeLabel;

@property (nonatomic, strong) UILabel   * orderLabel;
@property (nonatomic, strong) UILabel   * phoneLabel;
@property (nonatomic, strong) UILabel   * priceLabel;

@property (nonatomic, strong) UIButton  * refundButton;

@end

@implementation ConsumptionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(130))];
        backView.backgroundColor = WJColorWhite;
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), 0, ALD(100), ALD(30))];
        _statusLabel.font = WJFont13;
        _statusLabel.textColor = WJColorDardGray9;
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(115), 0, kScreenWidth - ALD(115 + 15 * 2), ALD(30))];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = WJFont13;
        _timeLabel.textColor = WJColorDardGray9;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(30), kScreenWidth, 1)];
        line.backgroundColor = WJColorViewBg;
        
        _orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), ALD(12) + CGRectGetMaxY(line.frame), kScreenWidth * 2.0 /3, ALD(15))];
        _orderLabel.font = WJFont15;
        _orderLabel.textColor = WJColorDardGray3;
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), CGRectGetMaxY(_orderLabel.frame) + ALD(15), CGRectGetWidth(_orderLabel.frame), ALD(15))];
        _phoneLabel.font = WJFont15;
        _phoneLabel.textColor = WJColorDardGray3;
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(15), CGRectGetMaxY(_phoneLabel.frame)+ALD(15), CGRectGetWidth(_phoneLabel.frame), ALD(15))];
        _priceLabel.font = WJFont15;
        _priceLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"ff4400"];
        
        _refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refundButton setFrame:CGRectMake(kScreenWidth - ALD(105), ALD(55) + CGRectGetMaxY(line.frame), ALD(90), ALD(30))];
        [_refundButton setTitle:@"退款" forState:UIControlStateNormal];
        [_refundButton setTitle:@"已退款" forState:UIControlStateDisabled];
        [_refundButton setTitleColor:WJMainColor forState:UIControlStateNormal];
        [_refundButton setTitleColor:WJColorDardGray9 forState:UIControlStateDisabled];
        _refundButton.layer.cornerRadius = ALD(15);
        _refundButton.layer.borderWidth = 1;
        _refundButton.layer.borderColor = [WJMainColor CGColor];
        
        [_refundButton addTarget:self action:@selector(withdrawAciotn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.keyWord = @"";
        
        
        [backView addSubview: _statusLabel];
        [backView addSubview:_timeLabel];
        [backView addSubview:line];
        [backView addSubview:_orderLabel];
        [backView addSubview:_phoneLabel];
        [backView addSubview:_priceLabel];
        [backView addSubview:_refundButton];
        
        self.contentView.backgroundColor = WJColorViewBg;
        [self.contentView addSubview:backView];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.statusLabel.text = [self stringWithStatus:(ConsumptionType) [self.dic[@"Status"] intValue]];
    
    self.timeLabel.text = [self.dic[@"Date"]  stringByReplacingOccurrencesOfString:@"/" withString:@"-"];

/* 关键字高亮
//    NSString * phoneStr = [NSString stringWithFormat:@"手机号码：%@",self.dic[@"Username"]];
//    
//    if (![self.keyWord isEqualToString:@""]) {
//        NSRange range = [phoneStr rangeOfString:self.keyWord];
//        
//        if (range.location != NSNotFound) {
//            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:phoneStr];
//            
//            NSDictionary *attributesForFirstWord = @{
//                                                     NSFontAttributeName : WJFont14,
//                                                     NSForegroundColorAttributeName : WJMainColor,
//                                                     };
//            [attributedString setAttributes:attributesForFirstWord range:range];
//            _phoneLabel.attributedText = attributedString;
//        }else
//        {
//            _phoneLabel.text = phoneStr;
//        }
//        
//    }else
//    {
//        _phoneLabel.text = phoneStr;
//    }
//    
//    NSString * orderStr = [NSString stringWithFormat:@"消费单号：%@",self.dic[@"Paymentno"]];
//    
//    if (![self.keyWord isEqualToString:@""]) {
//        NSRange range = [orderStr rangeOfString:self.keyWord];
//        
//        if (range.location != NSNotFound) {
//            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:orderStr];
//            
//            NSDictionary *attributesForFirstWord = @{
//                                                     NSFontAttributeName : WJFont14,
//                                                     NSForegroundColorAttributeName : WJMainColor,
//                                                     };
//            [attributedString setAttributes:attributesForFirstWord range:range];
//            self.orderLabel.attributedText = attributedString;
//        }else
//        {
//            self.orderLabel.text = orderStr;
//        }
//        
//    }else
//    {
//        //        _phoneLabel.text = self.dic[@"Username"];
//        self.orderLabel.text = orderStr;
//    }

  */
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号码：%@",self.dic[@"Username"]];
    self.orderLabel.text = [NSString stringWithFormat:@"消费单号：%@",self.dic[@"Paymentno"]];
    [self.orderLabel sizeToFit];
    
    ConsumptionType type = ((ConsumptionType)[self.dic[@"Status"] intValue]);
    
    switch (type) {
        case ConsumptionSuccessType:
        {
            self.refundButton.hidden = NO;
            self.refundButton.enabled = YES;
            self.refundButton.layer.borderColor = [WJMainColor CGColor];
        }
            break;
        case ConsumptionRefundType:
        {
            self.refundButton.hidden = NO;
            self.refundButton.enabled = NO;
            self.refundButton.layer.borderColor = [WJColorDardGray9 CGColor];
        }
            break;
        default:
            self.refundButton.hidden = YES;
            break;
    }
    
    NSString * priceString = [NSString stringWithFormat:@"消费金额：¥%@",[WJUtilityMethod floatNumberForMoneyFomatter:[self.dic[@"Amount"] floatValue]]];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont16,
                                             NSForegroundColorAttributeName : WJColorDardGray3,
                                             };
    
    NSDictionary *attributesForLastWord = @{
                                             NSFontAttributeName : WJFont16,
                                             NSForegroundColorAttributeName : [WJUtilityMethod colorWithHexColorString:@"ff4400"],
                                             };
    
    [attributedString setAttributes:attributesForFirstWord range:NSMakeRange(0, 5)];
    [attributedString setAttributes:attributesForLastWord range:NSMakeRange(6, MAX(0, priceString.length-6))];
    self.priceLabel.attributedText = attributedString;
    
}

- (void)withdrawAciotn:(UIButton *)button
{
    NSLog(@"%s",__func__);
    
    NSInteger index = self.tag - 10000;
    if ([self.delegate respondsToSelector:@selector(withdrawIndex:)]) {
        [self.delegate withdrawIndex:index];
    }
}

- (UIColor *)colorWithStatus:(int)status
{
    UIColor * color;
    switch (status) {
        case 10://未支付
        {
            color = [UIColor grayColor];
        }
            break;
        case 30://支付成功
        {
            color = [UIColor redColor];
        }
            break;
        case 40://支付失败
        {
            color = [UIColor greenColor];
        }
            break;
        default:
            break;
    }
    return color;
}

- (NSString *)stringWithStatus:(ConsumptionType)type
{
    NSString * string = @"";

    switch (type) {
        case ConsumptionWaitPayType:
            string = @"未支付";
            break;
        case ConsumptionSuccessType:
            string = @"成功消费";
            break;
        case ConsumptionRefundType:
            string = @"已经退款";
            break;
        case ConsumptionCloseType:
            string = @"冲正关闭";
            break;
        case ConsumptionOrderCloseType:
            string = @"订单关闭";
            break;
        default:
            break;
    }
    return string;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
