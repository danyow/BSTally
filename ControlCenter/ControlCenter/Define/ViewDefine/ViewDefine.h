//
//  ViewDefine.h
//  ControlCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#ifndef ViewDefine_h
#define ViewDefine_h

#define kWindow_Width                [UIScreen mainScreen].bounds.size.width
#define kWindow_Height               [UIScreen mainScreen].bounds.size.height

#define kView_Height(view)           CGRectGetHeight((view).frame)
#define kView_Width(view)            CGRectGetWidth((view).frame)
#define kView_MaxX(view)             CGRectGetMaxX((view).frame)
#define kView_MidX(view)             CGRectGetMidX((view).frame)
#define kView_MinX(view)             CGRectGetMinX((view).frame)
#define kView_MaxY(view)             CGRectGetMaxY((view).frame)
#define kView_MidY(view)             CGRectGetMidY((view).frame)
#define kView_MinY(view)             CGRectGetMinY((view).frame)

#define kStateBarHeight              20
#define kBarHeight                   44
#define kNavBarHeight                (kStateBarHeight + kBarHeight)
#define kMargin                      8


#endif /* ViewDefine_h */
