//
//  NSString+StringTool.m
//  OCR_Demo
//
//  Created by yangjian on 2018/3/15.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "NSString+StringTool.h"

@implementation NSString (StringTool)
-(BOOL)isTelephoneNumber{
    NSString *mobileStr = self;
    
    mobileStr = [mobileStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mobileStr.length != 11)
    {
        return NO;
        
    }else{
        
        /**
         
         * 移动号段正则表达式
         
         */
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        /**
         
         * 联通号段正则表达式
         
         */
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        /**
         
         * 电信号段正则表达式
         
         */
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobileStr];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobileStr];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobileStr];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
    }
}


-(NSArray *)getPhoneNumFromStr{
    NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:3];
    NSMutableString *numberString = nil;
    NSInteger loc = 0;
    for (NSInteger index = 0; index < self.length; ++index) {
        unichar ch = [self characterAtIndex:index];
        if (isnumber(ch)) {//如果是数字
            if (!numberString) {
                numberString = [NSMutableString string];
                loc = index;
            }
            [numberString appendString:[self substringWithRange:NSMakeRange(index, 1)]];
        }else {//不是数字了之后，如果numberString有值就返回值
            if (numberString) {
                [numberArray addObject:numberString];
                numberString = nil;
            }
        }
    }
    if (numberString) {
        [numberArray addObject:numberString];
    }
    return numberArray;
}

@end
