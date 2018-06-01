//
//  IDCardViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/28.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "IDCardViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "ShowResultView.h"
#import "ShowBackResultView.h"
@interface IDCardViewController ()<btnClickedDelegate,backViewBtnClickedDelegate>

@property (nonatomic,strong)NSMutableDictionary *infoDict;

@end

@implementation IDCardViewController
-(NSMutableDictionary *)infoDict{
    if (_infoDict == nil) {
        _infoDict = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _infoDict;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.infoDict removeAllObjects];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[AipOcrService shardService] authWithAK:@"3q0FMZKIWwTqDHAxgOFeg8tM" andSK:@"4mGeEYu92sLQ012IfvG2cHDuYTmq5du0"];
    
    UIImage *fan_image = [UIImage imageNamed:@"idCard_fan"];
    UIImage *zheng_image = [UIImage imageNamed:@"idCard_zheng"];
    
    UIButton *zhengBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ((SCREEN_HEIGHT*0.5)-200)*0.75, SCREEN_WIDTH, 200)];
    [zhengBtn setImage:zheng_image forState:UIControlStateNormal];
    [zhengBtn addTarget:self action:@selector(zhengBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhengBtn];
    
    UIButton *fanBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.centerY+((SCREEN_HEIGHT*0.5)-200)*0.25, zhengBtn.width, zhengBtn.height)];
    [fanBtn setImage:fan_image forState:UIControlStateNormal];
    [fanBtn addTarget:self action:@selector(fanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fanBtn];
}

#pragma mark -BtnClicked
-(void)zhengBtnClicked{
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        [[AipOcrService shardService]detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result) {
            NSLog(@"身份证正面识别成功：%@",result);
            
            if(result[@"words_result"]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([key isEqualToString:@"公民身份号码"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"idCardNo"];
                    }else if([key isEqualToString:@"住址"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"adress"];
                    }else if([key isEqualToString:@"姓名"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"name"];
                    }else if([key isEqualToString:@"性别"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"sex"];
                    }else if([key isEqualToString:@"民族"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"minzu"];
                    }else if([key isEqualToString:@"出生"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"birthday"];
                    }
                }];
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self createfrontResultView];
            }];
        } failHandler:^(NSError *err) {
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], @"识别失败"];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }];
        }];
        
    }];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:NO completion:nil];
}

-(void)fanBtnClicked{
    UIViewController  *fanVC = [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardBack andImageHandler:^(UIImage *image) {
        [[AipOcrService shardService]detectIdCardBackFromImage:image withOptions:nil successHandler:^(id result) {
            NSLog(@"身份证反面识别成功：%@",result);
            if(result[@"words_result"]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([key isEqualToString:@"签发机关"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"place"];
                    }else if([key isEqualToString:@"签发日期"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"startDate"];
                    }else if([key isEqualToString:@"失效日期"]){
                        [self.infoDict setObject:obj[@"words"] forKey:@"endDate"];
                    }
                }];
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self createbackResultView];
            }];
            
        } failHandler:^(NSError *err) {
            NSLog(@"身份证反面识别失败！%@",err);
            
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], @"识别失败"];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }];
        }];
    }];
    [self presentViewController:fanVC animated:YES completion:nil];
}


-(void)createfrontResultView{
    [self dismissViewControllerAnimated:YES completion:nil];
    ShowResultView *resultView = [ShowResultView instanceShowResultView];
    resultView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    resultView.delegate = self;
    resultView.infoDict = self.infoDict;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:resultView];
}
-(void)createbackResultView{
    [self dismissViewControllerAnimated:YES completion:nil];
    ShowBackResultView *resultView = [ShowBackResultView instanceShowBackResultView];
    resultView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    resultView.delegate = self;
    resultView.infoDict = self.infoDict;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:resultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)closeBtnClicked{
////    点击关闭之后
//    NSLog(@"点击关闭");
//    [self zhengBtnClicked];
//}
//-(void)backViewcloseBtnClicked{
//    [self zhengBtnClicked];
//}


@end
