//
//  ConnectionData.h
//  Potatso
//
//  Created by 黄慧敏 on 2017/8/18.
//  Copyright © 2017年 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionData : NSObject

//入口IP
@property(nonatomic,copy)NSString *ip;
//入口端口
@property(nonatomic)int entryPort;
//加密密钥
@property(nonatomic,copy)NSString *encryptionKey;
//加密算法
@property(nonatomic,copy)NSString *cipherMode;

@end
