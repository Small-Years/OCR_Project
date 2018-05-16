//
//  showBuyView.h
//  StitchImage
//
//  Created by yangjian on 2017/4/26.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buyViewBtnClickDelegate <NSObject>

-(void)cancleBtnClicked;
-(void)goToBuyBtnClicked;
-(void)recoverBtnClicked;

@end

@interface showBuyView : UIView

@property (nonatomic,weak)id <buyViewBtnClickDelegate> delegate;


-(void)disMissShowView;
-(instancetype)init;

@end
