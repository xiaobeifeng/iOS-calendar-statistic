//
//  NSDate+CSDate.h
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CSDate)

- (NSString *)date2stringWithFormat:(NSString *)format;

- (BOOL)isToday;

@end

NS_ASSUME_NONNULL_END
