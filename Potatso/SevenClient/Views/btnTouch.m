//
//  FAQView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "FAQView.h"

@implementation FAQView

+ (id)faqView
{
    FAQView* faqView = [[self alloc] init];
    return faqView;
}

- (void)btnBack:(UIButton*)btn{
    [_delegate btnClick:BACK_BTN_FAQVIEW andSubType:0];
}

- (void)btnOther:(UIButton*)btn{
    [_delegate btnClick:OTHER_BTN_FAQVIEW andSubType:0];
}

- (void)btnShare:(UIButton*)btn{
    [_delegate btnClick:SHARE_BTN_FAQVIEW andSubType:0];
}

- (void)btnFAQ:(UIButton*)btn{
    [_delegate btnClick:FAQ_BTN_FAQVIEW andSubType:(short)btn.tag];
}

- (void)addTopTabbar{
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat selfX = 0;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = rectStatus.size.height * 3;
    CGFloat selfY = 0;
    //添加背景图
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    background.image = [UIImage imageNamed:@"frame_0"];
    [self addSubview:background];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selfX = 0;
    selfW = self.frame.size.width / 14;
    selfH = rectStatus.size.height * 1.5;
    selfY = rectStatus.size.height + (rectStatus.size.height * 2 - selfH) / 2;
    backBtn.frame = CGRectMake(selfX, selfY, selfW, selfH);
    UIImage *arrowImage = [UIImage imageNamed:@"backArrow"];
    [backBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //用户手册文本
    UILabel *labelLogo = [[UILabel alloc] init];
    selfX = self.frame.size.width / 3;
    selfW = self.frame.size.width / 3;
    labelLogo.frame = CGRectMake(selfX, selfY, selfW, selfH);
    labelLogo.font = [UIFont fontWithName:@"BigruixianBlackGBV1.0" size:22.0];
    labelLogo.text = @"用户手册";
    labelLogo.textAlignment = NSTextAlignmentCenter;
    labelLogo.textColor = [UIColor whiteColor];
    [self addSubview:labelLogo];
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    //添加顶部菜单栏
    [self addTopTabbar];
    
}

- (void)dealloc{
    NSLog(@"FAQView被销毁");
}

@end
