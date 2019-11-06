//
//  NSString+EA.h
//  AshineDoctor
//
//  Created by Lipeng on 15-7-30.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(EA)
- (CGSize)eaSizeWithFont:(UIFont *)font;
- (CGSize)eaSizeWithFont:(UIFont *)font maxWidth:(CGFloat)width;
- (NSString *)md5;
- (NSString *)md5Lowcase;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodeString;
- (NSDate *)dateValue;
- (NSString *)agoString:(BOOL)hasTime;
- (NSString *)agoYYYYMMddString;
- (BOOL)isBlank;

- (BOOL)isValidIdentity;//验证身份证
- (BOOL)isValidMobileNumber;//验证手机号

//由身份证号返回为年龄
-(NSString *)ageStrFromIdentityCard;

//由身份证号返回为性别
- (NSString *)sexStrFromIdentityCard;

@end
