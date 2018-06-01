//
//  resultViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/25.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "resultViewController.h"

@interface resultViewController (){
    UILabel *titleLable;
}

@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"识别结果";
    titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0,100,SCREEN_WIDTH,50)];
    titleLable.text = self.resultStr;
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    
    self.navigationItem.leftBarButtonItem = [AllMethod getLeftBarButtonItemWithSelect:@selector(popVC) andTarget:self WithStyle:navigationBarStyle_gray];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)popVC{
    
}
@end
