//
//  ShowBackResultView.h
//  OCR_Demo
//
//  Created by yangjian on 2018/5/29.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backViewBtnClickedDelegate <NSObject>
-(void)backViewcloseBtnClicked;
@end

@interface ShowBackResultView : UIView

+(ShowBackResultView *)instanceShowBackResultView;
@property(nonatomic,strong)NSDictionary *infoDict;
@property(nonatomic,assign)id <backViewBtnClickedDelegate> delegate;


@end
