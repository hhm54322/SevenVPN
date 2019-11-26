//
//  UserInfoController.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/21.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoController : UIViewController

//TODO: 声明用来回调的 Block
@property (nonatomic, copy) void(^userInfoController_block)(int areaId);

@end
