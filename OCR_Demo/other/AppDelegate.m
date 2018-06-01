//
//  AppDelegate.m
//  OCR_Demo
//
//  Created by yangjian on 2018/3/8.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "AppDelegate.h"
#import "newViewController.h"
#import "BaiduOcrViewController.h"
#import "CameraViewController.h"
#import "settingViewController.h"
#import "mainTabBarViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    NSDictionary *dict = @{@"sdf":@"key"};
    if (![dict valueForKey:@"name"]) {
        NSLog(@"不崩吗？%@",[dict valueForKey:@"name"]);
    }
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootVC;
    if (![USER_DEFAULT objectForKey:viewLogo]) {
        [USER_DEFAULT setObject:@"Tesseract" forKey:viewLogo];
    }
    if (![USER_DEFAULT objectForKey:isFirstUse]) {
        [USER_DEFAULT setObject:@"50" forKey:leftNum];
        [USER_DEFAULT setObject:@"YES" forKey:isFirstUse];
    }
    
//    rootVC = [[settingViewController alloc]init];
    
//    rootVC = [[newViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootVC];
//    nav.navigationBar.hidden = YES;
    
    mainTabBarViewController *mainVC = [[mainTabBarViewController alloc]init];
    
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    
    [AVOSCloud setApplicationId:@"ANU9kLhmWvWMtXDDmgeuEwxy-gzGzoHsz" clientKey:@"50Ee1RzcmT1BKBkjNzI0y08I"];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
