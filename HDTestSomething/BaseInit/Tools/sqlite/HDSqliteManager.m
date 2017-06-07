//
//  HDSqliteManager.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/7.
//  Copyright © 2017年 yscompany. All rights reserved.
//
#define kDatabaseName @"myDatabase.db"
#import "HDSqliteManager.h"

static HDSqliteManager *manager;
@interface HDSqliteManager ()

@end

@implementation HDSqliteManager

+ (instancetype)shareSqliteManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HDSqliteManager new];
        [manager openDb:kDatabaseName];
    });
    return manager;
}
- (void)openDb:(NSString *)dbname {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [document stringByAppendingPathComponent:dbname];
    /**
     设置数据库的并发模式SQLITE_CONFIG_MULTITHREAD
     NSLog(@"%d", sqlite3_threadsafe());
     NSLog(@"%s", sqlite3_libversion());
     */
//        sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    if (SQLITE_OK == sqlite3_open(path.UTF8String, &_database)) {
        NSLog(@"数据库打开成功!");
    } else {
        NSLog(@"数据库打开失败!");
    }
}
- (void)executeNonQuery:(NSString *)sql {
    /**
     sqlite3_exec() 适合执行一次性语句,sqlite3_prepare_v2() 适合重复执行语句和绑定参数,比如进行事务。
     sqlite3_exec是sqlite3_prepare_v2，sqlite3_step()和sqlite3_finalize()的封装，能让程序多次执行sql语句而不要写许多重复的代码。
     */
    NSString *logStr = sql.length > 100 ? [[sql substringToIndex:100] stringByAppendingString:@"..."] : sql;
    char *error;
    //单步执行sql语句，用于插入、修改、删除
    if (SQLITE_OK != sqlite3_exec(_database, sql.UTF8String, NULL, NULL, &error)) {
        NSLog(@"%@ \n\t\t\t\t\terror: %s\n", logStr, error);
    } else {
        NSLog(@"%@", logStr);
    }
    sqlite3_free(error);
}
- (NSArray *)executeQuery:(NSString *)sql {
    NSMutableArray *rows=[NSMutableArray array];
    /**
     "另一个要说明的是prepared statement，它是由数据库连接（的pager）来管理的，使用它也可看成使用这个数据库连接。因此在多线程模式下，并发对同一个数据库连接调用sqlite3_prepare_v2()来创建prepared statement，或者对同一个数据库连接的任何prepared statement并发调用sqlite3_bind_*()和sqlite3_step()等函数都会出错（在iOS上，该线程会出现EXC_BAD_ACCESS而中止）。这种错误无关读写，就是只读也会出错。文档中给出的安全使用规则是：没有事务正在等待执行，所有prepared statement都被finalized"
     */
    //评估语法正确性
    sqlite3_stmt *stmt;
    //检查语法正确性
    int result = sqlite3_prepare(_database, sql.UTF8String, -1, &stmt, NULL);
    if (SQLITE_OK == result) {
        // SQLite_ROW仅用于查询语句，sqlite3_step()函数执行后的结果如果是SQLite_ROW，说明结果集里面还有数据，会自动跳到下一条结果，如果已经是最后一条数据，再次执行sqlite3_step()，会返回SQLite_DONE，结束整个查询
        //单步执行sql语句
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            int columnCount = sqlite3_column_count(stmt);
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:columnCount];
            for (int i = 0; i < columnCount; i++) {
                const char *name = sqlite3_column_name(stmt, i);//列名
                const unsigned char *value = sqlite3_column_text(stmt, i);//列对应值
                NSString *nameString = [NSString stringWithUTF8String:name];
                if (value != NULL) {
                    NSString *valueString = [NSString stringWithUTF8String:(const char *)value];
                    [dic setValue:valueString forKey:nameString];
                }
            }
            [rows addObject:dic];
        }
        NSLog(@"%@", sql);
    } else {
        NSLog(@"%@ \n\t\t\t\t\terror: %s\n", sql, sqlite3_errmsg(_database));
    }
    //释放句柄
    sqlite3_finalize(stmt);
    
    return rows;
}

- (void)executeTransaction:(void (^)())transaction {
    [self executeNonQuery:@"BEGIN TRANSACTION"];
    transaction();
    [self executeNonQuery:@"COMMIT TRANSACTION"];
    
}
- (void)executeTransaction {
    char *errorMsg;
    if (sqlite3_exec(_database, "BEGIN TRANSACTION", NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"Failed to begin transaction: %s", errorMsg);
    }
    
    sqlite3_stmt *stmt = NULL;
    /*
     普通插入一百条数据 1000次
     成功     avg:263.12ms max:1577.82ms min:76.21ms
     avg: 115.10, max: 245.96, min: 72.93
     
     100次
     成功     avg: 160.49, max: 538.13, min: 76.08
     失败     avg: 28.76 ,  max: 277.88, min: 5.68
     
     利用事务插入一百条数据 100次
     成功     avg: 3.45,  max: 10.48,  min: 2.69
     失败     avg: 14.46, max: 163.69, min: 3.22
     */
    for (int i = 1316; i<1416; i++) {
        NSString *name = [self getRandomStringWithLenght:8];
        NSString *neckName = [self getRandomStringWithLenght:8];
        NSString *sql = [NSString stringWithFormat:@"insert into user (name, neckName, targetId) values ('%@', '%@', %zd)", name, neckName, i];
        if (SQLITE_OK == sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL)) {
            if (SQLITE_DONE != sqlite3_step(stmt)) {
                NSLog(@"Error inserting table: %s", sqlite3_errmsg(_database));
            }
            /**
             对所有V3.6.23.1以及其前面的所有版本，需要在sqlite3_step()之后调用sqlite3_reset()，在后续的sqlite3_ step之前。如果调用sqlite3_reset重置准备语句失败，将会导致sqlite3_ step返回SQLITE_MISUSE，但是在V3. 6.23.1以后，sqlite3_step()将会自动调用sqlite3_reset。
             */
            //sqlite3_reset(stmt);
        }
    }
    sqlite3_finalize(stmt);
    
    if (sqlite3_exec(_database, "COMMIT TRANSACTION", NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"Failed to commit transaction: %s", errorMsg);
    }
    sqlite3_free(errorMsg);
}
- (NSString *)getRandomStringWithLenght:(NSInteger)length {
    NSArray *orderCharacte = [NSArray arrayWithObjects: @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    length = length == 0 ? 8 : length;
    NSMutableString *orderString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i<length; i++) {
        int index = arc4random() % (orderCharacte.count);
        [orderString appendString:orderCharacte[index]];
    }
    return [orderString copy];
}
/**
 性能测试
 NSMutableArray *array = [NSMutableArray arrayWithCapacity:100];
 for (int i = 0; i<100; i++) {
 [[LYDataManager sharedLYDataManager] executeNonQuery:@"drop table user"];
 [LYDataService initData];
 CGFloat time = [self addUser];
 [array addObject:@(time)];
 }
 
 NSNumber *avg = [array valueForKeyPath:@"@avg.floatValue"];
 
 NSNumber *max = [array valueForKeyPath:@"@max.floatValue"];
 
 NSNumber *min = [array valueForKeyPath:@"@min.floatValue"];
 
 NSLog(@"avg: %.2f, max: %.2f, min: %.2f", [avg floatValue], [max floatValue], [min floatValue]);
 
 for (int i = 1216; i<1316; i++) {
 NSString *name = [self getRandomStringWithLenght:8];
 NSString *neckName = [self getRandomStringWithLenght:8];
 [LYDataService addUser:name neckName:neckName targetId:i];
 }
 
 */

@end
