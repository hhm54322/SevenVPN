//
//  BuySaveData.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/22.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuySaveData : NSObject
//id
@property(nonatomic)NSInteger id;
//订单号
@property(nonatomic,copy)NSString *orderId;
//订单名称
@property(nonatomic,copy)NSString *orderName;
//订单价格
@property(nonatomic)float price;
//订单购买时间
@property(nonatomic,copy)NSString *orderTime;
//订单状态
@property(nonatomic,copy)NSString *orderStatus;

@end
