//
//  MaxCardViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "MaxCardViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Configure.h"
#import "WJPayViewController.h"
#import "CBScanClient.h"
#import "MBProgressHUD.h"


//设备宽/高/坐标
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kDeviceFrame    [UIScreen mainScreen].bounds

#define kCameraWidth        (kReaderViewWidth)
#define kCameraHeight       (kCameraWidth)
#define kCameraLeft         (kScreenWidth - kReaderViewWidth)/2
#define kCameraTop          ALD(185)

static const float kLineMinY = kCameraTop;
static const float kLineMaxY = 385;
static const float kReaderViewWidth = kScreenWidth/3.0 *2;
static const float kReaderViewHeight = kScreenWidth/3.0 *2;
@interface MaxCardViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic,retain)UIImageView * line;
@property (nonatomic, strong)UIAlertView * alertView;
@property (nonatomic, strong)UILabel * labIntroudction;

@property (nonatomic, assign) BOOL     canShow;
@property (nonatomic, assign) BOOL     isFirstResult;
@property (nonatomic, assign) BOOL     haveViews;
//@property (nonatomic, strong) MBProgressHUD * progressHUD;
@property (nonatomic, strong)UIButton * backButton;
@property (nonatomic, assign)CGFloat    mindownViewY;

@end

@implementation MaxCardViewController
#pragma mark - Property
-(MBProgressHUD*) payAlertHUD
{
    if(!_payAlertHUD){
        _payAlertHUD=  [[MBProgressHUD alloc]init];
        _payAlertHUD.mode=MBProgressHUDModeCustomView;
        // _payAlertHUD.labelText = @"操作失败";
        _payAlertHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    }
    return _payAlertHUD;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(ALD(15), ALD(35), ALD(22), ALD(22))];
        [_backButton setImage:[UIImage imageNamed:@"back_write"] forState:UIControlStateNormal];
        
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (void)initWithMBprogressHUD
{
    [self.view addSubview:self.payAlertHUD];
}

- (void)showCustomDialog:(NSString *)msg
{
    _payAlertHUD.labelText = msg;
    [_payAlertHUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [_payAlertHUD removeFromSuperview];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
}





#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self setOverlayPickerView];
    
   // [self scanQRcode];
//    [self startSYQRCodeReading];
    [self initWithMBprogressHUD];
    
//    UIDevice * device = [UIDevice currentDevice];
//    if ([device.systemVersion floatValue] >= 8) {
//        self.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前未开启相机权限，请前去设置中开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
//    }else
//    {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前未开启相机权限，请前去设置中开启" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    }
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appHasGoneInForeground)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appHasGoneBcakground)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//        [self showHUDWithText:@"您当前未开启相机权限，请前去设置中开启"];
    if (self.alertView) {
        [self.alertView show];
    }
        
    }else
    {
        if(self.preview)
        {
            [self.preview removeFromSuperlayer];
        }
        [self setupCamera];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appHasGoneInForeground)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appHasGoneBcakground)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneBcakground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%s",__func__);
    [super viewDidDisappear:animated];
    self.alertView = nil;
    if(self.preview)
    {
        [self.preview removeFromSuperlayer];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void) dealloc
{
    NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    if (_session) {
        [_session stopRunning];
        _session = nil;
    }
    
    if (_preview) {
        _preview = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    [timer invalidate];
    
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - View Controller Flow
#pragma mark - Action

- (void)appHasGoneInForeground
{
    [self viewWillAppear:YES];
}

- (void)appHasGoneBcakground
{
    [self viewWillDisappear:YES];
}

- (void)showText:(NSString *)text
{
    if (self.canShow) {
        [self showHUDWithText:text];
        self.canShow = NO;
        [self performSelector:@selector(canShowText) withObject:nil afterDelay:3.0];
    }
}

- (void)canShowText
{
    self.canShow = YES;
}

- (void)initTitleView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, 64)];
    bgView.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    //    [self.view addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 40) / 2.0, 28, 40, 20)];
    //scanCropView.image=[UIImage imageNamed:@""];
    //titleLab.layer.borderColor = [UIColor greenColor].CGColor;
    //titleLab.layer.borderWidth = 2.0;
    //titleLab.backgroundColor = [UIColor colorWithRed:62.0/255 green:199.0/255 blue:153.0/255 alpha:1.0];
    titleLab.text = @"扫描";
    titleLab.shadowColor = [UIColor lightGrayColor];
    titleLab.shadowOffset = CGSizeMake(0, - 1);
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:titleLab];
}

- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 28, 60, 24)];
    [btn setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)initUI
{
//    [self leftNavigationItem];
    //    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    //    scanButton.frame = CGRectMake(100, 420, 120, 40);
    //    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:scanButton];
    self.title = @"扫一扫";
    
    self.labIntroudction = [[UILabel alloc] initWithFrame:CGRectMake(kCameraLeft, ALD(40), kCameraWidth, ALD(50))];
    self.labIntroudction.backgroundColor = [UIColor clearColor];
    self.labIntroudction.numberOfLines = 2;
    self.labIntroudction.font = [UIFont systemFontOfSize:16.0];
    self.labIntroudction.textAlignment = NSTextAlignmentCenter;
    self.labIntroudction.textColor=[UIColor whiteColor];
    self.labIntroudction.text=@"将二维码置于框内\n即可自动扫描";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 2)];
    _line.image = [UIImage imageNamed:@"QRCodeLine"];
//    [imageView addSubview:_line];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
}

- (void)leftNavigationItem
{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backAction
{
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
}


- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / KScreenHeight, ((kScreenWidth - asize.width) / 2.0) / kScreenWidth, asize.height / kScreenHeight, asize.width / kScreenHeight);
}

