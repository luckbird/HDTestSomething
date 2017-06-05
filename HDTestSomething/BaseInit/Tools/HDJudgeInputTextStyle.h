//
//  HDJudgeInputTextStyle.h
//  HDTestSomething
//
//  Created by yscompany on 2017/6/5.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDJudgeInputTextStyle : NSObject

/**
 系统自带中英文键盘 按键时输入框代理方法获取的string对象字符集

 @param str 传入字符串
 @return YES or No 是否符合字符集
 */
+ (BOOL)isDefaultInputNumber:(NSString *)str;

/**
 字母、数字、中文正则判断（不包括空格）

 @param str 传入字符串
 @return 是否符合标准
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)str;

/**
 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）

 @param str 传入字符串
 @return 是否符合标准
 */
+ (BOOL)isInputRuleAndBlank:(NSString *)str;

/**
 过滤表情

 @param text 传入字符串
 @return 将字符串中表情字节替换成@""空字符串返回
 */
+ (NSString *)disable_emoji:(NSString *)text;

/**
 过滤出中英文，数字之外的其他字符从键盘模糊匹配选择录入

 @param text 传入字符串
 @return 将字符串中除上面三种的特殊字节替换成@""空字符串返回
 */
+ (NSString *)disable_special:(NSString *)text;
@end
