//
//  NSDate+ToString.m
//  BSTally
//
//  Created by Danyow on 16/8/15.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "NSDate+ToString.h"

@implementation NSDate (ToString)

+ (NSString *)currentDateStringWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
