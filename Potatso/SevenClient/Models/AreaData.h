//
//  AreaData.h
//  Potatso
//
//  Created by 黄慧敏 on 2017/8/17.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaData : NSObject

//区域ID
@property(nonatomic)NSInteger areaId;
//区域编码
@property(nonatomic,copy)NSString *areaCode;
//区域名称
@property(nonatomic,copy)NSString *areaName;
//国家或地区编码
@property(nonatomic,copy)NSString *areaCountryType;
//是否为付费区域
@property(nonatomic)BOOL areaVip;
//icon字符串
@property(nonatomic,copy)NSString *areaIcon;
//探针ip
@property(nonatomic,copy)NSString *areaIp;

@end
