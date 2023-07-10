//
//  NSColor+CSColor.m
//  CalendarStatistic
//
//  Created by ZhouJian on 2023/7/8.
//

#import "NSColor+CSColor.h"

@implementation NSColor (CSColor)

- (NSString *)hexStringWithHasAlpha:(BOOL)hasAlpha {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int)(r * 255.0f)<<16 | (int)(g * 255.0f)<<8 | (int)(b * 255.0f)<<0;
    if (hasAlpha) {
        rgb = (int)(a * 255.0f)<<24 | (int)(r * 255.0f)<<16 | (int)(g * 255.0f)<<8 | (int)(b * 255.0f)<<0;
    }

    return [NSString stringWithFormat:@"#%06x", rgb];
}


@end
