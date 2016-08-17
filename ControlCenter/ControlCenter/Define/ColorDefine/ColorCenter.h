//
//  ColorCenter.h
//  ControlCenter
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/9.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCenter : NSObject

+ (UIColor *)colorWithHexInteger:(NSInteger)hexInteger;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)randomColor;

+ (instancetype)shareColorCenter;

@property (nonatomic, strong) UIColor *themeColor;

@end
