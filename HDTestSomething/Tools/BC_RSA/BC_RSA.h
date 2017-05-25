//
//  BC_RSA.h
//  rsa
//
//  Created by 斌 on 13-9-31.
//  Copyright (c) 2013年 斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BC_RSA : NSObject

/*
 path 证书路径
 pwd 证书密码
 */
+(SecKeyRef)setPrivateKey:(NSString*)path password:(NSString*)pwd;

/*
 plainText 加密内容
 */
+(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText;

//提取公钥  cer
+(NSString *)RSAEncrypotoTheData:(NSString *)plainText;

@end
