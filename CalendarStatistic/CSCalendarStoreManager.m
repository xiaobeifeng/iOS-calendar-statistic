//
//  CSCalendarStoreManager.m
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/8.
//

#import "CSCalendarStoreManager.h"


@interface CSCalendarStoreManager()

@property(nonatomic, strong) EKEventStore *eventStore;
@property(nonatomic, strong) NSMutableArray *ekCalendarsMarray;

@end

@implementation CSCalendarStoreManager

+ (CSCalendarStoreManager *)sharedManager {
    static CSCalendarStoreManager *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[super allocWithZone:NULL] init];
        [single start];
    });
    return single;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [CSCalendarStoreManager sharedManager];
}

- (id)copyWithZone:(NSZone *)zone{
    return  [CSCalendarStoreManager sharedManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [CSCalendarStoreManager sharedManager];
}

- (void)start {
    _eventStore = [[EKEventStore alloc] init];
    _ekCalendarsMarray = [NSMutableArray new];
}

- (void)getCalendarsForEntityType:(CSCalendarStoreManagerCompletionHandler)completion {
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent
                                completion:^(BOOL granted, NSError * _Nullable error) {
        NSArray *calendarArray = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
        NSMutableArray *calendarInfoMarray = [NSMutableArray new];
        for (EKCalendar *calendar in calendarArray) {
            if (calendar.type == EKCalendarTypeCalDAV) {
                NSDictionary *dict = @{
                    @"id": calendar.calendarIdentifier,
                    @"title": calendar.title,
                    @"color": [calendar.color hexStringWithHasAlpha:NO]
                };
                [calendarInfoMarray addObject:dict];
                [self.ekCalendarsMarray addObject:calendar];
            }
            
        }
        completion(calendarInfoMarray);
    }];
}

- (NSDictionary *)currentWeek {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSLog(@"%ld----%ld",weekDay,day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    return @{@"startDay": firstDayOfWeek, @"endDay": lastDayOfWeek};
}

- (void)getCalendarEventWithCalendarIdentifier:(NSString *)calendarIdentifier completion:(CSCalendarStoreManagerCalendarEventCompletionHandler)completion {
    for (EKCalendar *ekCalendar in _ekCalendarsMarray) {
        if ([ekCalendar.calendarIdentifier isEqualToString:calendarIdentifier]) {
            NSDictionary *dateDict = [self currentWeek];
            NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:dateDict[@"startDay"] endDate:dateDict[@"endDay"] calendars:@[ekCalendar]];
            NSArray *eventArray = [_eventStore eventsMatchingPredicate:predicate];
            NSLog(@"%@", eventArray);
            
            NSMutableArray *weekWorkMarray = [NSMutableArray new];
            CGFloat totalHour = 0.00f;
            for (int i = 0; i < eventArray.count; i++) {
                EKEvent *event = eventArray[i];
                NSLog(@"%@", event);
                NSLog(@"%@", event.startDate);
                NSLog(@"%@", event.endDate);
                NSLog(@"%@", event.title);
                NSLog(@"%@", event.notes);
                NSLog(@"%@", event.lastModifiedDate);
                NSTimeInterval time = [event.endDate timeIntervalSinceDate:event.startDate];
                NSLog(@"%.2f 小时", time/60/60);
                float time2hour = time/60/60;
                totalHour = totalHour + time2hour;
                NSDictionary *mDict = @{
                    @"startDate": [event.startDate date2stringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
                    @"endDate": [event.endDate date2stringWithFormat:@"yyyy-MM-dd HH:mm:ss"],
                    @"title": event.title,
                    @"lastHour": [NSString stringWithFormat:@"%.2f", time2hour],
                    @"index": @(i+1)
                };
                NSLog(@"%@", mDict);
                [weekWorkMarray addObject:mDict];
            }
            NSDictionary *weekWorkDict = @{
                @"totalHour": [NSString stringWithFormat:@"%.2f", totalHour],
                @"calendarName": ekCalendar.title,
                @"dateInterval": [NSString stringWithFormat:@"%@ 至 %@", [dateDict[@"startDay"] date2stringWithFormat:@"yyyy-MM-dd"] , [dateDict[@"endDay"] date2stringWithFormat:@"yyyy-MM-dd"]],
                @"data": weekWorkMarray
            };
            
            completion(weekWorkDict);
        }
    }
}

@end
