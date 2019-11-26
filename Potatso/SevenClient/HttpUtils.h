//
//  HttpUtils.h
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/8.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    HTTPCODE_SUCCES = 0,
    HTTPCODE_ERROR_1 = 1,
    HTTPCODE_ERROR_2 = 2
};

@class HttpUtils;

//代理方法
@protocol HttpUtilsDelegate <NSObject>

//登录返回
- (void)responseLogin:(NSDictionary *)dict andCode:(int)code;
//获取个人信息返回
- (void)responseUserInfo:(NSDictionary *)dict andCode:(int)code;
//获取配置项返回
- (void)responseConfig:(NSDictionary *)dict andCode:(int)code;
//获取服务器列表返回
- (void)responseZone:(NSDictionary *)dict andCode:(int)code;
//签名返回
- (void)responseSign:(NSDictionary *)dict andCode:(int)code;
//获取内购列表返回
- (void)responseProducts:(NSDictionary *)dict andCode:(int)code;
//创建订单返回
- (void)responseOrder:(NSDictionary *)dict andCode:(int)code;
//获取订单列表返回
- (void)responseOrderList:(NSDictionary *)dict andCode:(int)code;
//连接服务返回
- (void)responseConnection:(NSDictionary *)dict andCode:(int)code;
//断开服务返回
- (void)responseDisConnection:(NSDictionary *)dict andCode:(int)code;
//服务心跳返回
- (void)responseHeartbeat:(NSDictionary *)dict andCode:(int)code;
//修改订单返回
- (void)responseReviseOrder:(NSDictionary *)dict andCode:(int)code;

@end

@interface HttpUtils : NSObject

+ (instancetype)getInstance;

@property(nonatomic,assign)id<HttpUtilsDelegate> delegate;

//登录请求
- (void)requestLogin:(NSString *)uuid;
//获取个人信息请求
- (void)requestUserInfo:(NSString *)token;
//获取配置项请求
- (void)requestConfig:(NSString *)token;
//获取服务器列表请求
- (void)requestZone:(NSString *)token;
//签到请求
- (void)requestSign:(NSString *)token;
//获取内购列表请求
- (void)requestProducts:(NSString *)token;
//创建订单请求
- (void)requestOrder:(NSString *)token andProductId:(NSString *)productId;
//获取订单列表请求
- (void)requestOrderList:(NSString *)token;
//连接服务请求
- (void)requestConnection:(NSString *)token andZoneId:(NSInteger)zoneId;
//断开服务请求
- (void)requestDisConnection:(NSString *)token andIp:(NSString *)ip andEntryPort:(int)entryPort;
//服务心跳请求
- (void)requestHeartbeat:(NSString *)token andIp:(NSString *)ip andEntryPort:(int)entryPort;
//修改订单返回
- (void)requestReviseOrder:(NSString *)token andOrderId:(NSInteger)orderId andStoreReceipt:(NSString *)storeReceipt;
@end
