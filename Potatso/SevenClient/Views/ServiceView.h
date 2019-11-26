//
//  ServiceView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    BACK_BTN_SERVICEVIEW = 0,
    CLEAR_BTN_SERVICEVIEW = 1,
    SENDMAIL_BTN_SERVICEVIEW = 2,
};

@class ServiceView;
//代理方法
@protocol ServiceViewDelegate <NSObject>

- (void)btnClick:(int)type;

@end

@interface ServiceView : UIView

@property(nonatomic,assign)id<ServiceViewDelegate> delegate;

+ (id)serviceView;

- (void)showCompile;

- (void)showFail;

- (void)showPrompt;

@end
