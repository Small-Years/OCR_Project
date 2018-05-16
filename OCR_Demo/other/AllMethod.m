//
//  AllMethod.m
//  图片处理
//
//  Created by yangjian on 2017/2/23.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "AllMethod.h"

@implementation AllMethod



+ (UIBarButtonItem *)getLeftBarButtonItemWithSelect:(SEL)select andTarget:(id )obj WithStyle:(navigationBarStyle)style{
    //返回
    UIButton* backButton= [[UIButton alloc] initWithFrame:CGRectMake(0,0,26,50)];
    backButton.contentMode=UIViewContentModeCenter;
    if (style == navigationBarStyle_gray) {
        [backButton setImage:[UIImage imageNamed:@"leftImage_Gray"] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"leftImage_White"] forState:UIControlStateNormal];
    }
    
    backButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [backButton addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return item;
}


+ (UIBarButtonItem *)getButtonBarItemWithImageName:(NSString *)str andSelect:(SEL)select andTarget:(id)obj{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [btn addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getButtonBarItemWithTitle:(NSString *)str andSelect:(SEL)select andTarget:(id)obj{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 17*[str length]+10, 32);
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:RGB(126, 185, 255) forState:UIControlStateNormal];
    [btn.titleLabel sizeToFit];
    [btn addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getButtonBarItemWithImageName:(NSString *)str andTitle:(NSString *)tit andSelect:(SEL)select andTarget:(id)obj{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, [tit length]*17+32, 32);
    [btn setTitle:[NSString stringWithFormat:@"  %@",tit] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel sizeToFit];
    [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn addTarget:obj action:select forControlEvents:UIControlEventTouchUpInside];
    [btn setShowsTouchWhenHighlighted:YES];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
    
}

#pragma MARK - 字符串方法
+ (BOOL)isEmpty:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        NSString *str = (NSString *)object;
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedString = [str stringByTrimmingCharactersInSet:set];
        if (trimmedString.length == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)isNil:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        NSString *str = (NSString *)object;
        NSString *checkStr = [NSString stringWithFormat:@"%@", str];
        return [checkStr containsString:@"null"] || [checkStr isEqualToString:@""] || checkStr.length == 0 ? YES : NO;
    }
}

+ (NSString *)formatString:(id)object {
    if ([self isNil:object]) {
        return @"";
    } else {
        NSString *str = (NSString *)object;
        return [NSString stringWithFormat:@"%@", str];
    }
}

+ (NSString *)trimString:(NSString *)string limit:(NSInteger)limit {
    if (string == nil) {
        return string;
    }
    if (string.length > limit) {
        return [string substringToIndex:limit];
    } else {
        return string;
    }
}

+ (NSString *)trimMixString:(NSString *)string limit:(NSInteger)limit {
    if (string == nil) {
        return string;
    }
    NSMutableString *c = [NSMutableString new];
    NSInteger position = limit;
    for (int i = 0; i < string.length; i ++) {
        if (position == 0) {
            break;
        }
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            //若为汉字
            [c appendString:[string substringWithRange:NSMakeRange(i, 1)]];
            position = position - 2;
        } else {
            [c appendString:[string substringWithRange:NSMakeRange(i, 1)]];
            position = position - 1;
        }
    }
    return c;
}

/** 十六进制字符串转换为十进制 */
+ (NSString *)stringFromHexString:(NSString *)hexString {
    if (![hexString hasSuffix:@"0x"]) {    // 需要补全加上十六进制的标记
        return [NSString stringWithFormat:@"%.0lu", strtoul([hexString UTF8String], 0, 16)];
    } else {
        return [NSString stringWithFormat:@"%.0lu", strtoul([[NSString stringWithFormat:@"0x%@", hexString] UTF8String], 0, 16)];
    }
}

+ (BOOL)isValidateChineseString:(NSString *)string {
    NSString *cnNameRegex = @"^\\s*[\\u4e00-\\u9fa5]{1,}[\\u4e00-\\u9fa5.·]{0,15}[\\u4e00-\\u9fa5]{1,}\\s*$";
    NSPredicate *cnNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cnNameRegex];
    return [cnNameTest evaluateWithObject:string];
}

+ (NSArray *)getAStringOfChineseWord:(NSString *)string {
    if (string == nil || [string isEqual:@""]) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < string.length; i ++) {
        int a = [string characterAtIndex:i];
        if (a < 0x9fff && a > 0x4e00) {
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return arr;
}

+ (NSArray *)getAStringOfChineseCharacters:(NSString *)string {
    if (string == nil || [string isEqual:@""]) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < string.length; i ++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [string substringWithRange:range];
        const char *c = [subStr UTF8String];
        if (strlen(c) == 3) {
            [arr addObject:subStr];
        }
    }
    return arr;
}

+ (NSArray *)getAStringOfChineseWordNumberEnglish:(NSString *)string {
    if (string == nil || [string isEqual:@""]) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < string.length; i ++) {
        int a = [string characterAtIndex:i];    // ASCII 码
        if (a < 0x9fff && a > 0x4e00) {    // 中文
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if (48 <= a && a <= 57) {    // 数字
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if ((65 <= a && a <= 90) || (97 <= a && a <= 122)) {    // 英文
            [arr addObject:[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return arr;
}



+ (void)showAltMsg:(NSString *)msg WithController:(UIViewController *)viewController WithAction:(void (^ _Nullable)(UIAlertAction *))action{
    if([msg isEqual:@""]||msg==nil){
        return;
    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:action];
    [controller addAction:cancleAction];
    
    
    [viewController presentViewController:controller animated:YES completion:nil];
    
}

+(NSString *)dateToDetailOld:(NSString *)bornDateStr{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSDate * ValueDate = [dateFormatter dateFromString:bornDateStr];
    
    
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //创建日历(格里高利历)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置component的组成部分
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
    //按照组成部分格式计算出生日期与现在时间的时间间隔
    NSDateComponents *date = [calendar components:unitFlags fromDate:ValueDate toDate:currentDate options:0];
    
    //
    
    NSString *ageStr = [NSString stringWithFormat:@"%ld岁",(long)[date year]];
    return ageStr;
}



+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSString *)getNowDateWithFormatter:(NSString *)dateFormatter{
    //    dateFormatter格式：yyyy-MM-dd 、yyyy年MM月dd日 。。。
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

+(NSString *)changeDateMethod:(NSString *)dateStr From:(NSString *)formatter To:(NSString *)n_Formatter{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSDate *date = [dateformatter dateFromString:dateStr];
    [dateformatter setDateFormat:n_Formatter];
    dateStr = [dateformatter stringFromDate:date];
    return dateStr;
}
/**
 字典转JSON
 
 @param dict
 @return
 */
+(NSString *)ExchangeToJsonDataFromDict:(NSDictionary *)dict
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@"" withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
+(NSDictionary *)ExchangeToDictionaryFromJson:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(CGSize)sizeWithString:(NSString *)str fontSize:(int)fontSize maxSizeX:(CGFloat)maxSizeX maxSizeY:(CGFloat)maxSizeY{
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize maxSize = CGSizeMake(maxSizeX, maxSizeY);
    CGSize textsize= [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textsize;
}
+ (NSString *)CreateUUIDString{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_ref);
    
    CFRelease(uuid_string_ref);
    
    NSString *str = [uuid lowercaseString];
    
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return str;
}

@end
