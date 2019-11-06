//
//  HFDBHelper.m
//  JKDBModel
//
//  Created by huafangT on 16/11/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "HFDBHelper.h"
#import "Tools.h"
static HFDBHelper *helper = nil;

@interface HFDBHelper()

@property(nonatomic, strong)FMDatabase * db;

@end

@implementation HFDBHelper
+(HFDBHelper *)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[self alloc] init];
        }
    });
    return helper;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [super allocWithZone:zone];
        }
    });
    return helper;
}

#pragma mark --创建数据库

-(FMDatabase *)createDBWithDBName:(NSString *)dbName
{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [library[0] stringByAppendingPathComponent:dbName];
    NSLog(@"%@", dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"无法获取数据库");
        return nil;
    }
    _db = db;
    return db;
}

#pragma mark --给指定数据库建表

-(void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
        
        int count = 0;
        
        for (NSString *key in keyTypes) {
            
            count++;
            [sql appendString:key];
            [sql appendString:@" "];
            [sql appendString:[keyTypes valueForKey:key]];
        
            if (count != [keyTypes count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@")"];
        [db executeUpdate:sql];
    }
}

#pragma mark --给指定数据库的表添加值 单次操作  非事务

-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
//        
//                int count = 0;
//        
//                NSString *Key = [[NSString alloc] init];
//        
//                for (NSString *key in keyValues) {
//        
//                    if(count == 0){
//                        
//                        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)",tableName, key]];
//                        
//                        [db executeUpdate:sql,[keyValues valueForKey:key]];
//                        Key = key;
//                    }else
//                    {
//                        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, key, Key]];
//                        
//                        [db executeUpdate:sql,[keyValues valueForKey:key],[keyValues valueForKey:Key]];
//                    }
//                    count++;
//                }
        
        //把一个NSArray对象赋值给了一个声明为NSMutableArray的对象，于是在对NSArray对象使用addObject方法时出错。
        //添加账户标识
        NSMutableArray * keys = [[keyValues allKeys] mutableCopy];
        [keys addObject:@"ACCOUNTID"];
        
        NSMutableArray * values  = [[keyValues allValues] mutableCopy];
        [values addObject:[Tools getObjForKey:@"Id"]];
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (", tableName]];
        
        NSInteger count = 0;
        
        for (NSString *key in keys) {
            
            [sql appendString:key];
            
            count ++;
            
            if (count < [keys count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@") VALUES ("];
        
        for (int i = 0; i < [values count]; i++) {
            
            [sql appendString:@"?"];
            if (i < [values count] - 1) {
                [sql appendString:@","];
            }
        }
        
        [sql appendString:@")"];

        NSLog(@"%@", sql);

        [db executeUpdate:sql withArgumentsInArray:values];
    }
}

#pragma mark --给指定数据库的表更新值

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        for (NSString *key in keyValues) {
            
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ?", tableName, key]];
            
            [db executeUpdate:sql,[keyValues valueForKey:key]];
        }
    }
}

#pragma mark --条件更新

-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        for (NSString *key in keyValues) {
            
      //      NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ? and %@ = ?", tableName, key, [condition allKeys][0], [condition allKeys][1] ]];
             NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ? ", tableName, key, [condition allKeys][0] ]];
            [db executeUpdate:sql,[keyValues valueForKey:key],[keyValues valueForKey:[condition allKeys][0]]];
        }
    }
}

#pragma mark --查询数据库表中的所有值

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName
{
    if(db == nil){
    db = _db;
}
//    FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 10",tableName]];
     FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ",tableName]];
    
    return [self getArrWithFMResultSet:result keyTypes:keyTypes];
}

#pragma mark --条件查询数据库中的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(NSDictionary *)condition;
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        //SELECT * FROM %@ WHERE %@ = ? LIMIT 10
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",tableName, [condition allKeys][0]], [condition valueForKey:[condition allKeys][0]]];

        return [self getArrWithFMResultSet:result keyTypes:keyTypes];
    }else
        return nil;
}

#pragma mark --模糊查询 某字段以指定字符串开头的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key beginWithStr:(NSString *)str
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %@%% LIMIT 10",tableName, key, str]];
        
        return [self getArrWithFMResultSet:result keyTypes:keyTypes];
        
    }else
        
        return nil;
}

#pragma mark --模糊查询 某字段包含指定字符串的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key containStr:(NSString *)str
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %%%@%% LIMIT 10",tableName, key, str]];
        
        return [self getArrWithFMResultSet:result keyTypes:keyTypes];
        
    }else
        
        return nil;
}

#pragma mark --模糊查询 某字段以指定字符串结尾的数据

-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key endWithStr:(NSString *)str
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE %%%@ LIMIT 10",tableName, key, str]];
        
        return [self getArrWithFMResultSet:result keyTypes:keyTypes];
        
    }else
        
        return nil;
}

#pragma mark --清理指定数据库中的数据

-(void)clearDatabase:(FMDatabase *)db from:(NSString *)tableName
{
    if(db == nil){
        db = _db;
    }
    if ([self isOpenDatabese:db]) {
        
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
    }
}

#pragma mark --CommonMethod

-(NSArray *)getArrWithFMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes
{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    while ([result next]) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < keyTypes.count; i++) {
            
            NSString *key = [keyTypes allKeys][i];
            
            NSString *value = [keyTypes valueForKey:key];
            
            if ([value isEqualToString:@"text"]) {
                
                //                字符串
                
                [tempDic setValue:[result stringForColumn:key] forKey:key];
                
            }else if([value isEqualToString:@"blob"])
                
            {
                //                二进制对象
                
                [tempDic setValue:[result dataForColumn:key] forKey:key];
                
            }else if ([value isEqualToString:@"integer"])
                
            {
                //                带符号整数类型
                
                [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]]forKey:key];
                
            }else if ([value isEqualToString:@"boolean"])
                
            {
                
                //                BOOL型
                
                [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
                
            }else if ([value isEqualToString:@"date"])
                
            {
                //                date
                
                [tempDic setValue:[result dateForColumn:key] forKey:key];
            }
        }
        [tempArr addObject:tempDic];
    }
    return tempArr;
}

-(BOOL)isOpenDatabese:(FMDatabase *)db
{
    if(db == nil){
        db = _db;
    }
    if (![db open]) {
        
        [db open];
    }
    return YES;
}

@end
