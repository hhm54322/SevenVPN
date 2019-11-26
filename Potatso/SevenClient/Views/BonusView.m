//
//  BonusView.m
//  Potatso
//
//  Created by 黄慧敏 on 2017/9/29.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import "BonusView.h"

@implementation BonusView{
    UIImageView *m_tipsImage;
    UIImageView *m_image;
    NSTimer *m_timer;
    float m_value;
    BOOL m_isFadeIn;
}

+ (id)bonusView
{
    BonusView* bonusView = [[self alloc] init];
    return bonusView;
}

- (void)btnTouch:(UIButton*)btn
{
    [m_image removeFromSuperview];
    [self startTipsImage];
}

- (void)startTipsImage{
    m_value = 0;
    m_isFadeIn = YES;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animationTipsImageFun) userInfo:nil repeats:YES];
}
- (void)stopTipsImage{
    [m_timer invalidate];
    m_timer = nil;
}

- (void)animationTipsImageFun{
    m_tipsImage.alpha = m_value;
    if(m_isFadeIn){
        m_value += 0.02;
        if(m_value >= 1){
            m_isFadeIn = NO;
        }
    }else{
        m_value -= 0.02;
        if(m_value <= 0){
            [self stopTipsImage];
            [self removeFromSuperview];
        }
    }
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
    
    CGFloat selfW = self.frame.size.width * 0.9;
    CGFloat selfH = selfW * 1.04;
    CGFloat selfX = self.frame.size.width * 0.05;
    CGFloat selfY = (self.frame.size.height - selfH) * 0.38;
    m_image = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    m_image.image = [UIImage imageNamed:@"bonus-window"];
    m_image.userInteractionEnabled = YES;
    [self addSubview:m_image];
    
    selfW = m_image.frame.size.width * 0.5;
    selfH = selfW * 0.2915;
    selfX = m_image.frame.size.width * 0.25;
    selfY = m_image.frame.size.height - selfH * 1.5;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    [button setImage:[UIImage imageNamed:@"button_1_9"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [m_image addSubview:button];
    
    m_tipsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips3"]];
    [m_tipsImage setFrame:CGRectMake((self.frame.size.width - m_tipsImage.frame.size.width / 2) / 2, self.frame.size.height / 4, m_tipsImage.frame.size.width / 2, m_tipsImage.frame.size.height / 2)];
    m_tipsImage.alpha = 0;
    [self addSubview:m_tipsImage];
}

- (void)dealloc{
    NSLog(@"BonusView被销毁");
}

@end
