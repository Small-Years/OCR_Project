//
//  sendMessageViewController.m
//  StitchImage
//
//  Created by yangjian on 2017/3/29.
//  Copyright © 2017年 yangjian. All rights reserved.
//

#import "sendMessageViewController.h"

#define placeHolderStr @"有任何建议或者问题请在这里写下吧，我们会努力做到更好..."

@interface sendMessageViewController ()<UITextViewDelegate,UIScrollViewDelegate>{
    
    UITextView *messageTextView;//发送消息框
    UIScrollView *mainScrollView;
    UITextField *email_Text;
}

@end

@implementation sendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈";
    self.navigationItem.rightBarButtonItem = [AllMethod getButtonBarItemWithTitle:@"提交" andSelect:@selector(sendMessageBtnClicked) andTarget:self];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, 45, 32);
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendMessageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setShowsTouchWhenHighlighted:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mainScrollView.backgroundColor = [UIColor grayColor];
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-63);
    [self.view addSubview:mainScrollView];
    
    messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-20,150)];
    messageTextView.backgroundColor = [UIColor lightGrayColor];
    messageTextView.textColor = [UIColor darkGrayColor];
    messageTextView.text = placeHolderStr;
    messageTextView.font = [UIFont systemFontOfSize:19];
    messageTextView.delegate = self;
    messageTextView.layer.cornerRadius = 7;
    messageTextView.layer.borderWidth = 0.4;
    messageTextView.layer.borderColor = [UIColor blackColor].CGColor;
    [mainScrollView addSubview:messageTextView];
    
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(messageTextView.frame)+25,SCREEN_WIDTH,20)];
    titleLable.text = @"请留下联系方式方便我们与您取得联系(非必填)";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textAlignment = NSTextAlignmentLeft;
    [mainScrollView addSubview:titleLable];
    
    email_Text = [[UITextField alloc]initWithFrame:CGRectMake(messageTextView.x, CGRectGetMaxY(titleLable.frame)+10, messageTextView.bounds.size.width,35)];
    email_Text.placeholder = @"手机号/QQ/邮箱";
    email_Text.font = [UIFont systemFontOfSize:17];
    email_Text.layer.cornerRadius = 7;
    email_Text.layer.borderWidth = 0.4;
    email_Text.layer.borderColor = [UIColor blackColor].CGColor;
    email_Text.backgroundColor = [UIColor lightGrayColor];
    [mainScrollView addSubview:email_Text];

//    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)*0.5,scr, 150, 50)];
//    [sendBtn setTitle:@"send" forState:UIControlStateNormal];
//    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    sendBtn.layer.cornerRadius = 7;
//    sendBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    sendBtn.layer.borderWidth = 1;
//    [sendBtn addTarget:self action:@selector(sendMessageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sendBtn];
    
}



#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    //计算键盘的高度，调整textView的frame
    
    if ([textView.text isEqualToString:placeHolderStr]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor whiteColor];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeHolderStr;
        textView.textColor = [UIColor darkGrayColor];
    }
}



-(void)sendMessageBtnClicked{
    NSLog(@"发送消息:%@",messageTextView.text);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)2.0*NSEC_PER_SEC), queue, ^{

    });
    
     if ([messageTextView.text isEqualToString:placeHolderStr]) {
         [WSProgressHUD showErrorWithStatus:@"你的建议呢？"];
         return;
     }
    
//    NSString *adviceStr = messageTextView.text;
    NSString *adviceStr = [NSString stringWithFormat:@"%@++++%@",messageTextView.text,email_Text.text];
    
    AVObject *testObject = [AVObject objectWithClassName:@"adviceText"];
    [testObject setObject:adviceStr forKey:@"advice"];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [WSProgressHUD showSuccessWithStatus:@"提交成功，感谢您的建议。"];
            messageTextView.text = placeHolderStr;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WSProgressHUD showErrorWithStatus:@"发送失败，请检查网络连接"];
        }
    }];// 保存到云端
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
