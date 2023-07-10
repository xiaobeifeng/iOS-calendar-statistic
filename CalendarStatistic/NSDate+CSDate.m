//
//  NSDate+CSDate.m
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/8.
//

#import "NSDate+CSDate.h"

@implementation NSDate (CSDate)

/// NSDate 转 NSString
/// - Parameter format: eg. yyyy-MM-dd HH:mm:ss
- (NSString *)date2stringWithFormat:(NSString *)format {
    // 用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置格式：zzz表示时区
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:format];
    // NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:self];
    
    return currentDateString;
}
/// 日期时间是否是今天
- (BOOL)isToday {
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [currentDate date2stringWithFormat:@"YYYY-MM-dd"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSDate *startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", currentDateString]];
    NSDate *endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 23:59:59", currentDateString]];
    
    if ([self compare:startDate] == NSOrderedDescending && [self compare:endDate] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}
@end
