//
//  ColorDefine.h
//  ControlCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "ColorCenter.h"
#ifndef ColorDefine_h
#define ColorDefine_h

#define kColor_White                [UIColor whiteColor]
#define kColor_Clear                [UIColor clearColor]
#define kColor_Black                [UIColor blackColor]
#define kColor_Random               [ColorCenter randomColor]
#define kColor_Theme                [ColorCenter shareColorCenter].themeColor
#define kColor_HexInteger(INTERGER) [ColorCenter colorWithHexInteger:(INTERGER)]
#define kColor_HexString(STRING)    [ColorCenter colorWithHexString:(STRING)]
#define kColor_Alpha(COLOR, ALPHA)  [COLOR colorWithAlphaComponent:(ALPHA)]

#endif /* ColorDefine_h */
