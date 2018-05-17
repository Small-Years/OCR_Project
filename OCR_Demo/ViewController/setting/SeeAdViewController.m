//
//  SeeAdViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/16.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "SeeAdViewController.h"
#import "DydAdSdk.h"

@interface SeeAdViewController ()<DYDAdSDKDelegate>{
    UIButton *playBtn;
    
}

@end

@implementation SeeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"激励视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, 150, 45)];
    playBtn.centerX = self.view.centerX;
    playBtn.backgroundColor = RGB(126, 185, 255);
    [playBtn setTitle:@"赚取奖励" forState:UIControlStateNormal];
    playBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(startSeeAd) forControlEvents:UIControlEventTouchUpInside];
    playBtn.layer.cornerRadius = 23;
    [self.view addSubview:playBtn];
    
//    初始化视频广告
    DydAdSdk* dyd = [DydAdSdk sharedSDK];
    dyd.delegate = self;
    [dyd startWithAppId:@"你的开发者id"];
    
}


-(void)dydSDKDidInitialize:(BOOL)isInitSuccessed{
    
    
}

-(void)onAdReady{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        playBtn.enabled= YES;
    });
}

-(void)startSeeAd{
    [[DydAdSdk sharedSDK] playAd:self delegate:self error:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
