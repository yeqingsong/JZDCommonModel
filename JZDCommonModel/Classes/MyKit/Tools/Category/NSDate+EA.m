//
//  NSDate+EA.m
//  AshineDoctor
//
//  Created by Lipeng on 15-8-13.
//  Copyright (c) 2015年 esuizhen. All rights reserved.
//

#import "NSDate+EA.h"

@implementation NSDate(EA)

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [[calendar components:NSYearCalendarUnit fromDate:self] year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [[calendar components:NSMonthCalendarUnit fromDate:self] month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [[calendar components:NSDayCalendarUnit fromDate:self] day];
}

- (NSInteger)week
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 2;
    return [[calendar components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [[calendar components:NSHourCalendarUnit fromDate:self] hour];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [[calendar components:NSMinuteCalendarUnit fromDate:self] minute];
}

- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    return [[calendar components:NSSecondCalendarUnit fromDate:self] second];
}

- (NSString *)yyyyMMddString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:self];
}

- (NSString *)uploadyyyyMMddHHmmssString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMddHHmmss";
    return [df stringFromDate:self];
}

- (NSString *)yyyyXieMMddHHmmssString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    return [df stringFromDate:self];
}

- (NSString *)yyyyMMddHHmmssString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [df stringFromDate:self];
}

- (NSString *)agoString:(BOOL)hasTime
{
    NSDate *now = [NSDate date];
    NSTimeInterval dt = now.timeIntervalSince1970 - self.timeIntervalSince1970;
    NSTimeInterval L = (now.hour * 60 + now.minute) * 60 + now.second;
    
    NSString *ret = nil, *time = [NSString stringWithFormat:@"%02d:%02d", (int)self.hour, (int)self.minute];
    if (dt > L) {
        if (dt > L + (60 * 60 * 24)) {
            if (now.year == self.year) {
                ret = [NSString stringWithFormat:@"%02d-%02d", (int)self.month, (int)self.day];
            } else {
                ret = [NSString stringWithFormat:@"%d-%02d-%02d", (int)self.year, (int)self.month, (int)self.day];
            }
        } else {
            ret = @"昨天";
        }
        return hasTime ? [NSString stringWithFormat:@"%@ %@", ret, time] : ret;
    }
    return time;
}

- (NSString *)agoYYYYMMddString
{
    NSDate *now = [NSDate date];
    NSTimeInterval dt = now.timeIntervalSince1970 - self.timeIntervalSince1970;
    NSTimeInterval L = (now.hour * 60 + now.minute) * 60 + now.second;
    
    NSString *ret = @"今天";
    if (dt > L) {
        if (dt > L + (60 * 60 * 24)) {
            if (now.year == self.year) {
                ret = [NSString stringWithFormat:@"%02d-%02d", (int)self.month, (int)self.day];
            } else {
                ret = [NSString stringWithFormat:@"%d-%02d-%02d", (int)self.year, (int)self.month, (int)self.day];
            }
        } else {
            ret = @"昨天";
        }
    }
    return ret;
}
@end
