//
//  newViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/3/15.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "newViewController.h"
#import "TesseractOCR/TesseractOCR.h"
#import "settingViewController.h"
#import "BaiduOcrViewController.h"
#import "PhoneNumerTableViewCell.h"
#import "ScanView.h"
#import <MessageUI/MessageUI.h>


@interface newViewController ()<UITableViewDelegate,UITableViewDataSource,TelephoneBtnDelegate,MFMessageComposeViewControllerDelegate>{
    CGFloat viewWidth;
    UIButton *settingBtn;
    UIButton *startBtn;
    UIButton *lightBtn;
    UIView *mainView ;
    
//    int timeNum;
    
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIImage *currentImage; //当前时间抓到的图
@property(nonatomic,assign)BOOL isDealing;

@property (nonatomic, strong) ScanView *scan;
@property (nonatomic, strong) UIView *slideLineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong)UILabel *titleTextLable;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong) UIButton * centerBtn;

@property(nonatomic,assign)BOOL isSub;//判断当前扫描出来的结果是否已经减去了次数
@end

@implementation newViewController



-(UIButton *)centerBtn{
    if (_centerBtn == nil) {
        _centerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, lightBtn.y,lightBtn.width , lightBtn.height)];
        _centerBtn.centerX = self.view.centerX;
        _centerBtn.backgroundColor = [UIColor clearColor];
        _centerBtn.tag = 60;
        [_centerBtn setImage:[UIImage imageNamed:@"centerBtn"] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(takePoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self.captureSession startRunning];
    startBtn.selected = NO;
    lightBtn.selected = NO;
    self.isSub = NO;
    if ([[USER_DEFAULT objectForKey:viewLogo]isEqualToString:@"baidu"]) {
        UIButton *btn = [self.view viewWithTag:60];
        if (!btn) {
            [self.view addSubview:self.centerBtn];
        }
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePoto)];
        doubleTapGesture.numberOfTapsRequired =2;
        doubleTapGesture.numberOfTouchesRequired =1;
        [_scan addGestureRecognizer:doubleTapGesture];
        _scan.userInteractionEnabled = YES;
        
    }else{
        UIButton *btn = [self.view viewWithTag:60];
        [btn removeFromSuperview];
        _scan.userInteractionEnabled = NO;
       
    }
    
    if ([USER_DEFAULT objectForKey:@""]) {
        //show
    }
    [self setupTimersetupSubView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.captureSession stopRunning];
    [_titleTextLable removeFromSuperview];
    _titleTextLable = nil;
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self start];

    //设置界面
    settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 100, 60, 60)];
    settingBtn.layer.cornerRadius = settingBtn.width * 0.5;
    settingBtn.layer.masksToBounds = YES;
    [settingBtn setImage:[UIImage imageNamed:@"btn_set"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:settingBtn];
    
    startBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60-20, 40, 60, 60)];
    startBtn.layer.cornerRadius = startBtn.width * 0.5;
    startBtn.layer.masksToBounds = YES;
    [startBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [startBtn setTitle:@"开始" forState:UIControlStateSelected];
    [startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:UIControlStateSelected];
    [startBtn addTarget:self action:@selector(pauseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:startBtn];
    
    lightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - 100-30, 60, 60)];
    [lightBtn addTarget:self action:@selector(lightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [lightBtn setImage:[UIImage imageNamed:@"light_btn"] forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage imageNamed:@"light_btn_select"] forState:UIControlStateSelected];
    [self.view addSubview:lightBtn];
}


