//
//  PublicMsg.h
//  MobilePaymentOS
//
//  Created by YS_XY on 15/1/16.
//  Copyright (c) 2015年 yinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONKit : NSObject

+(NSString *)jsonStringWithObject:(id)object;

+(NSDictionary *) jsonDicWithString:(NSString *)jsonStr;

+(NSArray *) jsonArrayWithString:(NSString *)jsonStr;
@end