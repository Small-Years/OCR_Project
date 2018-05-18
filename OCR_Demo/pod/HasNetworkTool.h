//
//  HasNetworkTool.h
//  JKLNEW
//
//  Created by yangjian on 2017/11/10.
//  Copyright © 2017年 谢方振. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HasNetworkTool : NSObject


/**
 判断手机能不能上网（连接上了移动网或者WiFi）

 @param hasNet 是否有网
 */
+ (void)hasNetwork:(void(^)(bool has))hasNet;


/**
 判断本程序是否允许上网(一般是本地设置了允许连接什么网络)

 @param hasNet yes:允许联网  no:不允许联网
 */
+ (void)hasNetwork_And_AllowLink:(void(^)(bool has))allowLink;

@end
