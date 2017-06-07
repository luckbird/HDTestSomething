//
//  HDUserInfoTable.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/7.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDUserInfoTable.h"

@implementation HDUserInfoTable
+ (void)initData {
    //如果要开启外键约束，需要先设置
    //    kSQLExecute(@"PRAGMA foreign_keys = ON");
    /**
     sqlite_master (
     type TEXT,
     name TEXT,
     tbl_name TEXT,
     rootpage INTEGER,
     sql TEXT
     );
     对于sqlite_master表来说，type 字段永远是 ‘table’，name 字段永远是表的名字
     
     //查询数据库的所有表的表名
     SELECT name FROM sqlite_master WHERE type= 'table' ORDER BY name
     
     //获取数据库内表的数量（当有包含自增列,会自动建立一个名为 sqlite_sequence 的表）
     select count(*) as 'count' from sqlite_master where type ='table';
     如果有，返回@[@{@"count" : 表数量}]。没有返回@[@{@"count" : @"0"}]
     
     查询表是否存在
     select count(*) as 'count' from sqlite_master where type ='table' and name = '表名'
     如果有，返回@[@{@"count" : @"1"}]。没有返回@[@{@"count" : @"0"}]
     SELECT name FROM sqlite_master WHERE name = '表名'
     如果有，返回@[@{@"name" : @"user"}]。没有返回空数组
     */
    NSString *sql = @"SELECT name FROM sqlite_master WHERE name = 'user'";
    NSArray *tables = [[HDSqliteManager shareSqliteManager] executeQuery:sql];
    if (!tables.count) {
        [self creatUserTable];
        [self creatStatusTable];
    }
    
}
+ (void)creatUserTable {
    /**
     SQLite字段约束条件
     
     not null - 非空
     unique - 唯一
     primary key - 主键
     foreign key - 外键
     check - 条件检查，确保一列中的所有值满足一定条件
     default - 默认
     autoincreatement - 自增型变量
     
     创建数据库命令——create database
     修改数据库命令——alter database
     创建新表的命令——create table
     变更数据库中的表——alter table
     删除表——drop table
     清空表——delete from
     创建索引——create index
     删除索引——drop index
     可以用 alter table 语句来更改一个表的名字，也可向表中增加一个字段（列），但是我们不能删除一个已经存在的字段，或者更改一个已经存在的字段的名称、数据类型、限定符等等。
     */
    
    NSString *sql = @"create table if not exists user (name text, neckName text, targetId integer primary key unique)";
    kSQLExecute(sql);
}
+ (void)creatStatusTable {
    /**
     外键约束的两种写法
     NSString *sql = @"create table if not exists userRoom (id integer primary key autoincrement, userName text, friends text , title text, userTargetId integer, foreign key(userTargetId) references user(targetId))";
     NSString *sql = @"create table if not exists userRoom (id integer primary key autoincrement, userName text, friends text , title text, userTargetId integer references user(targetId))";
     */
    NSString *sql = @"create table if not exists userRoom (id integer primary key autoincrement, userName text, friends text , title text, userTargetId integer references user(targetId))";
    kSQLExecute(sql);
}

+ (NSArray *)getAllUser {
    NSString *sql = @"select * from user";
    return [[HDSqliteManager shareSqliteManager] executeQuery:sql];
}
+ (void)addUser:(NSString *)name neckName:(NSString *)nack targetId:(NSInteger)userId {
    //数值不需要''，字符串需要'', 即targetId values (%zd)\('%zd')
    NSString *sql = [NSString stringWithFormat:@"insert into user (name, neckName, targetId) values ('%@', '%@', '%zd')", name, nack, userId];
    kSQLExecute(sql);
}
+ (void)deleteUser:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@"delete from user where name = '%@'", name];
    kSQLExecute(sql);
}
+ (void)updateUser:(NSString *)name nackName:(NSString *)nack targetId:(NSInteger)userId {
    NSString *sql = [NSString stringWithFormat:@"update user set neckName='%@', targetId='%zd' where name='%@'", nack, userId, name];
    kSQLExecute(sql);
}
+ (void)addUserStatus:(NSString *)user friens:(NSString *)friends title:(NSString *)title userTargetId:(NSInteger)idInt {
    NSString *sql = [NSString stringWithFormat:@"insert into userRoom (userName, friends, title, userTargetId) values ('%@', '%@', '%@', '%zd')", user, friends, title, idInt];
    kSQLExecute(sql);
}
+ (void)deleteUserState:(NSString *)userName {
    NSString *sql = [NSString stringWithFormat:@"delete from userRoom where userName = '%@'", userName];
    kSQLExecute(sql);
}
+ (void)deleteUserStateId:(NSInteger)Id {
    NSString *sql = [NSString stringWithFormat:@"delete from userRoom where userTargetId = '%zd'", Id];
    kSQLExecute(sql);
}
+ (NSDictionary *)getUserState:(NSInteger)userId {
    /**
     select * from user left join userRoom on user.targetId = userRoom.userTargetId
     select * from user left join userRoom on user.targetId = userRoom.userTargetId where user.targetId = '1210'
     select user.name, user.neckName from user left join userRoom on user.targetId = userRoom.userTargetId where user.targetId = '1210'
     */
    NSString *sql = [NSString stringWithFormat:@"select * from user left join userRoom on user.targetId = userRoom.userTargetId where user.targetId = %zd", userId];
    NSArray *array = [[HDSqliteManager shareSqliteManager] executeQuery:sql];
    //打印数组的断点
    return [array firstObject];
}
+ (void)deleteUserAndUserState:(NSString *)name {
    NSString *userIDSQL = [NSString stringWithFormat:@"select targetId from user where name = '%@'", name];
    //     NSString *userIDSQL = [NSString stringWithFormat:@"select * frome user where name = '%@'", name];
    NSString *userID = [[[[HDSqliteManager shareSqliteManager] executeQuery:userIDSQL] firstObject] valueForKey:@"targetId"];
    NSString *sql = [NSString stringWithFormat:@"delete from userRoom where userTargetId = '%d'", [userID intValue]];
    [[HDSqliteManager shareSqliteManager] executeNonQuery:sql];
    [self deleteUser:name];
}

@end
