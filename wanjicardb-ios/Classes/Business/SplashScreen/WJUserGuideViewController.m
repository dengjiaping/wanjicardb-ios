//
//  WJUserGuideViewController.m
//  WanJiCard
//
//  Created by wangzhangjie on 15/9/18.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJUserGuideViewController.h"
#import "AppDelegate.h"


@interface WJUserGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger globalNum;

@property(strong,nonatomic)  UIScrollView *scrollView;
@property(strong,nonatomic) UIPageControl * pageControl;
@end



@implementation WJUserGuideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initGuide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark Action

- (void)firstpressed {
    [(AppDelegate *)[UIApplication sharedApplication].delegate changeRootViewController];
}


- (void)initGuide
{
    
    // 滚动view
  //  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollView.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth*4, 0)];
    [self.scrollView setContentMode:UIViewContentModeCenter];
    self.scrollView.backgroundColor= [UIColor whiteColor];
    [self.scrollView setPagingEnabled:YES];  //视图整页显示
    self.scrollView.userInteractionEnabled =YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator =NO;
    
    for(int i = 0; i< 4;i++)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, ALD(0), kScreenWidth, kScreenHeight)];
        
        if (kScreenWidth == 320) {
            [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"userguide480_%d",i]]];
        } else
        {
            [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"userguide%d",i]]];
        }
        
//        imageview.contentMode  = UIViewContentModeCenter;
        
//        if (i == 3) {
//            imageview.userInteractionEnabled = YES;
//            //导入通讯录－label
//            UILabel * desLabel = [[UILabel alloc]init];
//            if (kScreenHeight<=480) {
//               // 适配4s机型
//                desLabel.frame = CGRectMake(kScreenWidth*3+kScreenWidth/2-20, kScreenHeight*0.92, kScreenWidth/2, 30);
//            }else
//            {
//                
//                 desLabel.frame = CGRectMake(kScreenWidth*3+kScreenWidth/2-20, kScreenHeight*0.892, kScreenWidth/2, 30);
//            }
//            //暂时移除
//            // [desLabel setText:@"导入通讯录好友"];
//            [desLabel setFont:[UIFont systemFontOfSize:12]];
//            [desLabel setTextAlignment:NSTextAlignmentLeft];
//            [self.scrollView addSubview:desLabel];
//        }
        
        [self.scrollView addSubview:imageview];
    }
    
    //立即体验－按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(kScreenWidth*3.5 - ALD(150)/2 , kScreenHeight - ALD(90), ALD(150) , ALD(40))];
    [button setBackgroundColor:WJMainColor];
    button.layer.cornerRadius = ALD(20);
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    //导入通讯录－label
    //     UILabel * desLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-60, kScreenHeight*0.77, kScreenWidth-200, 40)];
    //     [desLabel setText:@"导入通讯录好友"];
    //     [desLabel setFont:[UIFont systemFontOfSize:12]];
    //     [desLabel setTextAlignment:NSTextAlignmentCenter];
    //     [imageView3 addSubview:desLabel]
    // xx  - -scrollView
   // [scrollView addSubview:self.checkboxButton];
    
    
    
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.pageControl];
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView*)scrollView

{
   
    [self.pageControl setCurrentPage:fabs(scrollView.contentOffset.x/self.view.frame.size.width)];

}


#pragma mark getter and setter

// 暂时移除复选框
//-(UIButton *)checkboxButton
//{
//    if (nil==_checkboxButton) {
//        _checkboxButton =[[UIButton alloc]init];
//        if (kScreenHeight<=480) {
//            // 适配4s机型
//            _checkboxButton.frame = CGRectMake(kScreenWidth*3+kScreenWidth/2-50, kScreenHeight*0.93, 20, 20);
//        }else
//        {
//            _checkboxButton.frame =CGRectMake(kScreenWidth*3+kScreenWidth/2-50, kScreenHeight*0.9, 20, 20);
//        }
//        
//        [_checkboxButton setBackgroundImage:[UIImage imageNamed:@"checkbox1"] forState:UIControlStateNormal];
//        
//        [_checkboxButton addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    return _checkboxButton;
//}

-(UIPageControl *)pageControl
{
    if (nil==_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight-40,kScreenWidth, 20)];
      
        _pageControl.numberOfPages =4;
        _pageControl.currentPage=0;
        _pageControl.currentPageIndicatorTintColor = WJMainColor;
        _pageControl.pageIndicatorTintColor = [WJUtilityMethod colorWithHexColorString:@"afd6ff"];
    }
    return _pageControl;
}

-(UIScrollView *)scrollView
{
    if (nil ==_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate= self;
    }
    return _scrollView;
}
@end
