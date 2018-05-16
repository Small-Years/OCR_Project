//
//  PhoneNumerTableViewCell.m
//  OCR_Demo
//
//  Created by yangjian on 2018/3/21.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import "PhoneNumerTableViewCell.h"
#import "Masonry.h"

@implementation PhoneNumerTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat cellHeight = 60;
        UILabel *phoneText = [[UILabel alloc]initWithFrame:CGRectMake(10,0,140,cellHeight)];
        phoneText.text = @"";
        phoneText.textColor = [UIColor greenColor];
        phoneText.font = [UIFont systemFontOfSize:20];
        phoneText.textAlignment = NSTextAlignmentLeft;
        [self addSubview:phoneText];
        self.phoneText = phoneText;
        
        CGFloat lessWidth = SCREEN_WIDTH - phoneText.max_X;
        CGFloat padding;
        CGFloat btnWidth;
        if (lessWidth > cellHeight*3) {
            padding = (lessWidth - cellHeight*3)/4;
            btnWidth = cellHeight;
        }else{
            padding = 0;
            btnWidth = lessWidth / 3;
        }
        
        UIButton *copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(phoneText.max_X+padding,0, btnWidth, btnWidth)];
        copyBtn.centerY = phoneText.centerY;
        [copyBtn setImage:[UIImage imageNamed:@"btnStyleCopy"] forState:UIControlStateNormal];
        [copyBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        copyBtn.tag = 10;
        [self addSubview:copyBtn];
        
        UIButton *messageBtn = [[UIButton alloc]initWithFrame:CGRectMake(copyBtn.max_X+padding,0, btnWidth, btnWidth)];
        messageBtn.centerY = phoneText.centerY;
        [messageBtn setImage:[UIImage imageNamed:@"btnStyleMessage"] forState:UIControlStateNormal];
        [messageBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        messageBtn.tag = 11;
        [self addSubview:messageBtn];
        
        UIButton *telephoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(messageBtn.max_X+padding,0, btnWidth, btnWidth)];
        telephoneBtn.centerY = phoneText.centerY;
        [telephoneBtn setImage:[UIImage imageNamed:@"btnStyleTelephone"] forState:UIControlStateNormal];
        [telephoneBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        telephoneBtn.tag = 12;
        [self addSubview:telephoneBtn];
    }
    return self;
}

-(void)btnTap:(UIButton *)btn{
    btnStyle type;
    int tag = (int)btn.tag;
    switch (tag) {
        case 10:
            type = btnStyleCopy;
            break;
        case 11:
            type = btnStyleMessage;
            break;
        case 12:
            type = btnStyleTelephone;
            break;
        default:
            type = btnStyleCopy;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(btnClicked:withNum:)]) {
        [self.delegate btnClicked:type withNum:self.phoneText.text];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
