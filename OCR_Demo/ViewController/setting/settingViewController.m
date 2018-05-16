//
//  settingViewController.m
//
//  Created by yangjian on 2017/3/15.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#define bgColor [UIColor darkGrayColor]

#import "settingViewController.h"
#import "ShowTimesTableViewCell.h"
//#import "warnViewController.h"
//#import "HcdCacheVideoPlayer.h"
//#import "infoViewController.h"
#import "sendMessageViewController.h"
#import <StoreKit/StoreKit.h>//评分库

//#import "IAPShare.h"
@interface settingViewController ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,numTableViewCellBtnClickedDelegate>{
    
    UITableView *mainTable;
    UIScrollView *proBlackView;//开通Pro版
}
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSArray * iconArr;
@property (nonatomic,copy) NSString *currentProId;//购买项目的ID

@end

@implementation settingViewController





#pragma mark - SKProductsRequestDelegate



#pragma mark -BtnClicked

//-(void)seeVideoAD{//观看视频广告
//    VungleSDK* sdk = [VungleSDK sharedSDK];
//    NSError *error;
//    [sdk playAd:self error:&error];
//}



-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [mainTable reloadData];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor lightGrayColor];
//    [self popGestureEnable:NO];
    
    
    CGFloat headView_Height = 90;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, headView_Height)];
    headView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headView];
    //返回
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, headView_Height, headView_Height)];
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    //图标
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((headView.bounds.size.width - headView_Height)*0.5, 0, headView_Height, headView_Height)];
    imageView.image = [UIImage imageNamed:@"setting"];
    [headView addSubview:imageView];
    
    UIButton *upBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    [upBtn setTitle:@"升级到Pro" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(buildUpView) forControlEvents:UIControlEventTouchUpInside];
    upBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    
//    NSArray *arr1 = @[@"主题(未开通)",@"清除缓存"];
//
    NSArray *arr1 = @[@"硬扫描",@"联网扫描"];
//    NSArray *arr2 = @[@"扫描次数"];
    NSArray *arr3 = @[@"显示标题",@"声音",@"反馈",@"为我们评分",@"更多作品"];//@"提示",
    [self.dataArr addObject:arr1];
//    [self.dataArr addObject:arr2];
    [self.dataArr addObject:arr3];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), SCREEN_WIDTH, SCREEN_HEIGHT- CGRectGetMaxY(headView.frame))];
    mainTable.backgroundColor = bgColor;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
    mainTable.tableFooterView = [[UIView alloc]init];
//    mainTable.tableHeaderView = upBtn;
    
}

/**
 升级到Pro版界面搭建
 */
