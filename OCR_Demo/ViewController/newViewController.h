//
//  newViewController.h
//  OCR_Demo
//
//  Created by yangjian on 2018/3/15.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
@interface newViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


@end
