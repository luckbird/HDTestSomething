//
//  VerifyTools.h
//  YSModel6
//
//  Created by Jim on 14/11/28.
//  Copyright (c) 2014年 yinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface VerifyTools : NSObject


+ (NSString *)getSafeString:(NSString *)string;
//判断字符串是否为空
+(BOOL) isBlankString:(NSString *)string;

+ (BOOL) isBlankString1:(NSString *)string;

+(NSString *)getCurrentTime;

+(NSDate*) strToDate:(NSString*)uiDate;
@end
