//
//  AreaController.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/22.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaController : UIViewController

//TODO: 声明用来回调的 Block
@property (nonatomic, copy) void(^change_area_block)(int areaId);

@end
