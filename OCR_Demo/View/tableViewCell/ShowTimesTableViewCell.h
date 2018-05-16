//
//  ShowTimesTableViewCell.h
//  OCR_Demo
//
//  Created by yangjian on 2018/3/21.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowTimesTableViewCell;

@protocol numTableViewCellBtnClickedDelegate<NSObject>


/**
 btn点击事件
 @param style 11:升级到Pro，12：获取免费次数
 */
-(void)numCellBtnClicked:(int)style;

@end


@interface ShowTimesTableViewCell : UITableViewCell

@property (nonatomic,weak)UILabel *numLable;

@property(nonatomic,assign)id<numTableViewCellBtnClickedDelegate> delegate;
@end
