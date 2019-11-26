//
//  MainController.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/5.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    Main_View = 0,
    UserInfo_View = 1,
    UserHelp_View = 2,
    Advert_View = 3
};

@interface MainController : UIViewController

- (void)closeVPN;

@end
