//
//  KeyChainStore.h
//  Potatso
//
//  Created by 黄慧敏 on 2017/8/17.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
