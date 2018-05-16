//
//  ShowTimesTableViewCell.m
//  OCR_Demo
//
//  Created by yangjian on 2018/3/21.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "ShowTimesTableViewCell.h"

@implementation ShowTimesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,50)];
        titleLable.text = @"剩余免费次数";
        titleLable.textColor = [UIColor whiteColor];
        titleLable.font = [UIFont systemFontOfSize:19];
        titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLable];
        
        UILabel *numLable = [[UILabel alloc]initWithFrame:CGRectMake(0,titleLable.max_Y,SCREEN_WIDTH,60)];
        numLable.textColor = RGB(66, 178, 69);
        NSString *str = [USER_DEFAULT objectForKey:leftNum];
        if (![USER_DEFAULT objectForKey:leftNum]) {
            str = @"0";
        }
        numLable.text = [NSString stringWithFormat:@"%@ 次",str];
        numLable.font = [UIFont boldSystemFontOfSize:45];
        numLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numLable];
        NSMutableAttributedString *strr1 = [NSAttributedString_Encapsulation changeFontAndColor:[UIFont systemFontOfSize:14] Color:[UIColor whiteColor] TotalString:numLable.text SubStringArray:@[@"次"]];
        numLable.attributedText = strr1;
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, numLable.max_Y, SCREEN_WIDTH, 80)];
        btnView.backgroundColor = [UIColor clearColor];
//        btnView.layer.borderWidth = 1;
//        btnView.layer.borderColor = RGB(155, 155, 155).CGColor;
        [self addSubview:btnView];
        
        UIButton *upBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, btnView.width *0.5, 50)];
        upBtn.centerY = btnView.height*0.5;
        upBtn.backgroundColor = [UIColor clearColor];
        [upBtn setTitle:@"升级到Pro版" forState:UIControlStateNormal];
        [upBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        upBtn.layer.borderWidth = 1;
        upBtn.layer.borderColor = RGB(155, 155, 155).CGColor;
        upBtn.tag = 11;
        [upBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:upBtn];
        
        UIButton *getNumBtn = [[UIButton alloc]initWithFrame:CGRectMake(upBtn.max_X-1, upBtn.y, upBtn.width+1, upBtn.height)];
        getNumBtn.backgroundColor = [UIColor clearColor];
        [getNumBtn setTitle:@"免费获取次数" forState:UIControlStateNormal];
        [getNumBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        getNumBtn.layer.borderWidth = 1;
        getNumBtn.layer.borderColor = RGB(155, 155, 155).CGColor;
        getNumBtn.tag = 12;
        [getNumBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:getNumBtn];
    }
    return self;
}

-(void)btnClicked:(UIButton *)btn{
    int tag = (int)btn.tag;
    if ([self.delegate respondsToSelector:@selector(numCellBtnClicked:)]) {
        [self.delegate numCellBtnClicked:tag];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
