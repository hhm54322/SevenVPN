//
//  IndicatorView.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/13.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView{
    UIActivityIndicatorView *_indicator;
}

+ (id)indicatorView
{
    IndicatorView* indicatorView = [[self alloc] init];
    return indicatorView;
}

- (void)startAnimation:(UIView*)view{
    self.hidden = NO;
    [view bringSubviewToFront:self];
    [_indicator startAnimating];
}

- (void)endAnimation:(UIView*)view{
    [_indicator stopAnimating];
    self.hidden = YES;
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
-(void) willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    [self addSubview:_indicator];
    NSLog(@"willMoveToSuperview = %d",_indicator.isAnimating);
}

@end
