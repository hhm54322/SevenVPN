//
//  IndicatorView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/13.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorView : UIView

+ (id)indicatorView;

- (void)startAnimation:(UIView*)view;

- (void)endAnimation:(UIView*)view;

@end
