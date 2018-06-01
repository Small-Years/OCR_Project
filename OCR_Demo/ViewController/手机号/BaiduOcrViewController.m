//
//  BaiduOcrViewController.m
//  OCR_Demo
//
//  Created by yangjian on 2018/3/19.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "BaiduOcrViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "PhoneNumerTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface BaiduOcrViewController ()<UITableViewDelegate,UITableViewDataSource,TelephoneBtnDelegate,MFMessageComposeViewControllerDelegate>{
    UIImage *image;
    
}
@property (nonatomic,strong)UIImageView * mainImageView;
@property (nonatomic,strong)UITableView * mainTable;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSString *resultStr;
@end

@implementation BaiduOcrViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)mainTable{
    if (_mainTable == nil) {
        _mainTable = [[UITableView alloc]init];
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        
        _mainTable.tableFooterView = [UIView new];
    }
    return _mainTable;
}

-(UIImageView *)mainImageView{
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc]init];
        _mainImageView.backgroundColor = [UIColor whiteColor];
    }
    return _mainImageView;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [[AipOcrService shardService] authWithAK:@"3q0FMZKIWwTqDHAxgOFeg8tM" andSK:@"4mGeEYu92sLQ012IfvG2cHDuYTmq5du0"];
    
    image = self.currentImage;
    
    image = [image imageRotatedByDegrees:90];
    
    CGFloat width = (SCREEN_WIDTH - 100)/SCREEN_WIDTH *image.size.width;
    CGFloat height = (100/SCREEN_HEIGHT)*image.size.height;
    CGFloat top = (image.size.height - height)*0.5;
    CGFloat left = (image.size.width - width)*0.5;
    
    CGRect needRect = CGRectMake(left, top, width, height);
    UIImage *newImage = [image subImageWithRect:needRect];
    
//    NSLog(@" 裁减完成后的图片：-- %@",newImage);
    self.mainImageView.image = newImage;
    self.mainImageView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 100 ,(newImage.size.height/newImage.size.width)*(SCREEN_WIDTH - 100));
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.mainImageView];
    
    self.mainTable.frame = CGRectMake(0, self.mainImageView.max_Y+10, SCREEN_WIDTH, SCREEN_HEIGHT - self.mainImageView.max_Y-10 - 60);
    [self.view addSubview:self.mainTable];
    [WSProgressHUD showWithStatus:@"识别中..."];
    [self uploadImage:newImage];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height - 60, 169, 40)];
    btn.centerX = self.view.centerX;
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(126, 185, 255);
    [btn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.cornerRadius  = 7;
    btn.layer.masksToBounds = YES;
}

-(void)uploadImage:(UIImage *)image{
    __weak typeof(self) weakSelf = self;
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextFromImage:image withOptions:options successHandler:^(id result) {
        
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
        }else{
            [message appendFormat:@"%@", result];
        }
        
        weakSelf.dataArray = [NSMutableArray arrayWithArray:[weakSelf getPhoneNum:message]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (weakSelf.dataArray.count == 0) {
                weakSelf.resultStr = @"未识别出手机号";
            }
            [weakSelf.mainTable reloadData];
            [WSProgressHUD dismiss];
        }];
    } failHandler:^(NSError *err) {
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [weakSelf.dataArray removeAllObjects];
            weakSelf.resultStr = msg;
            [weakSelf.mainTable reloadData];
            [WSProgressHUD dismiss];
        }];
    }];
}



//从字符串中提取手机号
-(NSArray *)getPhoneNum:(NSString *)resultStr{
    if (resultStr.length < 11) {
        return [NSArray array];
    }
    NSArray *numArr = [resultStr getPhoneNumFromStr];
    NSMutableArray *phoneNumArr = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i<numArr.count; i++) {
        NSString *str = numArr[i];
        if ([str isTelephoneNumber]) {//有手机号存在
            [phoneNumArr addObject:str];
        }
    }
    return phoneNumArr;
}

-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITablviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, self.mainImageView.max_Y+30, SCREEN_WIDTH, 70)];
    titleLable.backgroundColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:18];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = RGB(76, 76, 76);
    titleLable.text = @"识别结果";
    return titleLable;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitMsg:self.resultStr ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellID = [NSString stringWithFormat:@"PhoneNumberCell"];
    PhoneNumerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[PhoneNumerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.phoneText.text = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"--%@",self.dataArray[indexPath.row]);
//
//}
#pragma mark - PhoneNumerTableViewCellDelegate

-(void)btnClicked:(btnStyle)style withNum:(NSString *)phoneNumber{
    if (style == btnStyleCopy) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:phoneNumber];
        [WSProgressHUD showImage:nil status:@"手机号已复制"];
    }else if (style == btnStyleMessage){
        [self showMessageView:[NSArray arrayWithObjects:phoneNumber, nil] title:@"test" body:@""];
    }else if (style == btnStyleTelephone){
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{
        [WSProgressHUD showImage:nil status:@"未定义事件"];
    }
    
}

#pragma mark - sendMessage
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body{
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
