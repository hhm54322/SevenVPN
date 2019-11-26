//
//  BuySaveController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/21.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "BuySaveController.h"
#import "BuySaveView.h"
#import "UserInfo.h"
#import "HttpUtils.h"


@interface BuySaveController ()<BuySaveViewDelegate>

@end

@implementation BuySaveController{
    BuySaveView *m_buySaveView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBuySaveView];
    
}

- (void)addBuySaveView{
    m_buySaveView = [BuySaveView buySaveView];
    [self.view addSubview:m_buySaveView];
    m_buySaveView.delegate = self;
    [m_buySaveView setItemList:[UserInfo getInstance].buySaveArray];
}

#pragma BuySaveView代理方法
- (void)backClick{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
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
    NSLog(@"BuySaveController被销毁");
}


@end
