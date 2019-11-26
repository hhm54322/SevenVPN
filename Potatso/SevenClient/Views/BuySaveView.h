//
//  BuySaveView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/21.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuySaveView;
//代理方法
@protocol BuySaveViewDelegate <NSObject>

- (void)backClick;

@end

@interface BuySaveView : UIView

@property(nonatomic,assign)id<BuySaveViewDelegate> delegate;

+ (id)buySaveView;

- (void)setItemList:(NSMutableArray *)buySaveDataArray;

@end