-(void)lightBtnClicked{
    [lightBtn setSelected:!lightBtn.selected];
    //闪光灯
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (device.flashMode == AVCaptureFlashModeOff) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(void)takePoto{
    NSLog(@"--点击拍照");
    [WSProgressHUD showImage:nil status:@"点击拍照"];
    [self.captureSession stopRunning];
    [self.timer invalidate];
    BaiduOcrViewController *vc = [[BaiduOcrViewController alloc]init];
    vc.currentImage = self.currentImage;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidUnload {
    [self.captureSession stopRunning];
    self.imageView = nil;
//    self.customLayer = nil;
    self.captureVideoPreviewLayer = nil;
}

- (void)setupScanView {
    _scan = [[ScanView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scan.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scan];
    _slideLineView = [[UIView alloc]initWithFrame:CGRectMake(50, (SCREEN_HEIGHT - 100)*0.5, SCREEN_WIDTH - 50*2, 1)];
    _slideLineView.backgroundColor = [UIColor greenColor];
    [_scan addSubview:_slideLineView];
    
    [self setupTimer];
    [self setupTimersetupSubView];
}


- (void)setupTimersetupSubView {
    if ([[USER_DEFAULT objectForKey:showWarnLable]isEqualToString:@"NO"]) {
        return;
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50.0)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [_scan addSubview:_titleLabel];
    }
    if ([[USER_DEFAULT objectForKey:viewLogo]isEqualToString:@"baidu"]) {
        if (!_titleTextLable) {
            _titleTextLable = [[UILabel alloc]initWithFrame:CGRectMake(0, _titleLabel.max_Y, SCREEN_WIDTH, 16)];
            _titleTextLable.textColor = [UIColor whiteColor];
            _titleTextLable.textAlignment = NSTextAlignmentCenter;
            _titleTextLable.font = [UIFont systemFontOfSize:14];
            [_scan addSubview:_titleTextLable];
        }
        _titleLabel.text = @"请将手机号放入框内，拍照识别";
        _titleTextLable.text = @"(小提示：双击黑色背影区域也可拍照哦)";
    }else{
        _titleLabel.text = @"请将手机号放入框内，等待扫描成功";
    }
}

- (void)setupTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(animationView) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)animationView {
    [UIView animateWithDuration:1.5 animations:^{
        _slideLineView.transform = CGAffineTransformMakeTranslation(0, 100);
    } completion:^(BOOL finished) {
        _slideLineView.transform = CGAffineTransformIdentity;
    }];
}

//扫描成功的提示音
- (void)scanSuccess {
    if ([[USER_DEFAULT objectForKey:playAudio]isEqualToString:@"NO"]) {
        return;
    }
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1108);
}

/**
 * 初始化摄像头
 */
- (void)initCapture
{
    NSError *error = nil;
    AVCaptureSession *session = [[AVCaptureSession alloc] init];//负责输入和输出设置之间的数据传递
    session.sessionPreset = AVCaptureSessionPresetHigh;//设置分辨率
    self.captureSession = session;
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
    [session startRunning];
}


#pragma mark - StartOCRMethod
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    if ([[USER_DEFAULT objectForKey:viewLogo]isEqualToString:@"Tesseract"]) {
        [self dealImage:image];
    }else{
        self.currentImage = image;
    }
}

-(void)dealImage:(UIImage *)image{
    if (self.isDealing) {
        return;
    }
    self.isDealing = YES;
    
    //    需要对图片进行裁减，算出裁减的比例出来
    image = [image imageRotatedByDegrees:90];
    
    CGFloat width = (SCREEN_WIDTH - 100)/SCREEN_WIDTH *image.size.width;
    CGFloat height = (100/SCREEN_HEIGHT)*image.size.height;
    CGFloat top = (image.size.height - height)*0.5;
    CGFloat left = (image.size.width - width)*0.5;
    
    CGRect needRect = CGRectMake(left, top, width, height);
    UIImage *newImage = [image subImageWithRect:needRect];
    
    NSLog(@"---%@",newImage);
    self.currentImage = newImage;
    [self startOCRrecognited:newImage];//获取到当前图片开始扫描
}

-(void)startOCRrecognited:(UIImage *)image{
    NSLog(@"截取的image的大小:%f--%f---%@",image.size.width,image.size.height,image);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //初始化G8Tesseract类，为文字识别做准备
        G8Tesseract *CardTesseract = [[G8Tesseract alloc]initWithLanguage:@"eng"];
        CardTesseract.image = [image g8_blackAndWhite];
        //开始识别
        [CardTesseract recognize];
        
        NSString *str = CardTesseract.recognizedText;
        NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//        需要将空格处理掉
        NSArray *phoneArr = [self getPhoneNum:strUrl];
        if (phoneArr.count == 0) {
            self.isDealing = NO;
        }else{
            [self.captureSession stopRunning];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scanSuccess];
                [self buildSuccessView:phoneArr];
            });
        }
        
    });
    
    
}

