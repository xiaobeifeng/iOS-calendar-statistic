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
    // 获取系统当前时间
    NSDate *currentDate = [NSDate date];
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

@end
