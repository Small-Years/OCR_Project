//
//  CameraViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/9.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "CameraViewController.h"
#import "settingViewController.h"
#import "ScanView.h"

@interface CameraViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic, strong) ScanView *scan;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupCaptureSession];
    [self setupScanView];
}
#pragma mark - UI
- (void)setupScanView {
    _scan = [[ScanView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scan.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scan];
    
//    _slideLineView = [[UIView alloc]initWithFrame:CGRectMake(50, (SCREEN_HEIGHT - 100)*0.5, SCREEN_WIDTH - 50*2, 1)];
//    _slideLineView.backgroundColor = [UIColor greenColor];
//    [_scan addSubview:_slideLineView];
//
//    [self setupTimer];
    
}

#pragma mrak - 视频流
- (void)setupCaptureSession
{
    NSError *error = nil;
    
    // Create the session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];//负责输入和输出设置之间的数据传递
    session.sessionPreset = AVCaptureSessionPresetHigh;//设置分辨率
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头
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
    
    [session startRunning];
    
}
// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
//    需要对图片进行裁减，算出裁减的比例出来
    image = [image imageRotatedByDegrees:90];
    
    CGFloat scrWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat width = (scrWidth - 100)/scrWidth *image.size.width;
    CGFloat height = (100/scrHeight)*image.size.height;
    CGFloat top = (image.size.height - height)*0.5;
    CGFloat left = (image.size.width - width)*0.5;
    
    CGRect needRect = CGRectMake(left, top, width, height);
    UIImage *newImage = [image subImageWithRect:needRect];
    
    
    NSLog(@"---%@",newImage);
}



#pragma mark - 图片
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



#pragma mark - BtnClicked
-(void)setBtnClicked{//跳转到设置界面
    settingViewController *vc = [[settingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
