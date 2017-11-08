//
//  WJTailorPictureViewController.m
//  CardsBusiness
//
//  Created by 林有亮 on 16/2/14.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJTailorPictureViewController.h"
#import "WJAssetModel.h"
#import "WJAssetLibraryManager.h"
#import "WJShopPhotoesViewController.h"
#import "CBImageClient.h"

#define kMaxSize        3.0
#define kCurrntHeight   ALD(235)

@interface WJTailorPictureViewController ()<UIGestureRecognizerDelegate>
{
    BOOL    isEdit;
    UIView * lineX1;
    UIView * lineX2;
    UIView * lineY1;
    UIView * lineY2;
}
@property (nonatomic, strong) UIImage       * cutImage;
@property (nonatomic, strong) UIImageView   * cutImageView;
@property (nonatomic, strong) UIView        * clearView;
@property (nonatomic, assign) CGRect        imageFrame;
@property (nonatomic, strong) UIButton      *saveButton;

@end

@implementation WJTailorPictureViewController


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.cutImageView];
    NSLog(@"%@",[NSValue valueWithCGPoint:p]);
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@",self.assetModel);
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)setUI
{
    self.title = @"裁剪照片";

    self.cutImageView = [[UIImageView alloc] init];
    self.cutImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.cutImageView];
    [self addGestureRecognizer];
    
    UIView * componentView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrntHeight, kScreenWidth, KScreenHeight - kCurrntHeight)];
    componentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
    [self.view addSubview:componentView];
    
    
    lineX1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrntHeight / 3, KScreenHeight, ALD(1))];
    lineX1.backgroundColor = WJColorWhite;
    lineX2 = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrntHeight / 3 * 2, KScreenHeight, ALD(1))];
    lineX2.backgroundColor = WJColorWhite;
    lineY1 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 3, 0, ALD(1), kCurrntHeight)];
    lineY1.backgroundColor = WJColorWhite;
    lineY2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 3 * 2, 0, ALD(1), kCurrntHeight)];
    lineY2.backgroundColor = WJColorWhite;
    
    [self.view addSubview:lineX1];
    [self.view addSubview:lineX2];
    [self.view addSubview:lineY1];
    [self.view addSubview:lineY2];

    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setFrame:CGRectMake(ALD(226), ALD(139), ALD(60), ALD(60))];
//    saveButton.backgroundColor = [WJUtilityMethod randomColor];
    [self.saveButton setImage:[UIImage imageNamed:@"savePhotoes"] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setFrame:CGRectMake(ALD(86), ALD(139), ALD(60), ALD(60))];
    [cancleButton setImage:[UIImage imageNamed:@"canclePhotoes"] forState:UIControlStateNormal];
//    cancleButton.backgroundColor = [WJUtilityMethod randomColor];
    [cancleButton addTarget:self action:@selector(cancleImage) forControlEvents:UIControlEventTouchUpInside];
    
    [componentView addSubview:cancleButton];
    [componentView addSubview:self.saveButton];
    
    [self refreshImage];
    
}


- (void)saveImage
{
    NSLog(@"%s",__func__);
    
    [self screenShot];
}

- (void)cancleImage
{
    NSLog(@"%s",__func__);
    [self backAction];
}

- (void)refreshImage
{
    
    if(self.assetModel.needSelectImage)
    {
        UIImage * image = self.assetModel.image;
        [self.cutImageView setFrame:CGRectMake(0, 0,kScreenWidth,kScreenWidth * image.size.height * 1.0 /image.size.width * 1.0)];
        self.cutImageView.image = self.assetModel.image;
        self.imageFrame = self.cutImageView.frame;
    }else
    {
        __weak WJTailorPictureViewController * weakSelf = self;
        
        [[WJAssetLibraryManager alloc] imageByAssetURL:self.assetModel.assetUrl callback:^(UIImage *image, NSError *error) {
            NSLog(@"%@",image);
            [weakSelf.cutImageView setFrame:CGRectMake(0, 0,kScreenWidth,kScreenWidth * image.size.height * 1.0 /image.size.width * 1.0)];
            weakSelf.cutImageView.image = image;
            weakSelf.imageFrame = weakSelf.cutImageView.frame;
            //        weakSelf.cutImageView.backgroundColor = [WJUtilityMethod randomColor];
        }];
    }
}


- (void)addGestureRecognizer
{
    //拖动
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    [self.cutImageView addGestureRecognizer:pan];
    //捏合
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinch.delegate = self;
    [self.cutImageView addGestureRecognizer:pinch];
}


- (void)panAction:(UIPanGestureRecognizer *)pan
{
//    NSLog(@"%s---%@",__func__,pan);
//    if (pan.state != UIGestureRecognizerStateEnded && pan.state != UIGestureRecognizerStateFailed) {
//        CGPoint location = [pan locationInView:pan.view.superview];
//        pan.view.center = location;
//    }
    CGPoint center = pan.view.center;
    CGFloat cornerRadius = pan.view.frame.size.width / 2;
    CGFloat cornerHeight = pan.view.frame.size.height / 2;
    CGPoint translation = [pan translationInView:self.view];
//    NSLog(@"%@", NSStringFromCGPoint(translation));
    pan.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [pan velocityInView:self.view];
        NSLog(@"point = %@",[NSValue valueWithCGPoint:velocity]);

        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor), center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
