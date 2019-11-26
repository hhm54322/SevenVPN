//
//  UserInfo.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/13.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

UserInfo *_userInfo = nil;

//单例
+ (instancetype)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[super allocWithZone:NULL] init];
    });
    return _userInfo;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [UserInfo getInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [UserInfo getInstance];
}


@end
