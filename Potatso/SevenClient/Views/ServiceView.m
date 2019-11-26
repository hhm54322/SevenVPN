//
//  ServiceView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "ServiceView.h"

@implementation ServiceView{
    UIImageView *m_tipsImage;
    NSTimer *m_timer;
    float m_value;
    BOOL m_isFadeIn;
    float m_waitTime;
}

+ (id)serviceView
{
    ServiceView* serviceView = [[self alloc] init];
    return serviceView;
}

- (void)btnBack:(UIButton*)btn{
    [_delegate btnClick:BACK_BTN_SERVICEVIEW];
}

- (void)btnClear:(UIButton*)btn{
    [_delegate btnClick:CLEAR_BTN_SERVICEVIEW];
}

- (void)btnSendMail:(UIButton*)btn{
    [_delegate btnClick:SENDMAIL_BTN_SERVICEVIEW];
}

- (void)addTopTabbar{
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfX = 0;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = rectStatus.size.height * 2.5;
    CGFloat selfY = 0;
    //添加背景图
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    background.image = [UIImage imageNamed:@"frame_0"];
    [self addSubview:background];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selfX = 0;
    selfH = rectStatus.size.height * 1.5;
    selfW = selfH * 1.5;
    selfY = rectStatus.size.height;
    backBtn.frame = CGRectMake(selfX, selfY, selfW, selfH);
    UIImage *arrowImage = [UIImage imageNamed:@"backArrow"];
    [backBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //客服文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 3;
    selfW = self.frame.size.width / 3;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelLogo.text = @"客服";
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
    
    //说明文本底图
    selfX = 0;
    selfY = rectStatus.size.height * 2.5;
    selfW = self.frame.size.width;
    selfH = rectStatus.size.height * 2.5;
    UIImageView *imageDes = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    imageDes.backgroundColor = [UIColor colorWithRed:11/255.0 green:18/255.0 blue:22/255.0 alpha:1];
    [self addSubview:imageDes];
    
    //说明文本
    UILabel *labelDes = [[UILabel alloc] init];
    labelDes.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelDes.adjustsFontSizeToFitWidth = YES;
    labelDes.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelDes.text = @"十分抱歉对您造成困扰";
    labelDes.textAlignment = NSTextAlignmentCenter;
    labelDes.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
    [self addSubview:labelDes];
    
    
    selfX = 0;
    selfW = self.frame.size.width;
    selfH = self.frame.size.height - rectStatus.size.height * 10;
    selfY = rectStatus.size.height * 5;
    UILabel * labelEmail = [[UILabel alloc] init];
    labelEmail.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelEmail.adjustsFontSizeToFitWidth = YES;
    labelEmail.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:18.0];
    labelEmail.text = @"收到您的反馈后\n我们将在一周内回复您\npaopaonetworks@gmail.com";
    labelEmail.textAlignment = NSTextAlignmentCenter;
    labelEmail.textColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1];
    labelEmail.numberOfLines = 0;
    [self addSubview:labelEmail];
}

- (void)addSendMailBtnAndTips{
    CGFloat selfX = 0;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = selfW * 0.125;
    CGFloat selfY = self.frame.size.height - selfH;
    UIButton *sendMailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMailBtn.frame = CGRectMake(selfX, selfY, selfW, selfH);
    [sendMailBtn setBackgroundImage:[UIImage imageNamed:@"button_1_7"] forState:UIControlStateNormal];
    [sendMailBtn addTarget:self action:@selector(btnSendMail:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendMailBtn];

    m_tipsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips3"]];
    [m_tipsImage setFrame:CGRectMake((self.frame.size.width - m_tipsImage.frame.size.width) / 2, self.frame.size.height / 4, m_tipsImage.frame.size.width, m_tipsImage.frame.size.height)];
    m_tipsImage.alpha = 0;
    [self addSubview:m_tipsImage];
}

- (void)showCompile{
    [m_tipsImage setImage:[UIImage imageNamed:@"tips3"]];
    m_tipsImage.transform = CGAffineTransformMakeScale(1, 1);
    m_waitTime = 0;
    [self startAnimation];
}

- (void)showFail{
    [m_tipsImage setImage:[UIImage imageNamed:@"tips4"]];
    m_tipsImage.transform = CGAffineTransformMakeScale(1, 1);
    m_waitTime = 0;
    [self startAnimation];
}

- (void)showPrompt{
    [m_tipsImage setImage:[UIImage imageNamed:@"tips5"]];
    if(self.frame.size.width * 2 > 2000){
        m_tipsImage.transform = CGAffineTransformMakeScale(1, 1);
    }else if(self.frame.size.width * 2 > 1500){
        m_tipsImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }else if(self.frame.size.width * 2 > 1000){
        m_tipsImage.transform = CGAffineTransformMakeScale(0.6, 0.6);
    }else if(self.frame.size.width * 2 > 600){
        m_tipsImage.transform = CGAffineTransformMakeScale(0.45, 0.45);
    }else{
        m_tipsImage.transform = CGAffineTransformMakeScale(0.4, 0.4);
    }
    m_waitTime = 1.5f;
    [self startAnimation];
}

- (void)startAnimation{
    m_value = 0;
    m_isFadeIn = YES;
    if(m_timer == nil){
        m_timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animationFun) userInfo:nil repeats:YES];
    }else{
        [m_timer setFireDate:[NSDate distantPast]];
    }
}
- (void)stopAnimation{
    if(m_timer){
        [m_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)animationFun{
    m_tipsImage.alpha = m_value;
    if(m_isFadeIn){
        m_value += 0.02;
        if(m_value >= 1){
            if(m_waitTime > 0){
                [NSThread sleepForTimeInterval:1.0f];
            }
            m_isFadeIn = NO;
        }
    }else{
        m_value -= 0.02;
        if(m_value <= 0){
            [self stopAnimation];
        }
    }
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1];
    //添加顶部菜单栏
    [self addTopTabbar];
    
    //添加发送邮件按钮
    //[self addSendMailBtnAndTips];
}

- (void)dealloc{
    NSLog(@"ServiceView被销毁");
}

@end
