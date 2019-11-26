//
//  AreaUI.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/24.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaData.h"

@class AreaUI;

//代理方法
@protocol AreaUIDelegate <NSObject>

- (void)areaUI:(int)selectedIndex;

@end

@interface AreaUI : UIView

+ (id)areaUI;

@property(nonatomic,assign)AreaData *dict;

@property(nonatomic,assign)id<AreaUIDelegate> delegate;

@end
