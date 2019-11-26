//
//  FAQView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    BACK_BTN_FAQVIEW = 0,
    FAQ_BTN_FAQVIEW = 1,
    OTHER_BTN_FAQVIEW = 2,
    SHARE_BTN_FAQVIEW = 3
};

@class FAQView;
//代理方法
@protocol FAQViewDelegate <NSObject>

- (void)btnClick:(int)type andSubType:(int)subType;

@end

@interface FAQView : UIView

@property(nonatomic,assign)id<FAQViewDelegate> delegate;

+ (id)faqView;

@end
