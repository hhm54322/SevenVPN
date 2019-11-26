//
//  UserInfoController.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/21.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "UserInfoController.h"
#import "BuySaveController.h"
#import "UserInfoView.h"
#import "ServiceController.h"
#import "UserCenterController.h"

@interface UserInfoController ()<UserInfoViewDelegate>

@end

@implementation UserInfoController{
    UserInfoView *m_userInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载账户信息界面
    [self addUserInfoView];
}

- (void)addUserInfoView{
    m_userInfoView = [UserInfoView userInfoView];
    [self.view addSubview:m_userInfoView];
    m_userInfoView.delegate = self;
}

- (void)backController{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    if(self.userInfoController_block){
        [self dismissViewControllerAnimated:NO completion:^{self.userInfoController_block(1);}];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)jumpToBuySaveView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        BuySaveController *buySaveController = [[BuySaveController alloc] init];
        [self presentViewController:buySaveController animated:NO completion:nil];
    });
}

- (void)jumpToServiceView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        ServiceController *serviceController = [[ServiceController alloc] init];
        [self presentViewController:serviceController animated:NO completion:nil];
    });
}

- (void)jumpToUserCenterView{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        UserCenterController *userCenterController = [[UserCenterController alloc] init];
        [self presentViewController:userCenterController animated:NO completion:nil];
    });
}

#pragma UserInfoView代理方法
- (void)userInfoView:(UserInfoView *)userInfoView andDidSelectedItem:(UIButton *)item andSelectedIndex:(int)selectedIndex{
    NSLog(@"你点击了账户信息界面的按钮，tag = %d",selectedIndex);
    switch (selectedIndex) {
        case BACK_BTN_USERINFOVIEW:
            [self backController];
            break;
        case SERVICE_BTN_USERINFOVIEW:
            [self jumpToServiceView];
            break;
        case BUYSAVE_BTN_USERINFOVIEW:
             [self jumpToBuySaveView];
            break;
        case USERCENTER_BTN_USERINFOVIEW:
            [self jumpToUserCenterView];
            break;
        case SHARE_BTN_USERINFOVIEW:
            
            break;
        default:
            break;
    }
    
}

//TODO: Block Set方法(必写)
- (void)setUserInfoController_block:(void (^)(int))userInfoController_block{
    _userInfoController_block = userInfoController_block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    NSLog(@"UserInfoController被销毁");
}

@end
