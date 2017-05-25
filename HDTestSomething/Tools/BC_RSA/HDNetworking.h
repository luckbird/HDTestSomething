//
//  HDNetworking.h
//  HDTestSomething
//
//  Created by yscompany on 2017/5/23.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDNetworking : NSObject
@property (nonatomic, strong) NSString *baseUrlStr;
+ (instancetype)shareURLSession;

@end
