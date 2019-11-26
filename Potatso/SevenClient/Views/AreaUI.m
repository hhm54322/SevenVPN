//
//  AreaUI.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/24.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "AreaUI.h"
#import "UserInfo.h"

@implementation AreaUI

+ (id)areaUI
{
    AreaUI *areaUI = [[AreaUI alloc] init];
    return areaUI;
}

- (void)btnTouch:(UIButton*)btn{
    [_delegate areaUI:(short)btn.tag];
}

//当视图即将被加载到父试图上去的时候，系统会自动调用
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGFloat selfX = 0;
    CGFloat selfY = 0;
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    
    //背景图片
    UIButton *backGround = [UIButton buttonWithType:UIButtonTypeCustom];
    backGround.frame = CGRectMake(selfX, selfY, selfW, selfH);
    if(_dict.areaVip){
        [backGround setBackgroundImage:[UIImage imageNamed:@"frame_7"] forState:UIControlStateNormal];
    }else{
        [backGround setBackgroundImage:[UIImage imageNamed:@"frame_5"] forState:UIControlStateNormal];
    }
    [backGround addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    backGround.tag = _dict.areaId;
    [self addSubview:backGround];
    
    //国家图标
    selfW = self.frame.size.width * 0.62;
    selfH = selfW;
    selfX = self.frame.size.width * 0.19;
    selfY = (self.frame.size.width - selfW) * 0.28;
    UIImageView *countryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
    countryIcon.image = [UIImage imageNamed:_dict.areaCode];
    [self addSubview:countryIcon];
    
    if([UserInfo getInstance].currentDefaultAreaId == _dict.areaId){
        //当前节点图标
        selfW = countryIcon.frame.size.width / 2;
        selfH = selfW / 2;
        selfX = countryIcon.frame.origin.x + selfW;
        selfY = countryIcon.frame.origin.y;
        UIImageView *isCurrentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(selfX, selfY, selfW, selfH)];
        isCurrentIcon.image = [UIImage imageNamed:@"frame_8"];
        [self addSubview:isCurrentIcon];
    }
    
}

- (void)dealloc{
    NSLog(@"AreaUI被销毁");
}

@end
