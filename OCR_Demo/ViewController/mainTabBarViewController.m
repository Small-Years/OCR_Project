//
//  mainTabBarViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/21.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "mainTabBarViewController.h"
#import "settingViewController.h"
#import "newViewController.h"
#import "VideoViewController.h"
#import "IDCardViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>

@interface mainTabBarViewController ()

@end

@implementation mainTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    IDCardViewController *cardVC = [[IDCardViewController alloc]init];
    UINavigationController *cardNav = [[UINavigationController alloc]initWithRootViewController:cardVC];
    cardNav.tabBarItem.title = @"身份证";
    cardNav.tabBarItem.image = [[UIImage imageNamed:@"银行卡_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cardNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"银行卡_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    newViewController *oneVC = [[newViewController alloc]init];
    UINavigationController *oneNav = [[UINavigationController alloc]initWithRootViewController:oneVC];
    oneNav.tabBarItem.title = @"手机号";
    oneNav.tabBarItem.image = [[UIImage imageNamed:@"手机号_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    oneNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"手机号_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    VideoViewController *bankVC = [[VideoViewController alloc]init];
    UINavigationController *bankNav = [[UINavigationController alloc]initWithRootViewController:bankVC];
    bankNav.tabBarItem.title = @"银行卡";
    bankNav.tabBarItem.image = [[UIImage imageNamed:@"银行卡_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bankNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"银行卡_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    settingViewController *setVC = [[settingViewController alloc]init];
    UINavigationController *setNav = [[UINavigationController alloc]initWithRootViewController:setVC];
    setNav.tabBarItem.title = @"设置";
    setNav.tabBarItem.image = [[UIImage imageNamed:@"设置_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    setNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"设置_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:oneNav];
    [self addChildViewController:cardNav];
    [self addChildViewController:setNav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
