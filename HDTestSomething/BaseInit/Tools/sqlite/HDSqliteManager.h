//
//  HDSqliteManager.h
//  HDTestSomething
//
//  Created by yscompany on 2017/6/7.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface HDSqliteManager : NSObject
+(instancetype)shareSqliteManager;
//数据库引用，使用它进行数据库操作
@property (nonatomic) sqlite3 *database;

/**
 *  打开数据库
 *
 *  @param dbname 数据库名称
 */
- (void)openDb:(NSString *)dbname;

/**
 *  执行无返回值的sql
 *
 *  @param sql sql语句
 */
- (void)executeNonQuery:(NSString *)sql;

/**
 *  执行有返回值的sql
 *
 *  @param sql sql语句
 *
 *  @return 查询结果内容为字典格式
 */
- (NSArray *)executeQuery:(NSString *)sql;

/**
 事务
 */
- (void)executeTransaction:(void(^)())transaction;
- (void)executeTransaction;
@end
