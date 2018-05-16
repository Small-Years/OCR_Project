//
//  PhoneNumerTableViewCell.h
//  OCR_Demo
//
//  Created by yangjian on 2018/3/21.
//  Copyright © 2018年 yangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSInteger{
    btnStyleCopy,
    btnStyleMessage,
    btnStyleTelephone,
}btnStyle;

@protocol TelephoneBtnDelegate<NSObject>
-(void)btnClicked:(btnStyle)style withNum:(NSString *)phoneNumber;
@end

@interface PhoneNumerTableViewCell : UITableViewCell

@property(nonatomic,weak)UILabel *phoneText;

@property(nonatomic,assign)id <TelephoneBtnDelegate> delegate;

@end
