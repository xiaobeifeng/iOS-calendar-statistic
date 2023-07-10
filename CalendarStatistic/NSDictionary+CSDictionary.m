//
//  NSDictionary+CSDictionary.m
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/8.
//

#import "NSDictionary+CSDictionary.h"

@implementation NSDictionary (CSDictionary)

- (NSString *)toJsonString {
    NSString *json = nil;
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if(!error) {
            json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"JSON parse error: %@", error);
        }
    } else {
        NSLog(@"Not a valid JSON object: %@", self);
    }
    return json;
}

@end
