//
//  HasNetworkTool.m
//  JKLNEW
//
//  Created by yangjian on 2017/11/10.
//  Copyright © 2017年 谢方振. All rights reserved.
//

#import "HasNetworkTool.h"
#import "AFNetworkReachabilityManager.h"

@implementation HasNetworkTool

+ (void)hasNetwork:(void (^)(bool))hasNet{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusNotReachable:
            hasNet(NO);
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            hasNet(YES);
            break;
    }
}

+(void)hasNetwork_And_AllowLink:(void (^)(bool))hasNet
{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    //判断本地存储允许什么网同步
    NSString *localInternetStr = [USER_DEFAULT objectForKey:@"connectEnable"];//    @"connectViaWWAN" @"connectClose" @"connectViaWiFi"
    if ([localInternetStr isEqualToString:@""] || !localInternetStr) {
        localInternetStr = @"connectViaWiFi";
    }
    switch (status) {
        case AFNetworkReachabilityStatusUnknown://-1
        case AFNetworkReachabilityStatusNotReachable://0
            hasNet(NO);
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN://1
            if ([localInternetStr isEqualToString:@"connectViaWWAN"]) {//如果本地设置的是允许移动网，则yes
                hasNet(YES);
            }else{
                hasNet(NO);
            }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi://2 @"connectViaWWAN" @"connectClose" @"connectViaWiFi"
            if ([localInternetStr isEqualToString:@"connectClose"]) {//如果本地设置的是关闭，不能联
                hasNet(NO);
            }else{
                hasNet(YES);
            }
            break;
    }
    
}

@end
