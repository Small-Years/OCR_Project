//
//  ScanView.m
//  01-ScanCode(OC)
//
//  Created by 冯志浩 on 2017/4/10.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "ScanView.h"

@interface ScanView(){
    CGFloat kuangHeight;
    CGFloat top;
    //    CGFloat bottom_H;
    CGFloat left;
    //    CGFloat right;
}

@end


@implementation ScanView

- (void)drawRect:(CGRect)rect {
    
    kuangHeight = 100;
    top = (SCREEN_HEIGHT - 100)*0.5;
//    bottom_H = (SCREEN_HEIGHT - 100)*0.5;
    left = 50;
//    right = 50;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat black[4] = {0.0, 0.0, 0.0, 0.8};
    CGContextSetFillColor(context, black);
    //top
    CGRect rect1 = CGRectMake(0, 0, self.frame.size.width, top);
    CGContextFillRect(context, rect1);
    //leftcb
    rect1 = CGRectMake(0, top, left, kuangHeight);
    CGContextFillRect(context, rect1);
    //bottom
    rect1 = CGRectMake(0, top+kuangHeight, self.frame.size.width, top);
    CGContextFillRect(context, rect1);
    //right
    rect1 = CGRectMake(self.frame.size.width - left, top, left, kuangHeight);
    CGContextFillRect(context, rect1);
    CGContextStrokePath(context);
    
    //中间画矩形(正方形)
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddRect(context, CGRectMake(left, top, self.frame.size.width - left * 2, kuangHeight));
    CGContextStrokePath(context);
    
    CGFloat lineWidth = 10;
    
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    //左上角水平线
    CGContextMoveToPoint(context, left, top);
    CGContextAddLineToPoint(context, left + lineWidth, (SCREEN_HEIGHT -kuangHeight)*0.5);
    
    //左上角垂直线
    CGContextMoveToPoint(context, left, (SCREEN_HEIGHT -kuangHeight)*0.5);
    CGContextAddLineToPoint(context, left, (SCREEN_HEIGHT -kuangHeight)*0.5 + lineWidth);
    
    //左下角水平线
    CGContextMoveToPoint(context, left, top+kuangHeight);
    CGContextAddLineToPoint(context, left + lineWidth, top+kuangHeight);
    
    //左下角垂直线
    CGContextMoveToPoint(context, left, top+kuangHeight - lineWidth);
    CGContextAddLineToPoint(context, left, top+kuangHeight);
    
    //右上角水平线
    CGContextMoveToPoint(context, self.frame.size.width - left - lineWidth, top);
    CGContextAddLineToPoint(context, self.frame.size.width - left, top);
    
    //右上角垂直线
    CGContextMoveToPoint(context, self.frame.size.width - left, top);
    CGContextAddLineToPoint(context, self.frame.size.width - left, top + lineWidth);
    
    //右下角水平线
    CGContextMoveToPoint(context, self.frame.size.width - left - lineWidth, top+kuangHeight);
    CGContextAddLineToPoint(context, self.frame.size.width - left, top+kuangHeight);
    //右下角垂直线
    CGContextMoveToPoint(context, self.frame.size.width - left, top+kuangHeight - lineWidth);
    CGContextAddLineToPoint(context, self.frame.size.width - left, top+kuangHeight);
    CGContextStrokePath(context);
}

-(CGRect)getRectByCenterView{
    return CGRectMake(left, top, self.frame.size.width - left*2, kuangHeight);
}
@end
