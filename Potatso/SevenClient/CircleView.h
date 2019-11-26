//
//  CircleView.h
//  Potatso
//
//  Created by 黄慧敏 on 2017/9/14.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, STClockWiseType) {
    STClockWiseYes,
    STClockWiseNo
};

enum {
    DISCONNECT_STATE = 0,
    CONNECTING_STATE = 1,
    CONNECT_STATE = 2,
};

@class CircleView;
//代理方法
@protocol CircleViewDelegate <NSObject>

- (void)btnClick:(NSInteger)type;

@end

@interface CircleView : UIView

@property(nonatomic,assign)id<CircleViewDelegate> delegate;

@property (assign, nonatomic) CGFloat persentage;

@property (nonatomic) NSInteger circleState;//0,未连接。  1,连接中。  2,已连接

+ (id)circleView;

- (void)setConnectStates:(NSInteger)states;

@end
