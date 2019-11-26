//
//  AreaView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    BACK_BTN_AREAVIEW = 0,
    REFRESH_BTN_AREAVIEW = 1,
    CHANGE_BTN_AREAVIEW = 2
};

@class AreaView;

//代理方法
@protocol AreaViewDelegate <NSObject>

- (void)btnClick:(int)type andSubType:(int)subType;

@end

@interface AreaView : UIView

@property(nonatomic,copy)NSMutableArray *areaDataArray;

@property(nonatomic,assign)id<AreaViewDelegate> delegate;

+ (id)areaView:(NSMutableArray*)areaDataArray;

@end
