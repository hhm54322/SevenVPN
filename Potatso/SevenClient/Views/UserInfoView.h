//
//  UserInfoView.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/19.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    BACK_BTN_USERINFOVIEW = 0,
    SERVICE_BTN_USERINFOVIEW = 1,
    BUYSAVE_BTN_USERINFOVIEW = 2,
    USERCENTER_BTN_USERINFOVIEW = 3,
    SHARE_BTN_USERINFOVIEW = 4
};

@class UserInfoView;

//代理方法
@protocol UserInfoViewDelegate <NSObject>

- (void)userInfoView:(UserInfoView*)userInfoView andDidSelectedItem:(UIButton*)item andSelectedIndex:(int)selectedIndex;

@end

@interface UserInfoView : UIView<UITableViewDelegate,UITableViewDataSource>{
    UITableView *m_tableView;
}

@property(nonatomic,assign)id<UserInfoViewDelegate> delegate;

+ (id)userInfoView;

@end
