//
//  UserCenterView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    BACK_BTN_USERCENTERVIEW = 0,
    BUY_BTN_USERCENTERVIEW = 1
};

@class UserCenterView;
//代理方法
@protocol UserCenterViewDelegate <NSObject>

- (void)btnClick:(int)type andSubType:(int)subType;

@end

@interface UserCenterView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *m_tableView;
}

@property(nonatomic,assign)id<UserCenterViewDelegate> delegate;

+ (id)userCenterView;

- (void)updateTableView;

@end
