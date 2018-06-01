//
//  ShowResultView.h
//  OCR_Demo
//
//  Created by yangjian on 2018/5/28.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol btnClickedDelegate <NSObject>
-(void)closeBtnClicked;
@end

@interface ShowResultView : UIView

//-(instancetype)init;
+(ShowResultView *)instanceShowResultView;

@property(nonatomic,strong)NSDictionary *infoDict;

@property(nonatomic,assign)id <btnClickedDelegate> delegate;
@end