- (void)setOverlayPickerView
{
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kReaderViewWidth) / 2.0, kLineMinY, kReaderViewWidth, 12 * kReaderViewWidth / 320.0)];
    [_line setImage:[UIImage imageNamed:@"QRCodeLine"]];
    [self.view addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kLineMinY)];//80
    upView.userInteractionEnabled = NO;
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kScreenWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.userInteractionEnabled = NO;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.userInteractionEnabled = NO;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = KScreenHeight - CGRectGetMaxY(leftView.frame);
    self.mindownViewY = CGRectGetMaxY(leftView.frame);
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftView.frame), kScreenWidth, space_h)];
    downView.alpha = 0.3;
    downView.userInteractionEnabled = NO;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"QRCodeTopLeft"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodeTopRight"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomLeft"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"QRCodebottomRight"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码置于框内,即可自动扫描";
//    [self.view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,self.view.frame.size.width - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
    scanCropView.layer.borderColor = WJMainColor.CGColor;
    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
    
    [self.view addSubview:self.labIntroudction];
    [self.view addSubview:self.backButton];
}

#pragma mark - Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
//        [self stopSYQRCodeReading];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        NSLog(@"%@",metadataObject.stringValue);
        NSString * qrString = metadataObject.stringValue;
        
        NSString * subStr = [qrString substringToIndex:2];
        if ( (![subStr isEqualToString:@"86"]) || (qrString.length != 18) ) {
            
            [self showText:@"无效二维码，请出示万集卡付款码"];
            return;
        }
        if (self.isFirstResult) {
            WJPayViewController * payVC = [[WJPayViewController alloc] init];
            payVC.payCode = qrString;
            [self.navigationController pushViewController:payVC animated:YES];
            self.isFirstResult = NO;
        }

    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 1:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
            break;
        case 0:
        {
            [self backAction];
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
//    
//    [self.session startRunning];
//    MaxCardViewController * weakSelf = self;
//    NSLog(@"start reading");
    // wzj ***********
//    self.SYQRCodeSuncessBlock =^(MaxCardViewController *aqrvc,NSString *qrString){
//        NSLog(@"\n----------%@\n",qrString);
//
//        NSString * subStr = [qrString substringToIndex:2];
//        if ( (![subStr isEqualToString:@"86"]) || (qrString.length != 18) )
//        {
//            [weakSelf showCustomDialog:@"无效二维码，请出示万集卡付款码"];
//            return;
//        }
//        
//        WJPayViewController * payVC =  [[WJPayViewController alloc]init];
//        payVC.payCode = qrString;
//        [weakSelf.navigationController pushViewController:payVC animated:YES];
//
//    };

}
//
//- (void)stopSYQRCodeReading
//{
//    if (timer)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
//    
//    [self.session stopRunning];
//    
//    NSLog(@"stop reading");
//}

//取消扫描
//- (void)cancleSYQRCodeReading
//{
////    [self stopSYQRCodeReading];
//    
//    if (self.SYQRCodeCancleBlock)
//    {
//        self.SYQRCodeCancleBlock(self);
//    }
//    NSLog(@"cancle reading");
//}
#pragma mark -
#pragma mark 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= kLineMinY)
        {
            if (_line.frame.origin.y >= self.mindownViewY - 12)
            {
                frame.origin.y = kLineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

- (void)setupCamera
{
    self.canShow = YES;
    self.isFirstResult = YES;
    _session = nil;
    _preview = nil;
    _output = nil;
    _input = nil;
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //0 ~ 1
    [_output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kCameraWidth, kCameraHeight)]];
    //y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
//    _output.rectOfInterest = CGRectMake (kCameraWidth * 1.0 / KScreenHeight,kCameraLeft * 1.0/kScreenWidth, kCameraHeight * 1.0/KScreenHeight ,kCameraWidth * 1.0 /kScreenWidth);
    _output.rectOfInterest = CGRectMake (kCameraTop * 1.0 / KScreenHeight,kCameraLeft * 1.0/kScreenWidth, kCameraHeight * 1.0/KScreenHeight ,kCameraWidth * 1.0 /kScreenWidth);
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _preview.frame =CGRectMake(ALD(20),ALD(110),ALD(280),ALD(280));
    
    //    [_preview setFrame:CGRectMake(20, ALD(110), kScreenWidth - 40, kScreenWidth - 40)];
    _preview.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    if (!self.haveViews) {
        [self addAlphaViewWithAlpha:0.5];
        self.haveViews = YES;
    }
//    // Start
    [_session startRunning];
}

- (void)addAlphaViewWithAlpha:(float) alpha
{
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, 0, kScreenWidth, kCameraTop) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, kCameraTop, kCameraLeft, kCameraHeight) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(kCameraLeft + kReaderViewWidth, kCameraTop, kScreenWidth - (kCameraWidth + kCameraLeft), kCameraHeight) alpha:alpha]];
    [self.view addSubview:[self createViewWithFrame:CGRectMake(0, kCameraHeight + kCameraTop, kScreenWidth, kScreenHeight -(kCameraTop + kCameraHeight)) alpha:alpha]];
}

- (UIView *)createViewWithFrame:(CGRect)frame  alpha:(float)alpha
{
    UIView * aView = [[UIView alloc] initWithFrame:frame];
    aView.userInteractionEnabled = NO;
    aView.backgroundColor = [UIColor blackColor];
    aView.alpha = alpha;
    
    return aView;
}
//- (MBProgressHUD *)progressHUD
//{
//    if (nil == _progressHUD) {
//        
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