//        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),self.view.bounds.size.width - cornerRadius);
//        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),self.view.bounds.size.height - cornerRadius);
        
        if (finalPoint.x > cornerRadius) {
            finalPoint.x = cornerRadius;
        } else if (finalPoint.x < self.view.bounds.size.width - cornerRadius)
        {
            finalPoint.x = self.view.bounds.size.width - cornerRadius;
        }
        
        if (finalPoint.y > cornerHeight) {
            finalPoint.y = cornerHeight;
        } else if (finalPoint.y < kCurrntHeight - cornerHeight)
        {
            finalPoint.y = kCurrntHeight - cornerHeight;
        }
        
//        finalPoint.x = MIN(MAX(center.x, 0),self.view.bounds.size.width - center.x);
//        finalPoint.y = MIN(MAX(center.y, 0),self.view.bounds.size.height - center.y);
//        NSLog(@"point = %@",[NSValue valueWithCGPoint:finalPoint]);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                                    pan.view.center = finalPoint;
                                }
            completion:nil];
  }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    
     CGPoint p = [pinch locationInView:self.cutImageView];
    
    [self setAnchorPoint:CGPointMake(p.x * 1.0 / pinch.view.frame.size.width, p.y * 1.0 / pinch.view.frame.size.height) forView:self.cutImageView];
    
    CGFloat scale = pinch.scale;
//    CGRect rect = pinch.view.frame;
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
//    pinch.view.transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
//    pinch.view.frame = CGRectMake(0, 0, rect.size.width * scale, rect.size.he
    [self InspectionPinch:pinch];
    [self setDefaultAnchorPointForView:self.cutImageView];
    pinch.scale = 1.0;
}


- (void)InspectionPinch:(UIPinchGestureRecognizer *)pinch
{
    CGRect frame = pinch.view.frame;
    
    if (frame.size.width < kScreenWidth) {
        CGAffineTransform  transform;
        transform = CGAffineTransformScale(self.cutImageView.transform,kScreenWidth * 1.0 / frame.size.width , self.imageFrame.size.height * 1.0 /frame.size.height);
        [UIView beginAnimations:@"scale" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
//        [self.cutImageView setFrame:self.imageFrame];
        [self.cutImageView setTransform:transform];
        [UIView commitAnimations];
        
        if (pinch.view.frame.size.width/2 <= self.view.bounds.size.width) {
            [UIView animateWithDuration:.2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [pinch.view setFrame:CGRectMake(0, 0, pinch.view.frame.size.width, pinch.view.frame.size.height)];
                             }
                             completion:nil];
        }
    } else if (frame.size.width > kScreenWidth * kMaxSize)
    {
        CGAffineTransform  transform;
        transform = CGAffineTransformScale(self.cutImageView.transform,kScreenWidth * 1.0 *kMaxSize/ frame.size.width , self.imageFrame.size.height * 1.0 *kMaxSize /frame.size.height);
        [UIView beginAnimations:@"scale" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
//        [self.cutImageView setFrame:CGRectMake(0, 0, self.imageFrame.size.width * 1.0 * kMaxSize, self.imageFrame.size.height * 1.0 * kMaxSize)];
        [self.cutImageView setTransform:transform];
        [UIView commitAnimations];
    }
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)setDefaultAnchorPointForView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:self.cutImageView];
}

- (void)uploadImage:(UIImage *)image
{
    self.saveButton.userInteractionEnabled = NO;
    __weak WJTailorPictureViewController * weakSelf = self;
    
    [[CBImageClient shareRESTClient] addImage:image type:30 finished:^(BOOL success, NSString *message) {
        if (success) {
            
            [weakSelf backAction];
            weakSelf.saveButton.userInteractionEnabled = YES;
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"上传图片失败,请稍后再试"];
            weakSelf.saveButton.userInteractionEnabled = YES;
        }
    }];
}

- (void)hiddenAllLine
{
    lineX1.hidden = YES;
    lineX2.hidden = YES;
    lineY1.hidden = YES;
    lineY2.hidden = YES;
}

- (void)showAllLine
{
    lineX1.hidden = NO;
    lineX2.hidden = NO;
    lineY1.hidden = NO;
    lineY2.hidden = NO;
}

//截图
-(void)screenShot{
    //隐藏线条
    [self hiddenAllLine];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kCurrntHeight), YES, 1);
    
    //设置截屏大小
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    
    CGRect rect = CGRectMake(0, 0, kScreenWidth, kCurrntHeight);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    //截图图片
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
//    //压缩
//    NSData * imageData = UIImageJPEGRepresentation(sendImage,.4);
//    
//    NSUInteger lengtho = [UIImageJPEGRepresentation(sendImage,1) length]/1024;
//    
//    NSUInteger length = [imageData length]/1024;
//    //压缩后图片
//    UIImage * resultImage = [UIImage imageWithData:imageData];
    
//    NSLog(@"0-%@\n 1-%@",[NSValue valueWithCGSize:sendImage.size],[NSValue valueWithCGSize:resultImage.size]);
    
    //显示线条
    [self showAllLine];
    
    [self uploadImage:sendImage];
    
    //以下为图片保存代码 (保存本地的为未压缩的图片)
    
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
//    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *pictureName= @"screenShow";
//    
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
//    
//    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    
//    CGImageRelease(imageRefRect);
    
    
    
    //从手机本地加载图片
    
//    UIImage *bgImage2 = [[UIImage alloc]initWithContentsOfFile:savedImagePath];
    
    
    
}

- (void)backAction
{
    NSArray * controllers = self.navigationController.viewControllers;
    
    for(int i = 0; i < [controllers count]; i++)
    {
        id controller = [controllers objectAtIndex:i];
        if ([controller isKindOfClass:[[WJShopPhotoesViewController alloc]class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        
    }
    
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
