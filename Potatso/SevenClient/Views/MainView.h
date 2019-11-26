//
//  MainView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/5.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaData.h"

enum {
    SERVICE_BTN_MAINVIEW = 0,
    FAQ_BTN_MAINVIEW = 1,
    AUTO_BTN_MAINVIEW = 2,
    USERINFO_BTN_MAINVIEW = 3,
    BUY_BTN_MAINVIEW = 4,
    CONNECT_BTN_MAINVIEW = 5,
    CHANGEAREA_BTN_MAINVIEW = 6,
    SIGN_BTN_MAINVIEW = 7
};

enum {
    HONGKONG = 0,
    ANIMATION = 1,
    KOREA = 2,
    JAPAN = 3
};

@class MainView;

//代理方法
@protocol MainViewDelegate <NSObject>

- (void)mainView:(MainView*)mainView andDidSelectedItem:(UIButton*)item andSelectedIndex:(int)selectedIndex;

@end

@interface MainView : UIView

@property(nonatomic,assign)id<MainViewDelegate> delegate;

@property (nonatomic) NSInteger circleState;

+ (id)mainView;

- (void)updateSignState:(BOOL)isSign;

- (void)updateServiceState:(BOOL)isService;

- (void)updateSignFlow:(float)value;

- (void)showAddFlowLabel:(float)value;

- (void)startAnimationByConnectImage;

- (void)setConnectStates:(NSInteger)states;

- (void)setRedPointVisible;

- (void)connectFun;

- (void)setEndTimeFun:(NSInteger)times;

- (void)setFlowLabelFun:(float)flowValue;

- (NSInteger)getConnectStates;

- (void)startPing;

- (void)stopPing;

- (void)updateNewUserInfo:(BOOL)value;

@end
