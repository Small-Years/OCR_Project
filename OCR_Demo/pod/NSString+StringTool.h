//
//  NSString+StringTool.h
//  OCR_Demo
//
//  Created by yangjian on 2018/3/15.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringTool)

/**
 检查某个字符串是否是手机号
 
 @return YES：是   NO：不是
 */
-(BOOL)isTelephoneNumber;

-(NSArray *)getPhoneNumFromStr;

@end
