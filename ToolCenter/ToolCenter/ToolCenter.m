//
//  ToolCenter.m
//  ToolCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "ToolCenter.h"

@implementation ToolCenter

+ (instancetype)shareTool
{
    static ToolCenter *tool_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool_ = [[self alloc] init];
    });
    return tool_;
}

- (NSString *)currentDateStringWithDateFormat:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatString;
    return [formatter stringFromDate:[NSDate date]];
}

@end
