//
//  QuickMarkViewController.m
//  CardsBusiness
//
//  Created by Lynn on 15/7/30.
//  Copyright (c) 2015年 Lynn. All rights reserved.
//

#import "QuickMarkViewController.h"
#import "MBProgressHUD.h"
#import "UIHelper.h"
#import "Configure.h"
#import <ZXingObjC/ZXingObjC.h>

@interface QuickMarkViewController ()
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) UIImageView  * barCodeImageView;
@property (strong, nonatomic)   UILabel        *barCodeLabel;
@property (strong, nonatomic)  UIView         *barCodeContentView;

@property  int count;
//@property (strong, nonatomic)    UIProgressView *progressView;
@property (strong, nonatomic)          NSTimer        *progressTimer;
@property(strong,nonatomic) UILabel * progressLable;


@end

@implementation QuickMarkViewController

#pragma mark -lifecirty

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [_progressTimer invalidate];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#333945"];
    // Do any additional setup after loading the view.
    [self loadUI];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -action
-(void) loadUI
{
    [self loadQRCodeAndBarCode];
//    [self leftNavigationItem];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 100, 44)];
    titleL.centerX = kScreenWidth/2;
    titleL.text = @"二维码";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor whiteColor];
    titleL.font = WJFont18;
    [self.view addSubview:titleL];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(8, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void )loadDataFromService
{
    // 从接口获得数据
    CBScanClient * quickclient = [[CBScanClient alloc] init];
    [quickclient barCodeAndQRcode:kAppID finished:^(BOOL success, CBMetaData *metaData, NSString *message) {
        if(success)
        {
            NSLog(@"success===true");
            if (metaData) {
                NSLog(@"metaData.value!!!====%@",metaData.value);
                
                _barCodeLabel.text=[self formatCode:[NSString stringWithFormat:@"%@",metaData.value ]];
                //_barCodeLabel.text=@"121312313213";
                UIImage *img = [self makeQRCodeImage:[NSString stringWithFormat:@"%@",metaData.value ]];
                _QRcodeView.image=img;
                //QRCODE
                UIImage *img1 = nil;
                if (IOS8_LATER) {
                    img1 =[self generateBarCode:[NSString stringWithFormat:@"%@",metaData.value ]];
                }else{
                    img1 = [self generateBarCodeForIOSSeven:[NSString stringWithFormat:@"%@",metaData.value ]];
                }
                _barCodeImageView.image=img1;
                _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressChanged) userInfo:nil repeats:YES];
            }
        }
    }];
}
- (void)loadQRCodeAndBarCode
{
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    UIView * bkView = [[UIView alloc] initWithFrame:CGRectMake(ALD(20), ALD(90), kScreenWidth - ALD(40), ALD(400))];
    bkView.backgroundColor = WJColorWhite;
    [self.view addSubview:bkView];
    
    bkView.layer.cornerRadius = ALD(5);
    

    [self.view addSubview:self.QRcodeView];
//    [self.view addSubview:self.progressView];
    [self.view addSubview:self.barCodeContentView];
    [self.view addSubview:self.progressLable];

    [self loadDataFromService];
}

-(void) reloadQRCodeAndBarCode
{
//    [_progressView setProgress:0.0 animated:YES];
    _count = 0;
    [self loadDataFromService];
}

- (void)showCustomDialog:(NSString *)msg
{
    // _payAlertHUD.labelText=msg;
    [_payAlertHUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [_payAlertHUD removeFromSuperview];
        // QuickMarkViewController *quickVC= [[QuickMarkViewController alloc]init];
        [self.navigationController popToRootViewControllerAnimated:YES];
        // [self.navigationController pushViewController:quickVC animated:YES];
    }];
}

//- (void)leftNavigationItem
//{
//    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setFrame:CGRectMake(0, 0, 22, 22)];
//    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//    
//    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}

- (void)backBtn
{
//    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 改变进度条进度
- (void)progressChanged {
    
//    CGFloat step = 1.0 / 20.0;
    
//    [_progressView setProgress:_progressView.progress + step animated:YES];
    _count=_count+1;
    if(_count <= 20){
        _progressLable.text=[NSString stringWithFormat:@"%d%@",(int)(20-_count),@"秒后自动刷新"];
    }else{
        _count=20;
    }
    NSLog(@"=====%d s",_count);
//    NSLog(@"=====_progressView.progress:::%f",_progressView.progress);
//    if(_progressView.progress>=1.0)
    if(_count >= 20.0)
    {
        [_progressTimer invalidate];
        [self showCustomDialog:@"请稍候。。"];// un init lable
        
        [self reloadQRCodeAndBarCode];
    }
}

//*********
- (NSString *)formatCode:(NSString *)code {
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
        [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
        if (j == 3) {
            j = -1;
            [chars addObject:[NSNumber numberWithChar:' ']];
            [chars addObject:[NSNumber numberWithChar:' ']];
        }
    }
    
    int length = (int)[chars count];
    char str[length];
    for (int i = 0; i < length; i++) {
        str[i] = [chars[i] charValue];
    }
    
    NSString *temp = [NSString stringWithUTF8String:str];
    return temp;
}

- (UIImage *)generateBarCodeForIOSSeven:(NSString *)content{
    UIImage *resultImage = nil;
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:content
                                  format:kBarcodeFormatCode128
                                   width:300
                                  height:30
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        resultImage = [UIImage imageWithCGImage:image];
    }
    
    return resultImage;
}


