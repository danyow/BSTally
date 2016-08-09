//
//  ToolCenter.m
//  ToolCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "ToolCenter.h"

@implementation ToolCenter

+ (NSString *)currentDateStringWithDateFormat:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    return [formatter stringFromDate:[NSDate date]];
}

@end
