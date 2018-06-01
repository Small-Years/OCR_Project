//
//  ShowResultView.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/28.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "ShowResultView.h"
@interface ShowResultView()
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *minzuBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation ShowResultView
+(ShowResultView *)instanceShowResultView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ShowResultView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)drawRect:(CGRect)rect{
    self.backView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backView.layer.borderWidth = 1;
    
    self.nameBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.nameBtn.layer.borderWidth = 2;
    self.nameBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.sexBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.sexBtn.layer.borderWidth = 2;
    self.sexBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.minzuBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.minzuBtn.layer.borderWidth = 2;
    self.minzuBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.birthdayBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.birthdayBtn.layer.borderWidth = 2;
    self.birthdayBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.adressBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.adressBtn.layer.borderWidth = 2;
    self.adressBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.idCardBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.idCardBtn.layer.borderWidth = 2;
    self.idCardBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
}

-(void)setInfoDict:(NSDictionary *)infoDict{
    NSLog(@"传过来的infoDict：%@",infoDict);
    NSString *str = [infoDict objectForKey:@"birthday"];
    str = [AllMethod changeDateMethod:str From:@"yyyyMMdd" To:@"yyyy 年 MM 月 dd 日"];
    [self.birthdayBtn setTitle:str forState:UIControlStateNormal];
    
    [self.idCardBtn setTitle:[infoDict objectForKey:@"idCardNo"] forState:UIControlStateNormal];
    [self.adressBtn setTitle:[infoDict objectForKey:@"adress"] forState:UIControlStateNormal];
    
    [self.minzuBtn setTitle:[infoDict objectForKey:@"minzu"] forState:UIControlStateNormal];
    [self.sexBtn setTitle:[infoDict objectForKey:@"sex"] forState:UIControlStateNormal];
    [self.nameBtn setTitle:[infoDict objectForKey:@"name"] forState:UIControlStateNormal];
}

- (IBAction)BtnClicked:(UIButton *)sender {
    NSString *resultStr = sender.titleLabel.text;
    
    if (sender.tag == 13){//出生
        resultStr = [AllMethod changeDateMethod:resultStr From:@"yyyy 年 MM 月 dd 日" To:@"yyyy-MM-dd"];
    }
    
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = resultStr;
    [WSProgressHUD showSuccessWithStatus:@"结果已复制到剪贴板"];
}

- (IBAction)closeBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(closeBtnClicked)]) {
        [self.delegate closeBtnClicked];
    }
    [self removeFromSuperview];
}

@end