-(void)buildSuccessView:(NSArray *)resultArr{
    self.tabBarController.tabBar.hidden = YES;
    self.dataArray = [NSMutableArray arrayWithArray:resultArr];
    mainView = [[UIView alloc]initWithFrame:self.view.frame];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    
    CGRect Rect = CGRectMake(scale_Width*SCREEN_WIDTH, 64, (1-scale_Width*2)*SCREEN_WIDTH, scale_Height*SCREEN_HEIGHT);
    
    UIImageView *resultImageView = [[UIImageView alloc]initWithFrame:Rect];
    resultImageView.image = self.currentImage;
    resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mainView addSubview:resultImageView];
    
    UITableView *resultTable = [[UITableView alloc]initWithFrame:CGRectMake(0, resultImageView.max_Y+30, SCREEN_WIDTH, SCREEN_HEIGHT- resultImageView.max_Y-30-60)];
    resultTable.delegate = self;
    resultTable.dataSource = self;
    resultTable.tableFooterView = [UIView new];
    [mainView addSubview:resultTable];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, mainView.height - 60, 169, 40)];
    btn.centerX = mainView.centerX;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(126, 185, 255);
    [btn addTarget:self action:@selector(dismissSuccessView) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btn];
    btn.layer.cornerRadius  = 7;
    btn.layer.masksToBounds = YES;
}


-(void)dismissSuccessView{
    [mainView removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
    [self.captureSession startRunning];
    self.isDealing = NO;
    self.isSub = NO;
}

//从字符串中提取手机号
-(NSArray *)getPhoneNum:(NSString *)resultStr{
    if (resultStr.length < 11) {
        self.isDealing = NO;
        return [NSArray array];
    }
    NSArray *numArr = [resultStr getPhoneNumFromStr];
    NSMutableArray *phoneNumArr = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i<numArr.count; i++) {
        NSString *str = numArr[i];
        if ([str isTelephoneNumber]) {//有手机号存在
            [phoneNumArr addObject:str];
        }
    }
    return phoneNumArr;
}
#pragma mark -UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitMsg:@"未识别出手机号" ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"CELLID"];
    PhoneNumerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PhoneNumerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.phoneText.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,70)];
    lable.backgroundColor = [UIColor whiteColor];
    lable.text = @"识别结果";
    lable.textColor = RGB(76, 76, 76);
    lable.font = [UIFont systemFontOfSize:17];
    lable.numberOfLines = 0;
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
#pragma mark - sendMessage
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body{
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - BtnClicked
-(void)btnClicked:(btnStyle)style withNum:(NSString *)phoneNumber{
    if (!self.isSub) {
        NSString *currentNumStr = [USER_DEFAULT objectForKey:leftNum];
        int num = currentNumStr.intValue;
        if (num <= 0) {
            [WSProgressHUD showImage:[UIImage imageNamed:@""] status:@"剩余次数不足，请查看"];
            return;
        }else{
            num = num - 1;
            currentNumStr = [NSString stringWithFormat:@"%d",num];
            [USER_DEFAULT setObject:currentNumStr forKey:leftNum];
        }
    }
    
    if (style == btnStyleCopy) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:phoneNumber];
        [WSProgressHUD showImage:nil status:@"手机号已复制"];
    }else if (style == btnStyleMessage){
        [self showMessageView:[NSArray arrayWithObjects:phoneNumber, nil] title:@"test" body:@""];
    }else if (style == btnStyleTelephone){
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        [WSProgressHUD showImage:nil status:@"未定义事件"];
    }
    self.isSub = YES;
}

-(void)setBtnClicked{//跳转到设置界面
    settingViewController *vc = [[settingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.captureSession stopRunning];
}

-(void)start{
    if (self.captureSession == nil) {
        [self initCapture];
        [self setupScanView];
    }
    [self.view bringSubviewToFront:settingBtn];
    [self.view bringSubviewToFront:startBtn];
}

-(void)pauseBtnClicked{
    if (startBtn.selected == NO) {//暂停
        [self.captureSession stopRunning];
        self.isDealing = YES;
//        self.customLayer.hidden = YES;
        [self.timer setFireDate:[NSDate distantFuture]];
        
    }else{//开始
        [self.captureSession startRunning];
        self.isDealing = NO;
//        self.customLayer.hidden = NO;
        [self.timer setFireDate:[NSDate date]];
        
    }
    [startBtn setSelected:!startBtn.selected];
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

@end
