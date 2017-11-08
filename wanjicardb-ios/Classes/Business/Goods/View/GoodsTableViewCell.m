//
//  GoodsTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/11.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "Configure.h"

#define kGreenButtonColor   [UIHelper colorWithHexColorString:@"4cbc31"]
#define kRedButtonColor     [UIHelper colorWithHexColorString:@"ed3647"]
#define kGrayButtonColor    [UIHelper colorWithHexColorString:@"d0d0d0"]

#define kLeftGap            12
#define kTopGap             10
#define kButtonWidth        90

@interface GoodsTableViewCell()
{
    UIView * backView;
    UIView * line;
}

@property (nonatomic, strong) UIImageView   *cardImageView;
@property (nonatomic, strong) UIImageView   *cardIconImageView;
@property (nonatomic, strong) UILabel       *cardNameLabel;
@property (nonatomic, strong) UILabel       *merNameLabel;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *faceValueLabel;
@property (nonatomic, strong) UILabel       *saleCountLabel;
@property (nonatomic, strong) UIButton      *operationButton;

@end

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    Cover = "http://ca.wjika.com/Assets/img/application/productcard/P2B0Zo4PKi.jpg";
//    Facevalue = 1000;
//    Id = 49;
//    Name = "F\U6e38\U620f\U4e00\U5361\U901a";
//    SaledNum = 219;
//    Saleprice = 980;
//    Status = 60;
    
//    @property (nonatomic, strong) UIImageView   *cardImageView;
//    @property (nonatomic, strong) UIImageView   *cardIconImageView;
//    @property (nonatomic, strong) UILabel       *cardNameLabel;7     
//    @property (nonatomic, strong) UILabel       *merNameLabel;
//    @property (nonatomic, strong) UILabel       *titleLabel;
//    @property (nonatomic, strong) UILabel       *faceValueLabel;
//    @property (nonatomic, strong) UILabel       *saleCountLabel;
//    @property (nonatomic, strong) UIButton      *operationButton;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ALD(95))];
        backView.backgroundColor = [UIColor whiteColor];
//        backView.layer.borderWidth = 1;
//        backView.layer.borderColor = [[UIHelper colorWithHexColorString:@"e0e0e0"] CGColor];
        
        _cardImageView = [[UIImageView alloc] init];
        [_cardImageView setFrame:CGRectMake(ALD(15), ALD(15), ALD(110), ALD(65))];
        _cardImageView.layer.cornerRadius = 5;
        
        _cardIconImageView = [[UIImageView alloc] init];
        [_cardIconImageView setFrame:CGRectMake(ALD(5), ALD(5), ALD(20), ALD(12))];
        
        _cardNameLabel = [[UILabel alloc] init];
        [_cardNameLabel setFrame:CGRectMake(CGRectGetMaxX(_cardIconImageView.frame) + ALD(5), CGRectGetMinY(_cardIconImageView.frame) + ALD(1), ALD(75), ALD(10))];
        _cardNameLabel.textColor = WJColorWhite;
        _cardNameLabel.font = [UIFont systemFontOfSize:6];
        
        _merNameLabel = [[UILabel alloc] init];
        [_merNameLabel setFrame:CGRectMake(ALD(5), ALD(50), ALD(99), ALD(10))];
        _merNameLabel.textColor = WJColorWhite;
        _merNameLabel.font = [UIFont systemFontOfSize:5];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(CGRectGetMaxX(_cardImageView.frame) + ALD(15), ALD(15), kScreenWidth - ALD(154), ALD(23))];
        _titleLabel.textColor = WJColorDardGray3;
        _titleLabel.font = WJFont16;
        
        _faceValueLabel = [[UILabel alloc] init];
        [_faceValueLabel setFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame)/2, ALD(22))];
        _faceValueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"ff4400"];
        _faceValueLabel.font = WJFont15;
        
        _saleCountLabel = [[UILabel alloc] init];
        [_saleCountLabel setFrame:CGRectMake(CGRectGetMinX(_faceValueLabel.frame), CGRectGetMaxY(_faceValueLabel.frame), CGRectGetWidth(_faceValueLabel.frame), CGRectGetHeight(_faceValueLabel.frame))];
        _saleCountLabel.textColor = WJColorDardGray9;
        _saleCountLabel.font = WJFont10;
        
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_operationButton setFrame:CGRectMake(kScreenWidth - ALD(105), ALD(50), ALD(90), ALD(30))];
        _operationButton.layer.borderWidth = 1;
        _operationButton.layer.borderColor = [WJMainColor CGColor];
        _operationButton.layer.cornerRadius = ALD(15);
        [_operationButton addTarget:self action:@selector(statusChange) forControlEvents:UIControlEventTouchUpInside];
        [_operationButton setTitleColor:WJMainColor forState:UIControlStateNormal];
        
        
        _operationButton.hidden = ![CBPassport isMain];

        [self.contentView addSubview:backView];
        
        [backView addSubview:_cardImageView];
        [_cardImageView addSubview:_cardIconImageView];
        [_cardImageView addSubview:_cardNameLabel];
        [_cardImageView addSubview:_merNameLabel];
        [backView addSubview:_titleLabel];
        [backView addSubview:_faceValueLabel];
        [backView addSubview:_saleCountLabel];
        [backView addSubview:_operationButton];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
