//
//  DetectorManager.m
//  OpenCV_Tesseract_demo
//
//  Created by 张昭 on 29/11/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import "DetectorManager.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>


#import <TesseractOCR/TesseractOCR.h>

@interface DetectorManager ()

@property (nonatomic, copy) CompleteBlock myBlock;

@end

@implementation DetectorManager

+ (instancetype)shareInstance {
    static DetectorManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DetectorManager alloc] init];
    });
    return manager;
}

// 图片的剪裁、识别与结果处理
- (void)detecteCardWithImage:(UIImage *)cardImage compleate:(CompleteBlock)complete {
    
    /**
     相对于身份证来说，银行卡片的背景环境千差万别，有的卡片无需处理而有的则需要灰度值或二阈值重新处理，用一种方式处理千百种环境，结果可想而知；
     这里的话就简单的，在图片的不同处理阶段进行多次的文字识别，最后在统一处理；
     
     第一次：卡号所在位置的图片截取之后，进行识别；
     第二次：灰度值处理之后，进行识别；
     第三次：二阈值处理之后，进行识别；
     第四次：腐蚀化重新截图并灰度值处理之后，进行识别；
     第五次：腐蚀化重新截图、灰度值并二阈值处理之后，进行识别；
     */
    
    // 将卡号所在的大致位置在图片上截取出来，缩小OpenCV要识别的图片范围，认为的提高识别效率。
    UIImage *corpImage = [self cropImageFromImage:cardImage];
    if (corpImage == nil) {
        complete(nil);
        return;
    }
    
    // 识别结果的初步处理
    __weak typeof(self) weakSelf = self;
    self.myBlock = ^(NSString *res) {
        // 信用卡16位，储蓄卡19位
        if (res.length < 16 || [res isEqualToString:@"定位失败"]) {
            complete(@"重新捕获");
            return;
        }
        NSString *result = [weakSelf findNumFromStr:res];
        if (result.length < 16 || [res isEqualToString:@"定位失败"]) {
            complete(@"重新捕获");
            return;
        }
        complete(result);
    };
   
    // 第一次识别：
    [self tesseractDetectorWithImage: corpImage withComplete:^(NSString *result) {
//        NSLog(@"第一次识别：%@", result);
        weakSelf.myBlock(result);
    }];
    
    // 利用OpenCV，对截取出来的图片进一步处理,并进行类外四次的识别
    [self opencvScanCard:corpImage];
    
}

- (void)opencvScanCard:(UIImage *)image {
    
    // 图片转换
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    
    // 灰度处理（去除图片的色彩和光亮）
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
    // 第二次识别：
    __weak typeof(self) weakSelf = self;
    [self tesseractDetectorWithImage: MatToUIImage(resultImage) withComplete:^(NSString *result) {
//        NSLog(@"第二次识别：%@", result);
        weakSelf.myBlock(result);
    }];
    
    // 二阈值处理
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    
    // 第三次识别：
    [self tesseractDetectorWithImage: MatToUIImage(resultImage) withComplete:^(NSString *result) {
//        NSLog(@"第三次识别：%@", result);
        weakSelf.myBlock(result);
    }];

    // 腐蚀：白色背景缩小，黑色扩大
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(25,25)); //3535
    cv::erode(resultImage, resultImage, erodeElement);
    
    UIImage *ccc = MatToUIImage(resultImage);
    UIImageWriteToSavedPhotosAlbum(ccc, nil, nil, nil);
    
    // 轮廊检测
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    
    // 取出卡号区域
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        
        if (rect.width > numberRect.width && rect.width > rect.height * 5) {
            numberRect = rect;
        }
    }
    
    if (numberRect.width == 0 || numberRect.height == 0) {
        NSLog(@"定位失败");
        self.myBlock(@"定位失败");
        return;
    }
    
    // 定位成功，重新截图
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    
    // 第二次灰度值处理
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
    // 第四次识别：
    [self tesseractDetectorWithImage: MatToUIImage(resultImage) withComplete:^(NSString *result) {
//        NSLog(@"第四次识别：%@", result);
        weakSelf.myBlock(result);
    }];
    
    // 第二次二阈值处理
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    
    // 第五次识别：
    [self tesseractDetectorWithImage: MatToUIImage(resultImage) withComplete:^(NSString *result) {
//        NSLog(@"第五次识别：%@", result);
        weakSelf.myBlock(result);
    }];
    
}

// 二阈值测试
- (UIImage *)opencvScanCard:(UIImage *)image withBlack:(int)black withWhite:(int)white {
    
    //将UIImage转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
    // 测试：
//    UIImage *aaa = MatToUIImage(resultImage);
//    UIImageWriteToSavedPhotosAlbum(aaa, nil, nil, nil);
    
    //利用阈值二值化
    cv::threshold(resultImage, resultImage, black, white, CV_THRESH_BINARY);
    
    // 测试：
//    UIImage *bbb = MatToUIImage(resultImage);
//    UIImageWriteToSavedPhotosAlbum(bbb, nil, nil, nil);
//    return bbb;
    
    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(25,25)); //3535
    cv::erode(resultImage, resultImage, erodeElement);
    
    // 测试：
//    UIImage *ccc = MatToUIImage(resultImage);
//    UIImageWriteToSavedPhotosAlbum(ccc, nil, nil, nil);
//    return ccc;
    
    // 轮廊检测
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        //算法原理
        if (rect.width > numberRect.width && rect.width > rect.height * 5) {
                        numberRect = rect;
        }
    }

    // 定位失败
    if (numberRect.width == 0 || numberRect.height == 0) {
        self.myBlock(@"定位失败");
        return nil;
    }
    
    // 定位成功
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
    UIImage *numberImage = MatToUIImage(resultImage);
    
    return numberImage;
}

// Tesseract识别
- (void)tesseractDetectorWithImage:(UIImage *)img withComplete:(CompleteBlock)complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        tesseract.image = [img g8_blackAndWhite];
        tesseract.image = img;
        [tesseract recognize];

        complete(tesseract.recognizedText);
    });
}

// 裁剪银行卡号
- (UIImage *)cropImageFromImage:(UIImage *)img{
    
    static CGFloat cardWidth = 400;
    static CGFloat cardHeight = 400/1.59;
    
    CGFloat h = img.size.height * 500 / img.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(500, h));
    [img drawInRect:CGRectMake(0, 0, 500, h)];
    UIImage *scaleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat y = (scaleImg.size.height - cardHeight) / 2;
    
    CGImageRef sourceImageRef = [scaleImg CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(50, y, cardWidth, cardHeight));
    
    CGImageRef resultImgRef = CGImageCreateWithImageInRect(newImageRef, CGRectMake(0, 130, cardWidth, 50));
    UIImage *mm = [UIImage imageWithCGImage:resultImgRef];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"%@", scaleImg);
        NSLog(@"%@", [UIImage imageWithCGImage:newImageRef]);
        NSLog(@"%@", mm);
        UIImageWriteToSavedPhotosAlbum(scaleImg, nil, nil, nil);
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:newImageRef], nil, nil, nil);
        UIImageWriteToSavedPhotosAlbum(mm, nil, nil, nil);
    });
    
    return mm;
}

- (NSString *)findNumFromStr:(NSString *)originalString {
    
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        if (tempStr) {
            [numberString appendString:tempStr];
        }
        tempStr = @"";
    }
    // Result.
    return numberString;
}


@end
