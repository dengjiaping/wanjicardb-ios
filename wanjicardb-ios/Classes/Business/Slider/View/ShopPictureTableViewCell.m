//
//  ShopPictureTableViewCell.m
//  CardsBusiness
//
//  Created by Lynn on 15/8/14.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "ShopPictureTableViewCell.h"
#import "Configure.h"
#import "SJAvatarBrowser.h"
#import "UIImageView+AFNetworking.h"

#define kLeftGap    15
#define kImageWidth (kScreenWidth - kLeftGap * 3)/2
#define kHeight     100

@implementation ShopPictureTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pictureListView = [[UIView alloc] initWithFrame:CGRectMake(kLeftGap, 0, kScreenWidth - kLeftGap * 2,0)];
        self.pictureList = [NSArray array];
        NSLog(@"%lu",(unsigned long)[self.pictureList count]);
        
        [self.contentView addSubview:self.pictureListView];
    }
    return self;
}

- (void)setPictureList:(NSArray *)pictureList
{
    _pictureList = [NSMutableArray arrayWithArray:pictureList];
    NSArray * viewArray = [self.pictureListView subviews];
    [viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    for(int i = 0; i < [self.pictureList count]; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageView.tag = self.index * 10000 + i;
        [imageView addGestureRecognizer:tap];
        imageView.backgroundColor = [UIHelper colorWithHexColorString:@"f4f5f7"];

        NSLog(@"tag =  %ld",(long)imageView.tag);
        [self.pictureListView addSubview:imageView];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        NSDictionary * dic = [pictureList objectAtIndex:i];
        
        switch ([dic[@"Type"] intValue]) {
            case 10:
            case 30:
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"Url"]] placeholderImage:[UIImage imageNamed:@"PictureDefault"]];

                [imageView addGestureRecognizer:longPress];
            }
                break;
            case -10:
            case -30:
            {
                 [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"Url"]] placeholderImage:[UIImage imageNamed:@"PictureAdd"]];
            }
            default:
                break;
        }
        NSLog(@"%@",dic[@"Url"]);
    }
    [self layoutSubviews];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"%@",tap);
    
    int index = (int)tap.view.tag % 10000;
    
    NSDictionary * dic = [self.pictureList objectAtIndex:index];
    switch ([dic[@"Type"] intValue]) {
        case 10:
        case 30:
        {
            [SJAvatarBrowser showImage:((UIImageView *)tap.view)];
//            [self.pictureDelegate tapImage:((UIImageView *)tap.view).image];
        }
            break;
        case -10:
        case -30:
        {
            [self.pictureDelegate addImage:[dic[@"Type"] intValue]];
        }
            break;
        default:
            break;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        int index = (int)longPress.view.tag % 10000;
        NSDictionary * dic = [self.pictureList objectAtIndex:index];
        
        [self.pictureDelegate deleteImage:dic[@"Id"]];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.pictureListView setFrame:CGRectMake(kLeftGap, 0, kScreenWidth - kLeftGap * 2, [ShopPictureTableViewCell heightWithPictures:self.pictureList])];
    
    for (int i = 0; i< [self.pictureList count]; i++) {
        UIImageView * imageView = (UIImageView *)[self.pictureListView viewWithTag:self.index * 10000 +i];
        [imageView setFrame:CGRectMake((kScreenWidth/2 - kLeftGap * 0.5) * (i%2) ,
                                      kLeftGap + (kHeight + kLeftGap) * (i/2),
                                      kImageWidth, kHeight)];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithPictures:(NSArray *)pictures
{
    CGFloat count = [pictures count];
    int height = 0;
    
    height = (int)ceil(count/2.0) * (kHeight + kLeftGap) ;
    NSLog(@"%d",(int)[pictures count]);

    return height;
}


@end
