//
//  PublicMsg.m
//  MobilePaymentOS
//
//  Created by YS_XY on 15/1/16.
//  Copyright (c) 2015年 yinsheng. All rights reserved.
//

#import "JSONKit.h"

@implementation JSONKit

+(NSString *)jsonStringWithObject:(id)object
{
    NSError *err = nil;
    if (object) {
        if ([object isKindOfClass:[NSString class]]) {
            object = [@"\""stringByAppendingString:object];
            object = [object stringByAppendingString:@"\""];
            if (err) {
                return nil;
            }
            return object;
        }else{
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&err];
            if (err) {
                return nil;
            }
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
    }else{
        return @"";
    }
    
}

+(NSDictionary *) jsonDicWithString:(NSString *)jsonStr
{
    if ([self isBlankString:jsonStr]) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        LOG_INF(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSArray *) jsonArrayWithString:(NSString *)jsonStr
{
    if ([self isBlankString:jsonStr]) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    if(err) {
        LOG_INF(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string length]==0) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
