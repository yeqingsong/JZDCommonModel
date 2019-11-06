//
//  NSString+EA.m
//  AshineDoctor
//
//  Created by Lipeng on 15-7-30.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "NSString+EA.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "NSAttributedString+EA.h"
#import "NSDate+EA.h"
@implementation NSString(EA)
- (CGSize)eaSizeWithFont:(UIFont *)font
{
    CGSize size = CGSizeZero;
    if ([self respondsToSelector:@selector(sizeWithFont:)]){
        size = [self sizeWithFont:font];
    }
    if ([self respondsToSelector:@selector(sizeWithAttributes:)]){
        size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (CGSize)eaSizeWithFont:(UIFont *)font maxWidth:(CGFloat)width
{
    CGSize size = CGSizeZero;
    if ([self respondsToSelector:@selector(sizeWithFont:constrainedToSize:lineBreakMode:)]){
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width,100000.f) lineBreakMode:NSLineBreakByCharWrapping];
    } else {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self];
        [text addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0,self.length)];
        return [text eaSizeWithMaxWidth:width];
    }
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md5Lowcase
{
    return [[self md5] lowercaseString];
}

- (NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (__bridge  NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding);
}

- (NSString *)URLDecodeString
{
    return (__bridge  NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8);
}

- (NSDate *)dateValue
{
    if (self.length < strlen("yyyy-MM-dd HH:mm:ss")) {
        return [NSDate date];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    if (nil != [df dateFromString:self]) {
        return [df dateFromString:self];
    }
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df dateFromString:self];
}

- (NSString *)agoString:(BOOL)hasTime
{
    return [self.dateValue agoString:hasTime];
}

- (NSString *)agoYYYYMMddString
{
    return [self.dateValue agoYYYYMMddString];
}

- (BOOL)isBlank
{
    return (0 == [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length);
}

- (BOOL)isValidIdentity
{
    if (self.length != 18){
        return NO;
    }
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]){
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isValidMobileNumber
{
    NSString *phoneRegex1=@"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:self];
}

//由身份证号返回为年龄
-(NSString *)ageStrFromIdentityCard{
    NSInteger yearInt = [[self substringWithRange:NSMakeRange(6, 4)] integerValue];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    
    NSInteger ageInt = comp.year - yearInt;
    NSString * ageStr = [NSString stringWithFormat:@"%ld",ageInt];
    
    return  ageStr;
}

//由身份证号返回为性别
-(NSString *)sexStrFromIdentityCard{
    NSString *result = nil;
    
    BOOL isAllNumber = YES;
    
    if([self length]<17)
        return result;
    
    //**截取第17为性别识别符
    NSString *fontNumer = [self substringWithRange:NSMakeRange(16, 1)];
    
    //**检测是否是数字;
    const char *str = [fontNumer UTF8String];
    const char *p = str;
    while (*p!='\0') {
        if(!(*p>='0'&&*p<='9'))
            isAllNumber = NO;
        p++;
    }
    
    if(!isAllNumber)
        return result;
    
    NSInteger sexNumber = [fontNumer integerValue];
    if(sexNumber%2==1)
        result = @"男";
    else if (sexNumber%2==0)
        result = @"女";
    return result;
}

@end
