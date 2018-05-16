//
//  showBuyView.m
//  StitchImage
//
//  Created by yangjian on 2017/4/26.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "showBuyView.h"
@interface showBuyView()
@property (nonatomic,strong)UIScrollView * proBlackView;

@end

@implementation showBuyView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.proBlackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.proBlackView.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.proBlackView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+1);
        [self addSubview:self.proBlackView];
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(20, 75, self.proBlackView.bounds.size.width - 40, self.proBlackView.bounds.size.height - 150)];
        alertView.layer.cornerRadius = 11;
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.layer.borderColor = [UIColor blackColor].CGColor;
        alertView.layer.borderWidth = 0.3;
        [self.proBlackView addSubview:alertView];
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
        messageLable.text = @"升级到Pro版将移除所有广告，不限制选择图片数目，可享受更完美的体验！";
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
        UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(messageLable.frame)+40,alertView.bounds.size.width, 50)];
        buyBtn.backgroundColor = RGB(65, 152, 153);
        [buyBtn setTitle:@"升级到Pro" forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(goToBuy) forControlEvents:UIControlEventTouchUpInside];
        buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        buyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [alertView addSubview:buyBtn];
        
        UILabel *monLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buyBtn.frame)-40,buyBtn.y,35, buyBtn.bounds.size.height)];
        monLable.text = @"3元";
        monLable.textColor = [UIColor whiteColor];
        monLable.font = [UIFont systemFontOfSize:17];
        [alertView addSubview:monLable];
        
        //观看免费视频
        UIButton *recoverBtn = [[UIButton alloc]initWithFrame:CGRectMake(buyBtn.x,CGRectGetMaxY(buyBtn.frame)+30, buyBtn.bounds.size.width, buyBtn.bounds.size.height)];
        recoverBtn.backgroundColor = RGB(90, 136, 81);
        [recoverBtn setTitle:@"恢复购买" forState:UIControlStateNormal];
        [recoverBtn addTarget:self action:@selector(recoverBtn) forControlEvents:UIControlEventTouchUpInside];
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
        [cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:cancleBtn];
        
    }
    return self;
}

-(void)disMissShowView{
    [UIView animateWithDuration:0.5 animations:^{
        self.proBlackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.proBlackView = nil;
    }];
}
-(void)goToBuy{// 立即开通
    if ([self respondsToSelector:@selector(goToBuyBtnClicked)]) {
        [self.delegate goToBuyBtnClicked];
    }
}

-(void)cancleBtn{//取消
    if ([self respondsToSelector:@selector(cancleBtnClicked)]) {
        [self.delegate cancleBtnClicked];
    }
}
-(void)recoverBtn{//恢复购买
    if ([self respondsToSelector:@selector(recoverBtnClicked)]) {
        [self.delegate recoverBtnClicked];
    }
}

@end
