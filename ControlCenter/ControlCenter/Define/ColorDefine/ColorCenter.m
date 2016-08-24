//
//  ColorCenter.m
//  ControlCenter
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/9.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "ColorCenter.h"

#define kEightMax 255.0

@implementation ColorCenter

static ColorCenter *instance_;

+ (instancetype)shareColorCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [self new];
    });
    return instance_;
}


+ (UIColor *)colorWithHexInteger:(NSInteger)hexInteger
{
    return [UIColor colorWithRed:((hexInteger & 0x00FF0000) >> 16) / kEightMax
                           green:((hexInteger & 0x0000FF00) >> 8) / kEightMax
                            blue:((hexInteger & 0x000000FF)) / kEightMax alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSScanner * scanner = [NSScanner scannerWithString:hexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return [self colorWithHexInteger:hexNumber.integerValue];
}

+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random() % 256 / kEightMax
                           green:arc4random() % 256 / kEightMax
                            blue:arc4random() % 256 / kEightMax alpha:1];
}

//- (NSString *)hexString
//{
//    UIColor *color = self;
//    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
//        const CGFloat *components = CGColorGetComponents(color.CGColor);
//        color = [UIColor colorWithRed:components[0]
//                                green:components[0]
//                                 blue:components[0]
//                                alpha:components[1]];
//    }
//    
//    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
//        return [NSString stringWithFormat:@"#FFFFFF"];
//    }
//    
//    return [NSString stringWithFormat:@"#XXX",
//            (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
//            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
//            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
//}


- (UIColor *)themeColor
{
    if (!_themeColor) {
        _themeColor = [ColorCenter colorWithHexString:@"0xe6e6e6"];
    }
    return _themeColor;
}

@end
