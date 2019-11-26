//
//  ServiceController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/28.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "ServiceController.h"
#import "ServiceView.h"
#import <MessageUI/MessageUI.h>

@interface ServiceController ()<ServiceViewDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation ServiceController{
    ServiceView *m_serviceView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addServiceView];
}

- (void)addServiceView{
    m_serviceView = [ServiceView serviceView];
    [self.view addSubview:m_serviceView];
    m_serviceView.delegate = self;
}

- (void)backFun{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma ServiceView代理方法
- (void)btnClick:(int)type{
    switch (type) {
        case BACK_BTN_SERVICEVIEW:
            [self backFun];
            break;
        case CLEAR_BTN_SERVICEVIEW:
            
            break;
        case SENDMAIL_BTN_SERVICEVIEW:
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmailAction]; // 调用发送邮件的代码
            }else{
                [m_serviceView showPrompt];
            }
            break;
            
        default:
            break;
    }
}

- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"意见反馈"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"paopaonetwork@gmail.com"]];
    // 设置抄送人
    //[mailCompose setCcRecipients:@[@"邮箱号码"]];
    // 设置密抄送
    //  [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    //设置邮件的正文内容
    NSString *emailContent = @"抱歉给您造成了困扰，请描述您的反馈内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            [m_serviceView showCompile];
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            [m_serviceView showFail];
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    NSLog(@"ServiceController被销毁");
}


@end
