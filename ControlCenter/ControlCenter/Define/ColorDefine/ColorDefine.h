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
#define kColor_HexInteger(Interger) [ColorCenter colorWithHexInteger:(Interger)]
#define kColor_HexString(String)    [ColorCenter colorWithHexString:(String)]
#define kColor_Alpha(Color, Alpha)  [Color colorWithAlphaComponent:(Alpha)]

#endif /* ColorDefine_h */
