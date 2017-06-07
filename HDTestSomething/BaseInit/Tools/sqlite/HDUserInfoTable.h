//
//  HDUserInfoTable.h
//  HDTestSomething
//
//  Created by yscompany on 2017/6/7.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUserInfoTable : NSObject
+ (void)initData;
+ (NSArray *)getAllUser;
+ (void)addUser:(NSString *)name neckName:(NSString *)nack targetId:(NSInteger)userId;
+ (void)deleteUser:(NSString *)name;
+ (void)updateUser:(NSString *)name nackName:(NSString *)nack targetId:(NSInteger)userId;
+ (void)addUserStatus:(NSString *)user friens:(NSString *)friends title:(NSString *)title userTargetId:(NSInteger)idInt;
+ (void)deleteUserState:(NSString *)userName;
+ (void)deleteUserStateId:(NSInteger)Id;
+ (NSDictionary *)getUserState:(NSInteger)userId;
+ (void)deleteUserAndUserState:(NSString *)name;
@end
