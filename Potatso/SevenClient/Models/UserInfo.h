//
//  UserInfo.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/13.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property(nonatomic,copy)NSString *userId;

@property(nonatomic,copy)NSString *uniqueId;

@property(nonatomic)NSInteger infiniteTime;

@property(nonatomic)float residualFlow;

@property(nonatomic)BOOL isVip;

@property(nonatomic,copy)NSString *token;

@property(nonatomic,copy)NSString *userName;

@property(nonatomic)BOOL isSign;

@property(nonatomic,strong)NSMutableArray *buySaveArray;

@property(nonatomic)float signFlow;

@property(nonatomic,strong)NSMutableArray *areaDataArray;

@property(nonatomic,strong)NSMutableArray *buyDataArray;

@property(nonatomic)int connectionId;

@property(nonatomic)int currentDefaultAreaId;

@property(nonatomic)int heartBeatInterval;

@property(nonatomic)BOOL isNewUserBuy;

+ (instancetype)getInstance;

@end
