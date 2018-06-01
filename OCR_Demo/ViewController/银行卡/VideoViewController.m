//
//  VideoViewController.m
//  OpenCV_Tesseract_demo
//
//  Created by 张昭 on 30/11/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "cardScanView.h"
#import "DetectorManager.h"
#import "resultViewController.h"



@interface VideoViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,DetectorManagerDelagete>

@property (strong, nonatomic) IBOutlet UIView *captureView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIImageView *myImageView;

@property (nonatomic, strong) UIImage *myImage;

@property(nonatomic,assign)BOOL isDealing;//当前正在识别中

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.myImage = [[UIImage alloc] init];
    
    [self initCapture];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if (self.session) {
        [self.session startRunning];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    if (self.session) {
        [self.session stopRunning];
    }
}

/**
 * 初始化摄像头
 */
- (void)initCapture{
    NSError *error = nil;
    AVCaptureSession *session = [[AVCaptureSession alloc] init];//负责输入和输出设置之间的数据传递
    session.sessionPreset = AVCaptureSessionPresetHigh;//设置分辨率
    self.session = session;
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
        NSError *error;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            
            [device unlockForConfiguration];
        }
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [session addInput:input];
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];//创建一个视频数据输出流
    [session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                            [NSNumber numberWithInt: 320], (id)kCVPixelBufferWidthKey,
                            [NSNumber numberWithInt: 240], (id)kCVPixelBufferHeightKey,
                            nil];
    
    AVCaptureVideoPreviewLayer* preLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];//相机拍摄预览图层
    preLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    preLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:preLayer];
    
    cardScanView *scanView = [[cardScanView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scanView];
    
    [session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [self dealImage:image];
    
//    if ([[USER_DEFAULT objectForKey:viewLogo]isEqualToString:@"Tesseract"]) {
//        [self dealImage:image];
//    }else{
//        self.currentImage = image;
//    }
}

-(void)dealImage:(UIImage *)image{
    if (self.isDealing) {
        return;
    }
    self.isDealing = YES;
    
    //    需要对图片进行裁减，算出裁减的比例出来
    UIImage *deImage = [self imageRotatedByRadians:M_PI*0.5 WithImage:image];
    
    CGFloat width = deImage.size.width *0.8;
    CGFloat height = width / 1.59;
    CGFloat top = (deImage.size.height - height)*0.5;
    CGFloat left = deImage.size.width * 0.1;
    
    CGRect needRect = CGRectMake(left, top, width, height);
    UIImage *newImage = [deImage subImageWithRect:needRect];
    
    [self startOCRrecognited:newImage];//获取到当前图片开始扫描
}


- (UIImage *)cropImageFromImage:(UIImage *)img {
    CGImageRef sourceImageRef = [img CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 140, img.size.width, 30));
    return [UIImage imageWithCGImage:newImageRef];
}

- (void)startOCRrecognited:(UIImage *)needImage{
    //【点击事件中调用图片识别，防止CPU飙升】
    
    __weak typeof(self) weakSelf = self;
    [[DetectorManager shareInstance] detecteCardWithImage:needImage compleate:^(NSString *result) {
        NSLog(@"识别结果：%@", result);
        
        if ([self checkBankCardNumber:result]) {
            NSLog(@"识别成功：%@", result);
            weakSelf.isDealing = NO;
            resultViewController *vc = [[resultViewController alloc]init];
            vc.resultStr = result;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            weakSelf.isDealing = NO;
        }
    }];
}

-(void)resultOftheScan:(NSString *)str{
    NSLog(@"识别结果：%@", str);
    if ([self checkBankCardNumber:str]) {
        NSLog(@"识别成功：%@", str);
        self.isDealing = NO;
        resultViewController *vc = [[resultViewController alloc]init];
        vc.resultStr = str;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.isDealing = NO;
    }
}

- (BOOL)checkBankCardNumber:(NSString *)cardNumber
{
    if (cardNumber.length < 16) {
        return NO;
    }
    int oddSum = 0;     // 奇数和
    int evenSum = 0;    // 偶数和
    int allSum = 0;     // 总和
    
    // 循环加和
    for (NSInteger i = 1; i <= cardNumber.length; i++)
    {
        NSString *theNumber = [cardNumber substringWithRange:NSMakeRange(cardNumber.length-i, 1)];
        int lastNumber = [theNumber intValue];
        if (i%2 == 0)
        {
            // 偶数位
            lastNumber *= 2;
            if (lastNumber > 9)
            {
                lastNumber -=9;
            }
            evenSum += lastNumber;
        }
        else
        {
            // 奇数位
            oddSum += lastNumber;
        }
    }
    allSum = oddSum + evenSum;
    // 是否合法
    if (allSum%10 == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
// 通过抽样缓存数据创建一个UIImage对象
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    CGImageRelease(quartzImage);
    return (image);
}

/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians WithImage:(UIImage *)image
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
