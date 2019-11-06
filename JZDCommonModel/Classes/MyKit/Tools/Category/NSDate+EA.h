//
//  NSDate+EA.h
//  AshineDoctor
//
//  Created by Lipeng on 15-8-13.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(EA)
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)week;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
//yyyymmdd
- (NSString *)yyyyMMddString;
- (NSString *)uploadyyyyMMddHHmmssString;
- (NSString *)yyyyMMddHHmmssString;
- (NSString *)agoString:(BOOL)hasTime;
- (NSString *)agoYYYYMMddString;
@end
