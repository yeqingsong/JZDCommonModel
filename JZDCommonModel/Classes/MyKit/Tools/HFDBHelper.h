//
//  HFDBHelper.h
//  JKDBModel
//
//  Created by huafangT on 16/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface HFDBHelper : NSObject
/**
 *  数据库工具单例
 *
 *  @return 数据库工具对象
 */

+(HFDBHelper *)shareHelper;

/**
 *  创建数据库
 *
 *  @param dbName 数据库名称(带后缀.sqlite)
 */
-(FMDatabase *)createDBWithDBName:(NSString *)dbName;


/**
 *  给指定数据库建表
 *
 *  @param db        指定数据库对象
 *  @param tableName 表的名称
 *  @param keyTypes   所含字段以及对应字段类型 字典
 */
-(void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes;


/**
 *  给指定数据库的表添加值
 *
 *  @param db        数据库名称
 *  @param keyValues 字段及对应的值
 *  @param tableName 表名
 */

-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName;


/**
 *  给指定数据库的表更新值
 *
 *  @param db        数据库名称
 *  @param keyValues 要更新字段及对应的值
 *  @param tableName 表名
 */

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues;


/**
 *  条件更新
 *
 *  @param db        数据库名称
 *  @param tableName 表名称
 *  @param keyValues 要更新的字段及对应值
 *  @param condition 条件
 */

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition;


/**
 *  查询数据库表中的所有值 限制数据条数10
 *
 *  @param db        数据库名称
 *  @param keyTypes 查询字段以及对应字段类型 字典
 *  @param tableName 表名称
 *  @return 查询得到数据
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName;


/**
 *  条件查询数据库中的数据 限制数据条数10
 *
 *  @param db        数据库名称
 *  @param keyTypes 查询字段以及对应字段类型 字典
 *  @param tableName 表名称
 *  @param condition 条件
 *
 *  @return 查询得到数据 限制数据条数10
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(NSDictionary *)condition;


/**
 *  模糊查询 某字段以指定字符串开头的数据 限制数据条数10
 *
 *  @param db        数据库名称
 *  @param keyTypes 查询字段以及对应字段类型 字典
 *  @param tableName 表名称
 *  @param key       条件字段
 *  @param str       开头字符串
 *
 *  @return 查询所得数据 限制数据条数10
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key beginWithStr:(NSString *)str;


/**
 *  模糊查询 某字段包含指定字符串的数据 限制数据条数10
 *
 *  @param db        数据库名称
 *  @param keyTypes 查询字段以及对应字段类型 字典
 *  @param tableName 表名称
 *  @param key       条件字段
 *  @param str       所包含的字符串
 *
 *  @return 查询所得数据
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key containStr:(NSString *)str;


/**
 *  模糊查询 某字段以指定字符串结尾的数据 限制数据条数10
 *
 *  @param db        数据库名称
 *  @param keyTypes 查询字段以及对应字段类型 字典
 *  @param tableName 表名称
 *  @param key       条件字段
 *  @param str       结尾字符串
 *
 *  @return 查询所得数据
 */

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key endWithStr:(NSString *)str;


/**
 *  清理指定数据库中的数据  （只删除数据不删除数据库）
 *
 *  @param db 指定数据库
 */

-(void)clearDatabase:(FMDatabase *)db from:(NSString *)tableName;

@end
