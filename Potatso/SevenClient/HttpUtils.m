//
//  HttpUtils.m
//  SevenVPN
//
//  Created by 黄慧敏 on 2017/6/8.
//  Copyright © 2017年 黄慧敏. All rights reserved.
//

#import "HttpUtils.h"

@implementation HttpUtils

HttpUtils* _instance = nil;

//单例
+ (instancetype)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [HttpUtils getInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [HttpUtils getInstance];
}

- (void)requestLogin:(NSString *)uuid{
    NSLog(@"HttpUtils requestLogin");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/user/loginWithRegister?uniqueId=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/user/loginWithRegister?uniqueId=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/user/loginWithRegister?uniqueId=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,uuid];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"GET";
        //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseLogin:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseLogin:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseLogin:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestUserInfo:(NSString *)token{
    NSLog(@"HttpUtils requestUserInfo");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/user/getUserInfo?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/user/getUserInfo?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/user/getUserInfo?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];    //设置请求方法
    request.HTTPMethod = @"GET";
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseUserInfo:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseUserInfo:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseUserInfo:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestConfig:(NSString *)token{
    NSLog(@"HttpUtils requestConfig");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/configurations?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/configurations?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/configurations?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"GET";
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseConfig:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseConfig:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseConfig:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestZone:(NSString *)token{
    NSLog(@"HttpUtils requestQueryAll");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/server/getZone?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/server/getZone?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/server/getZone?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"GET";
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseZone:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseZone:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseZone:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestSign:(NSString *)token{
    NSLog(@"HttpUtils requestSign");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/user/sign?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/user/sign?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/user/sign?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"GET";
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseSign:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseSign:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseSign:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestProducts:(NSString *)token{
    NSLog(@"HttpUtils requestProducts");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/products?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/products?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/products?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@%@",urlTemp,token,@"&productType=throughput&version=2.0.0"];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"GET";
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseProducts:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseProducts:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseProducts:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestOrder:(NSString *)token andProductId:(NSString *)productId{
    NSLog(@"HttpUtils requestOrder");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/orders?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/orders?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/orders?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    
    //使用苹果自带的类NSJSONSerialization生成json
//    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"productId", storeReceipt, @"storeReceipt", nil];
    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:productId, @"productId", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    NSData *sendData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = sendData;
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseOrder:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseOrder:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseOrder:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestOrderList:(NSString *)token{
    NSLog(@"HttpUtils requestOrderList");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/orders?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/orders?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/orders?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"GET";
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseOrderList:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseOrderList:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseOrderList:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestConnection:(NSString *)token andZoneId:(NSInteger)zoneId{
    NSLog(@"HttpUtils requestConnection");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/services/connection?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/services/connection?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/services/connection?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    
    //使用苹果自带的类NSJSONSerialization生成json
    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLong:zoneId],@"zoneId",nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    NSData *sendData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = sendData;
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseConnection:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            NSLog(@"%@",dict[@"message"]);
            [_delegate responseConnection:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        NSLog(@"%@",dict);
        [_delegate responseConnection:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestDisConnection:(NSString *)token andIp:(NSString *)ip andEntryPort:(int)entryPort{
    NSLog(@"HttpUtils requestDisConnection");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/services/disconnection?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/services/disconnection?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/services/disconnection?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //使用苹果自带的类NSJSONSerialization生成json
    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:ip, @"ip", [NSNumber numberWithInt:entryPort], @"entryPort", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    NSData *sendData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = sendData;
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseDisConnection:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseDisConnection:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseDisConnection:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestHeartbeat:(NSString *)token andIp:(NSString *)ip andEntryPort:(int)entryPort{
    NSLog(@"HttpUtils requestHeartbeat");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/services/heartbeat?token=";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/services/heartbeat?token=";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/services/heartbeat?token=";
    NSString *stringURL = [NSString stringWithFormat:@"%@%@",urlTemp,token];
    NSLog(@"%@",stringURL);
    //使用苹果自带的类NSJSONSerialization生成json
    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:ip, @"ip", [NSNumber numberWithInt:entryPort], @"entryPort", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    NSData *sendData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = sendData;
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseHeartbeat:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseHeartbeat:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseHeartbeat:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}

- (void)requestReviseOrder:(NSString *)token andOrderId:(NSInteger)orderId andStoreReceipt:(NSString *)storeReceipt{
    NSLog(@"HttpUtils requestReviseOrder");
    /*
     http请求实例
     */
    //get
    //NSString *urlTemp = @"http://112.73.83.190/lighthouse/app/orders/%ld?token=%@";
    NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse/app/orders/%ld?token=%@";
    //NSString *urlTemp = @"http://ss.7x-networks.com/lighthouse_s2/app/orders/%ld?token=%@";
    NSString *stringURL = [NSString stringWithFormat:urlTemp,orderId,token];
    NSLog(@"%@",stringURL);
    
    //使用苹果自带的类NSJSONSerialization生成json
    NSDictionary *dicts = [[NSDictionary alloc] initWithObjectsAndKeys:storeReceipt, @"storeReceipt", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicts options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);
    NSData *sendData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    //创建url
    NSURL *url = [NSURL URLWithString:stringURL];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"PUT";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = sendData;
    //获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求失败，打印错误信息
        if(error){
            NSLog(@"get error:%@",error.localizedDescription);
            [_delegate responseReviseOrder:nil andCode:HTTPCODE_ERROR_1];
            return;
        }
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if(httpResp.statusCode != 200){
            NSLog(@"httpResp.statusCode:%ld",(long)httpResp.statusCode);
            [_delegate responseReviseOrder:nil andCode:HTTPCODE_ERROR_2];
            return;
        }
        /*
         对获得的数据进行解析（字典保存）
         */
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",dict);
        [_delegate responseReviseOrder:dict andCode:HTTPCODE_SUCCES];
    }];
    //最后一步，执行任务（resume也是继续执行）
    [sessionDataTask resume];
}



@end
