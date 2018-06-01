//
//  ShowBackResultView.m
//  OCR_Demo
//
//  Created by yangjian on 2018/5/29.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "ShowBackResultView.h"
@interface ShowBackResultView()
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *showLable;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation ShowBackResultView
+(ShowBackResultView *)instanceShowBackResultView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ShowBackResultView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)btnClicked:(UIButton *)sender {
    NSString *resultStr = sender.titleLabel.text;
    if (sender.tag == 20){//开始日期
        resultStr = [AllMethod changeDateMethod:resultStr From:@"yyyy.MM.dd" To:@"yyyy-MM-dd"];
    }else if (sender.tag == 21){//结束日期
        resultStr = [AllMethod changeDateMethod:resultStr From:@"yyyy.MM.dd" To:@"yyyy-MM-dd"];
    }
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = resultStr;
}
- (void)drawRect:(CGRect)rect{
    self.backView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backView.layer.borderWidth = 1;
    
    self.placeBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.placeBtn.layer.borderWidth = 2;
    self.placeBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.startDateBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.startDateBtn.layer.borderWidth = 2;
    self.startDateBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.endDateBtn.layer.borderColor = RGB(126, 185, 255).CGColor;
    self.endDateBtn.layer.borderWidth = 2;
    self.endDateBtn.backgroundColor = RGBA(126, 185, 255, 0.5);
    
    self.showLable.layer.cornerRadius = 9;
}

-(void)setInfoDict:(NSDictionary *)infoDict{
    NSLog(@"传过来的infoDict：%@",infoDict);
    NSString *startStr = [infoDict objectForKey:@"startDate"];
    startStr = [AllMethod changeDateMethod:startStr From:@"yyyyMMdd" To:@"yyyy.MM.dd"];
    
    NSString *endStr = [infoDict objectForKey:@"endDate"];
    endStr = [AllMethod changeDateMethod:endStr From:@"yyyyMMdd" To:@"yyyy.MM.dd"];
    
    [self.placeBtn setTitle:[infoDict objectForKey:@"place"] forState:UIControlStateNormal];
    [self.startDateBtn setTitle:startStr forState:UIControlStateNormal];
    [self.endDateBtn setTitle:endStr forState:UIControlStateNormal];
}
- (IBAction)closebtnClicked:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