//        _cardNameLabel.backgroundColor = [WJUtilityMethod randomColor];
//        _cardIconImageView.backgroundColor = [WJUtilityMethod randomColor];
//        _cardImageView.backgroundColor = [WJUtilityMethod randomColor];
//        _merNameLabel.backgroundColor = [WJUtilityMethod randomColor];
//        _titleLabel.backgroundColor = [WJUtilityMethod randomColor];
//        _faceValueLabel.backgroundColor = [WJUtilityMethod randomColor];
//        _saleCountLabel.backgroundColor = [WJUtilityMethod randomColor];
//        _operationButton.backgroundColor = [WJUtilityMethod randomColor];
    }
    return self;
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    _cardImageView.image = [self cardBgImageByType:[dic[@"CType"] integerValue]];
    [_cardIconImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"Cover"]] placeholderImage:[UIImage imageNamed:@""]];
    
    _cardNameLabel.text = dic[@"Name"];
    
    _merNameLabel.text = [CBPassport shopName];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@面值%@元",dic[@"Name"],dic[@"Facevalue"]];
    
    _faceValueLabel.text = [NSString stringWithFormat:@"¥%@",[WJUtilityMethod floatNumberForMoneyFomatter:[dic[@"Saleprice"] floatValue]]];
    
    _saleCountLabel.text = [NSString stringWithFormat:@"已售：%@",dic[@"SaledNum"]];
    
    [_operationButton setTitle:[self stringWithStatus:[dic[@"Status"] intValue]] forState:UIControlStateNormal];
}

- (NSString *)stringWithStatus:(int)status
{
    NSString * str = @"";
    switch (status) {
        case 60:
        {
            str = @"下 架";
        }
            break;
        case 70:
        {
            str = @"上 架";
        }
            break;
               default:
            break;
    }
    return str;
}

- (NSString *)buttonTitleWithStatus:(int)status
{
    NSString * str = @"";
    switch (status) {
        case 60:
        {
            str = @"下架";
        }
            break;
        case 70:
        {
            str = @"上架";
        }
            break;
        default:
            break;
    }
    return str;
}

- (UIImage *)cardBgImageByType:(NSInteger)type{
//    if (type >= CardBgTypeInvalid) {
//        type = type/10-1;
//    }
    NSArray *imageNames = @[@"card_blue", @"card_green", @"card_orange", @"card_red"];
    return [UIImage imageNamed:imageNames[MIN(type, 3)]];
}

- (void)statusChange
{
    if([self.goodsDelegate respondsToSelector:@selector(goodsCell:status:index:)])
    {
        GoodsType goodsType = ([self.dic[@"Status"] intValue] == 60)?SaledGoods:SalingGoods;
        [self.goodsDelegate goodsCell:self status:goodsType index:(self.tag - 10000)];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