-(void)buildUpView{
    proBlackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    proBlackView.backgroundColor = RGBA(0, 0, 0, 0.3);
    proBlackView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+1);
    [self.view addSubview:proBlackView];
    
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(20, 90, proBlackView.bounds.size.width - 40, proBlackView.bounds.size.height - 180)];
    alertView.layer.cornerRadius = 11;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.borderColor = [UIColor blackColor].CGColor;
    alertView.layer.borderWidth = 0.3;
    [proBlackView addSubview:alertView];
    //    阴影的颜色
    alertView.layer.shadowColor = [UIColor whiteColor].CGColor;
    //    阴影的透明度
    alertView.layer.shadowOpacity = 0.8f;
    //    阴影的圆角
    alertView.layer.shadowRadius = 4.f;
    //    阴影偏移量
    alertView.layer.shadowOffset = CGSizeMake(0,0);
    
    
    //标题
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(15,20,alertView.bounds.size.width-30,20)];
    titleLable.text = @"升级到Pro版?";
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont boldSystemFontOfSize:17];
    titleLable.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLable];
    //textView
    UILabel *messageLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x,CGRectGetMaxY(titleLable.frame)+20,titleLable.bounds.size.width,100)];
    //    messageLable.text = @"是否要升级到Pro版？或者，你也可以通过观看数个短视频来【免费】解锁。\n（还需8次）";
    messageLable.text = @"升级到Pro版将移除所有广告，不限制扫描次数，可享受更高质量的体验！";
    messageLable.textColor = RGB(64, 64, 64);
    messageLable.font = [UIFont systemFontOfSize:15];
    messageLable.textAlignment = NSTextAlignmentLeft;
    messageLable.numberOfLines = 0;
    [alertView addSubview:messageLable];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:messageLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:11];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [messageLable.text length])];
    messageLable.attributedText = attributedString;
    
    [messageLable sizeToFit];
    
    
    //购买
    UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(messageLable.frame)+40,alertView.bounds.size.width, 45)];
    buyBtn.backgroundColor = RGB(65, 152, 153);
    [buyBtn setTitle:@"升级到Pro" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(goToBuyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    buyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [alertView addSubview:buyBtn];
    
    UILabel *monLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buyBtn.frame)-90,buyBtn.y,80, buyBtn.bounds.size.height)];
    monLable.text = @"（3元）";
    monLable.textColor = [UIColor whiteColor];
    monLable.font = [UIFont systemFontOfSize:17];
    [alertView addSubview:monLable];
    
    //观看免费视频
    UIButton *recoverBtn = [[UIButton alloc]initWithFrame:CGRectMake(buyBtn.x,CGRectGetMaxY(buyBtn.frame)+25, buyBtn.bounds.size.width, buyBtn.bounds.size.height)];
    recoverBtn.backgroundColor = RGB(90, 136, 81);
    [recoverBtn setTitle:@"已购买  点此恢复" forState:UIControlStateNormal];
    [recoverBtn addTarget:self action:@selector(recoverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    recoverBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    recoverBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [alertView addSubview:recoverBtn];
    
    UILabel *seeLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(recoverBtn.frame)-45,recoverBtn.y,40, recoverBtn.bounds.size.height)];
    seeLable.text = @"免费";
    seeLable.textColor = [UIColor whiteColor];
    seeLable.font = [UIFont systemFontOfSize:17];
    //    [alertView addSubview:seeLable];
    
    //取消
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(buyBtn.x,CGRectGetMaxY(recoverBtn.frame)+25, buyBtn.bounds.size.width, buyBtn.bounds.size.height)];
    cancleBtn.backgroundColor = [UIColor clearColor];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancleBtn];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *CellID = [NSString stringWithFormat:@"oneCellID"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            
            UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 20)];
            titleLable.font = [UIFont systemFontOfSize:17];
            titleLable.textColor = [UIColor whiteColor];
            titleLable.tag = 101;
            [cell.contentView addSubview:titleLable];
            
            UILabel *infoLable = [[UILabel alloc]initWithFrame:CGRectMake(titleLable.x+5, titleLable.max_Y +10, titleLable.width, titleLable.height)];
            infoLable.font = [UIFont systemFontOfSize:12];
            infoLable.textColor = [UIColor whiteColor];
            infoLable.tag = 102;
            [cell.contentView addSubview:infoLable];
            cell.backgroundColor = bgColor;
            
            UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 25, 20, 20)];
            selectImage.image = [UIImage imageNamed:@"对号_nor"];
            selectImage.tag = 10;
            [cell.contentView addSubview:selectImage];
            
        }
        UILabel *titleLable = [cell.contentView viewWithTag:101];
        titleLable.text = self.dataArr[indexPath.section][indexPath.row];
        UILabel *infoLable = [cell.contentView viewWithTag:102];
        
        if (indexPath.row == 0) {
            infoLable.text = @"不需联网，速度较快";
            if ([[USER_DEFAULT objectForKey:viewLogo] isEqualToString:@"Tesseract"]) {
                UIImageView *selImageView = [cell.contentView viewWithTag:10];
                selImageView.image = [UIImage imageNamed:@"对号_sel"];
                titleLable.textColor = [UIColor greenColor];
                infoLable.textColor = [UIColor greenColor];
            }
        }else{
            infoLable.text = @"准确率高，速度取决于网速";
            cell.accessoryType = UITableViewCellAccessoryNone;
            if ([[USER_DEFAULT objectForKey:viewLogo] isEqualToString:@"baidu"]) {
                UIImageView *selImageView = [cell.contentView viewWithTag:10];
                selImageView.image = [UIImage imageNamed:@"对号_sel"];
                titleLable.textColor = [UIColor greenColor];
                infoLable.textColor = [UIColor greenColor];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
//    else if(indexPath.section == 1){
//        NSString *cellID = @"twoCellID";
//        ShowTimesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (cell == nil) {
//            cell = [[ShowTimesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        }
//        cell.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    else{
        if (indexPath.row == 0 || indexPath.row == 1) {
            NSString *cellID = @"switchCellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.backgroundColor = bgColor;
                cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UISwitch * switchVC = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20-50, 10, 50, 30)];
                switchVC.backgroundColor = [UIColor clearColor];
                switchVC.tag = 10+indexPath.row;
                [switchVC addTarget:self action:@selector(SwitchSelect:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switchVC];
            }
            int num = (int)(10+indexPath.row);
            UISwitch *swi = [cell.contentView viewWithTag:num];
            if (indexPath.row == 0) {//显示提示框
                if ([[USER_DEFAULT objectForKey:showWarnLable] isEqualToString:@"YES"]) {
                    [swi setOn:YES];
                }else{
                    [swi setOn:NO];
                }
            }else{//是否静音
                if ([[USER_DEFAULT objectForKey:playAudio] isEqualToString:@"YES"]) {
                    [swi setOn:YES];
                }else{
                    [swi setOn:NO];
                }
            }
            return cell;
        }
        NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.backgroundColor = bgColor;
        cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if ([cell.textLabel.text isEqualToString:@"更多作品"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@  (敬请期待)",self.dataArr[indexPath.section][indexPath.row]];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}
-(void)SwitchSelect:(UISwitch *)swi{
    if (swi.tag == 10) {//显示标题
        if (swi.isOn) {
            [USER_DEFAULT setObject:@"YES" forKey:showWarnLable];
            return;
        }
        [USER_DEFAULT setObject:@"NO" forKey:showWarnLable];
    }else{//播放声音
        if (swi.isOn) {
            [USER_DEFAULT setObject:@"YES" forKey:playAudio];
        }else{
            [USER_DEFAULT setObject:@"NO" forKey:playAudio];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 72;
    }
//    else if(indexPath.section == 1){
//        return 200;
//    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }
//    else if (section == 1){
//        return 0;
//    }
    else{
        return 25;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        titleLable.backgroundColor = [UIColor grayColor];
        titleLable.text = @"  设置扫描模式";
        titleLable.font = [UIFont systemFontOfSize:15];
        return titleLable;
    }
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor grayColor];
        return view;
    }
    else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *titleName = self.dataArr[indexPath.section][indexPath.row];
//    self.dataArr = @[@"报告问题",@"去App Store评分",@"推荐给好友",@"注意事项"];
    if ([titleName isEqualToString:@"硬扫描"]) {
        [self changeOCRModel:(int)indexPath.row];
    }else if ([titleName isEqualToString:@"联网扫描"]){
        [self changeOCRModel:(int)indexPath.row];
        
    }else if ([titleName isEqualToString:@"提示"]){
        
    }else if ([titleName isEqualToString:@"视频教程"]){
        
    }else if ([titleName isEqualToString:@"反馈"]){
        sendMessageViewController *vc = [[sendMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleName isEqualToString:@"为我们评分"]){
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", @"1362392015"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if ([titleName isEqualToString:@"更多作品"]){
        
    }else{
    }
    
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)storeProductVC {
    [storeProductVC dismissViewControllerAnimated:YES completion:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}




-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - numTableViewCellBtnClickedDelegate
-(void)numCellBtnClicked:(int)style{
    if (style == 11) {//升级到Pro版
        [self buildUpView];
    }else{//观看视频广告
        [self seeTheVideoMethod];
    }
}

#pragma mark - buyViewBtnClick
-(void)seeTheVideoMethod{
    
    
}

-(void)goToBuyBtnClicked{//去购买
    
//    if ([[USER_DEFAULT objectForKey:kIsVip] isEqualToString:@"YES"]) {
//        [AllMethod showAltMsg:@"现已是Pro版，无需重复购买！" WithController:self WithAction:nil];
//        return;
//    }
//    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
//    if(![IAPShare sharedHelper].iap) {
//        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"stitchProID", nil];
//        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
//    }
//    
//    [IAPShare sharedHelper].iap.production = NO;
//    
//    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
//     {
//         if(response > 0 ) {
//             SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
//             
//             NSLog(@"Price: %@",[[IAPShare sharedHelper].iap getLocalePrice:product]);
//             NSLog(@"Title: %@",product.localizedTitle);
//             
//             [[IAPShare sharedHelper].iap buyProduct:product
//                                        onCompletion:^(SKPaymentTransaction* trans){
//                                            
//                                            if(trans.error)
//                                            {
//                                                NSLog(@"Fail:: %@",[trans.error localizedDescription]);
//                                                [AllMethod showAltMsg:[trans.error localizedDescription] WithController:self WithAction:nil];
//                                                [WSProgressHUD dismiss];
//                                            }
//                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
//                                                
//                                                [[IAPShare sharedHelper].iap checkReceipt:trans.transactionReceipt onCompletion:^(NSString *response, NSError *error) {
//                                                    //Convert JSON String to NSDictionary
//                                                    NSDictionary* rec = [IAPShare toJSON:response];
//                                                    NSLog(@"验证结果：：%@",rec);
//                                                    if([rec[@"status"] integerValue]==0){
//                                                        [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
//                                                        NSLog(@"SUCCESS %@",response);
//                                                        NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
//                                                        [USER_DEFAULT setObject:@"YES" forKey:kIsVip];
//                                                    }
//                                                    else {
//                                                        NSLog(@"Fail222222");
//                                                        [USER_DEFAULT setObject:@"NO" forKey:kIsVip];
//                                                        [AllMethod showAltMsg:response WithController:self WithAction:nil];
//                                                        
//                                                    }
//                                                    
//                                                }];
//                                            }
//                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
//                                                NSLog(@"Fail33333333");
//                                                [USER_DEFAULT setObject:@"NO" forKey:kIsVip];
//                                            }
//                                            [WSProgressHUD dismiss];
//                                        }];
//         }
//     }];

}
-(void)recoverBtnClicked{
//    [MobClick event:@"recoverBuyPro"];
//    if ([[USER_DEFAULT objectForKey:kIsVip] isEqualToString:@"YES"]) {
//        [AllMethod showAltMsg:@"现已是Pro版，无需恢复" WithController:                                                                                   self WithAction:nil];
//    }
//    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
//    if(![IAPShare sharedHelper].iap) {
//        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"stitchProID", nil];
//        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
//    }
//
//    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {
//        [WSProgressHUD dismiss];
//
//        if (error) {
//            [AllMethod showAltMsg:[NSString stringWithFormat:@"%@",[error localizedDescription]] WithController:self WithAction:nil];
//
//
//            return ;
//        }
//        for (SKPaymentTransaction *transaction in payment.transactions){
//            NSString *purchased = transaction.payment.productIdentifier;
//            if([purchased isEqualToString:@"stitchProID"]){
//                NSLog(@"恢复成功");
//                [USER_DEFAULT setObject:@"YES" forKey:kIsVip];
//            }else{
//                NSLog(@"恢复失败");
//                [AllMethod showAltMsg:@"恢复失败，请确认该账号之前购买过该产品。" WithController:self WithAction:nil];
//            }
//        }
//
//    }];

    
}


-(void)changeOCRModel:(int)num{
    UITableViewCell *cell_1 = (UITableViewCell *)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageView_1 = [cell_1 viewWithTag:10];
    UILabel *titleLable_1 = [cell_1 viewWithTag:101];
    UILabel *infoLable_1 = [cell_1 viewWithTag:102];
    
    UITableViewCell *cell_2 = (UITableViewCell *)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UIImageView *imageView_2 = [cell_2 viewWithTag:10];
    UILabel *titleLable_2 = [cell_2 viewWithTag:101];
    UILabel *infoLable_2 = [cell_2 viewWithTag:102];
    
    if (num == 0) {
        imageView_1.image = [UIImage imageNamed:@"对号_sel"];
        imageView_2.image = [UIImage imageNamed:@"对号_nor"];
        titleLable_1.textColor = [UIColor greenColor];
        infoLable_1.textColor = [UIColor greenColor];
        titleLable_2.textColor = [UIColor whiteColor];
        infoLable_2.textColor = [UIColor whiteColor];
        [USER_DEFAULT setObject:@"Tesseract" forKey:viewLogo];
    }else{//百度
        imageView_1.image = [UIImage imageNamed:@"对号_nor"];
        imageView_2.image = [UIImage imageNamed:@"对号_sel"];
        titleLable_1.textColor = [UIColor whiteColor];
        infoLable_1.textColor = [UIColor whiteColor];
        titleLable_2.textColor = [UIColor greenColor];
        infoLable_2.textColor = [UIColor greenColor];
        [USER_DEFAULT setObject:@"baidu" forKey:viewLogo];
    }
}

-(void)cancleBtnClicked{
    [UIView animateWithDuration:0.5 animations:^{
        proBlackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [proBlackView removeFromSuperview];
        proBlackView = nil;
    }];
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


@end


