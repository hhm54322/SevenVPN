//
//  FAQController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/28.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "FAQController.h"
#import "FAQView.h"

@interface FAQController ()<FAQViewDelegate>

@end

@implementation FAQController{
    FAQView *m_FAQView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addFAQView];
}

- (void)addFAQView{
    m_FAQView = [FAQView faqView];
    [self.view addSubview:m_FAQView];
    m_FAQView.delegate = self;
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

#pragma FAQView代理方法
- (void)btnClick:(int)type andSubType:(int)subType{
    switch (type) {
        case BACK_BTN_FAQVIEW:
            [self backFun];
            break;
        case FAQ_BTN_FAQVIEW:
            
            break;
        case OTHER_BTN_FAQVIEW:
            
            break;
        case SHARE_BTN_FAQVIEW:
            
            break;
            
        default:
            break;
    }
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
    NSLog(@"FAQController被销毁");
}

@end
