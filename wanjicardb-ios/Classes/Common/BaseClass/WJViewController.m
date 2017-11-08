//
//  WJViewController.m
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#import "WJViewController.h"

@interface WJViewController (){
    MBProgressHUD *progressHUD;
}

@property (nonatomic, strong)UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation WJViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = WJColorViewBg;

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBarButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    [self navigationBarIsWhite:YES];
}

- (void)showLoadingView{
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hiddenLoadingView{
    [progressHUD hide:YES];
}

- (void)requestLoad{
    [self showLoadingView];
//    TestRequest;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [UMAnalyticsHelper beginLogPageView:@"viewController"];
    
}

// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [UMAnalyticsHelper endLogPageView:@"viewController"];
    
    
}

#pragma mark - APIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(APIBaseManager *)manager
{
}

- (void)managerCallAPIDidFailed:(APIBaseManager *)manager
{
}


#pragma mark - Logic Method

- (void)hiddenBackBarButtonItem{
    self.navigationItem.leftBarButtonItem = nil;
}


#pragma mark - Button Action

- (void)backBarButton:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScreenEdgePanGesture{
    
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGesture:)];
    //设置从什么边界滑入
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
    
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)recognizer{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        
        CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
        progress = MIN(1.0, MAX(0.0, progress));//把这个百分比限制在0~1之间
        
        //当手势刚刚开始，我们创建一个 UIPercentDrivenInteractiveTransition 对象
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (recognizer.state == UIGestureRecognizerStateChanged){
            //当手慢慢划入时，我们把总体手势划入的进度告诉 UIPercentDrivenInteractiveTransition 对象。
            [self.percentDrivenTransition updateInteractiveTransition:progress];
        }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
            //当手势结束，我们根据用户的手势进度来判断过渡是应该完成还是取消并相应的调用 finishInteractiveTransition 或者 cancelInteractiveTransition 方法.
            if (progress > 0.5) {
                [self.percentDrivenTransition finishInteractiveTransition];
            }else{
                [self.percentDrivenTransition cancelInteractiveTransition];
            }
        }
    }
}

- (void)navigationBarIsWhite:(BOOL)boolean
{
    if (!self.navigationController) {
        return;
    }
    
    if (boolean)
    {
        self.navigationController.navigationBar.barTintColor = WJColorWhite;
        //    self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                                                        NSForegroundColorAttributeName:WJColorBlack};
    }else
    {
        self.navigationController.navigationBar.barTintColor = WJColorNavigationBar;
        //    self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:WJFont18,
                                                                        NSForegroundColorAttributeName:WJColorWhite};
    }
}

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
