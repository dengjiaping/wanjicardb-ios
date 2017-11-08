//
//  WJMainTabbarViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/12/24.
//  Copyright © 2015年 Lynn. All rights reserved.
//

#import "WJMainTabbarViewController.h"
#import "WJMainViewController.h"
#import "WJMessageViewController.h"
#import "WJUserInfoViewController.h"
#import "WJNavigationController.h"

//#import "CBMain1ViewController.h"

@interface WJMainTabbarViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray * titleImageArray;
@property (nonatomic, strong) NSArray * titleImageSelectArray;
@property (nonatomic, strong) NSArray * titleTextArray;

@end

@implementation WJMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = @[ [[WJNavigationController alloc] initWithRootViewController:
                               [WJMainViewController new]],
                              [[WJNavigationController alloc] initWithRootViewController:
                               [WJMessageViewController new]],
                              [[WJNavigationController alloc] initWithRootViewController:
                               [WJUserInfoViewController new]]
                             ];
     self.tabBarController.tabBar.barTintColor = [WJUtilityMethod randomColor];
    [[self.viewControllers objectAtIndex:0] setTitle:WJTabbar0];
    [[self.viewControllers objectAtIndex:1] setTitle:WJTabbar1];
    [[self.viewControllers objectAtIndex:2] setTitle:WJTabbar2];
//    NSMutableArray * itemsArray  = [NSMutableArray array];
    self.tabBarController.delegate = self;
    
    for (int i = 0; i< [self.titleImageArray count]; i++)
    {
//        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:[self.titleTextArray objectAtIndex:i] image:[self.titleImageArray objectAtIndex:i] tag:0];
////        self.tabBarItem = item;
//        [itemsArray addObject:item];
        ((UIViewController *) [self.viewControllers objectAtIndex:i]).tabBarItem.image = [UIImage imageNamed:[self.titleImageArray objectAtIndex:i]];
        ((UIViewController *) [self.viewControllers objectAtIndex:i]).tabBarItem.selectedImage = [[UIImage imageNamed:[self.titleImageSelectArray objectAtIndex:i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
//    [self.tabBar setSelectedImageTintColor:[WJUtilityMethod randomColor]];
    [self tabbarAppearance];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    viewController.hidesBottomBarWhenPushed = NO;

    return YES;
}


- (NSArray *)titleImageArray
{
    if (!_titleImageArray) {
        _titleImageArray = @[@"home screen_default",@"dynamic_default",@"individual_default"];
    }
    return _titleImageArray;
}

- (NSArray *)titleImageSelectArray
{
    if (!_titleImageSelectArray) {
        _titleImageSelectArray = @[@"home screen_pressed",@"dynamic_pressed",@"individual_pressed"];
    }
    return _titleImageSelectArray;
}


- (NSArray *)titleTextArray
{
    if (!_titleTextArray) {
        _titleTextArray = @[WJTabbar0,WJTabbar1,WJTabbar2];
    }
    return _titleTextArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
