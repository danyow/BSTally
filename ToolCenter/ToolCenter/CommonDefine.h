//
//  CommonDefine.h
//  ToolCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h


#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"🚩%s \n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#define NSLog(FORMAT, ...) fprintf(stderr,"🚩%s  (🔍%s %d)\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String], __FUNCTION__, __LINE__);
#else
#define NSLog(FORMAT, ...) nil
#endif

#endif /* CommonDefine_h */