- (UIImage *)generateBarCode:(NSString *) content
{
    CIFilter *filter_qrcode = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter_qrcode setDefaults];
    
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter_qrcode setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter_qrcode outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    //大小控制
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    //颜色控制30-191-109
    resized = [self imageBlackToTransparent:resized withRed:0 andGreen:0 andBlue:0];
    
    CGImageRelease(cgImage);
    return resized;
    
}
//**********wzj ***
-(UIImage *)makeQRCodeImage:(NSString *) content
{
    CIFilter *filter_qrcode = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter_qrcode setDefaults];
    
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [filter_qrcode setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter_qrcode outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    //大小控制
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:5.0];
    
    //颜色控制30-191-109
    resized = [self imageBlackToTransparent:resized withRed:0 andGreen:0 andBlue:0];
    
    CGImageRelease(cgImage);
    return resized;
}
- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*) data);
}

-(UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}
#pragma property

-(UIView *) barCodeContentView
{
    if (!_barCodeContentView) {
        _barCodeContentView=[[UIView alloc]init];
        _barCodeContentView.frame=CGRectMake(0, 20, kScreenWidth, 20);
        
        [_barCodeContentView addSubview:self.barCodeImageView];
        [_barCodeContentView addSubview:self.barCodeLabel];
    }
    return _barCodeContentView;
}
-(UILabel *) barCodeLabel
{
    if(!_barCodeLabel){
        _barCodeLabel=[[UILabel alloc]init];
        _barCodeLabel.frame=CGRectMake(ALD(20), ALD(180), kScreenWidth - ALD(40),ALD(30));
        NSLog(@"%@",[NSValue valueWithCGRect:_barCodeLabel.frame]);
        _barCodeLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _barCodeLabel;
}
-(UIView *) barCodeImageView
{
    if(!_barCodeImageView){
        _barCodeImageView = [[UIImageView alloc] init];
        
        _barCodeImageView.frame=CGRectMake(ALD(42), ALD(100), kScreenWidth - ALD(84), ALD(73));
        NSLog(@"%@",[NSValue valueWithCGRect:_barCodeImageView.frame]);
        //        _barCodeSizeLabel.text = [self formatCode:content];
    }
    return _barCodeImageView;
    // return _barCodeContentView;
}
// ****1 ***

-(UIImageView *) QRcodeView
{
    if(!_QRcodeView){
        _QRcodeView=[[UIImageView alloc] init];
        _QRcodeView.frame=CGRectMake((kScreenWidth- ALD(200))/2, ALD(240), ALD(200), ALD(200));
        
    }
    return _QRcodeView;
}
//-(UIProgressView *) progressView
//{
//    if(!_progressView)
//    {
//        _progressView =[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//        //_progressView.transform=CGAffineTransformMakeScale(3.0f, 3.0f);
//        //_progressView.trackTintColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
//        //_progressView.progressTintColor = [UIColor colorWithRed:223 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1.0];
//        // picture
//        
//        _progressView.trackTintColor =[UIHelper randomColor];
//        _progressView.trackImage=[UIImage imageNamed:@"progress1"];
//        _progressView.progressImage=[UIImage imageNamed:@"progress2"];
//        _progressView.frame=CGRectMake(20 , 380, kScreenWidth - 20 * 2, 40);
//        
//        // 设置倒计时进度条
//        _progressView.progress = 0.0/ 20.0;
//        _count=0;
//        // [_progressTimer invalidate];
//        
//        
//        
//    }
//    return _progressView;
//}
-(UILabel *) progressLable
{
    if(!_progressLable)
    {
        _progressLable = [[UILabel alloc]init];
        _progressLable.frame = CGRectMake(ALD(20), ALD(450) , kScreenWidth - ALD(20), ALD(30));
        _progressLable.textAlignment=NSTextAlignmentCenter;        
    }
    return _progressLable;
}
- (NSTimer *)progressTimer
{
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressChanged) userInfo:nil repeats:YES];
    }
    return _progressTimer;
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
