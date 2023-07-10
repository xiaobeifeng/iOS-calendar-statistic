//
//  CSCalendarStoreManager.h
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/8.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSCalendarStoreManager : NSObject

+ (CSCalendarStoreManager *)sharedManager;

typedef void(^CSCalendarStoreManagerCompletionHandler)(NSArray *calendars);
typedef void(^CSCalendarStoreManagerCalendarEventCompletionHandler)(NSDictionary *result);

- (void)getCalendarsForEntityType:(CSCalendarStoreManagerCompletionHandler)completion;
- (void)getCalendarEventWithCalendarIdentifier:(NSString *)calendarIdentifier completion:(CSCalendarStoreManagerCalendarEventCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
