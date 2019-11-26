//
//  BuyData.h
//  Potatso
//
//  Created by 黄慧敏 on 2017/8/17.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyData : NSObject

//id
@property(nonatomic)NSInteger id;
//内购ID
@property(nonatomic,copy)NSString *productId;
//产品名称
@property(nonatomic,copy)NSString *productName;
//产品描述
@property(nonatomic,copy)NSString *priceDescription;
//产品价格
@property(nonatomic)float price;
//产品类型
@property(nonatomic,copy)NSString *productType;
//产品内容
@property(nonatomic,copy)NSString *productContent;
//产品赠送
@property(nonatomic,copy)NSString *productPresent;
//当前用户是否曾经购买
@property(nonatomic)BOOL hasPurchased;

@end
