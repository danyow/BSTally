//
//  UIBriefLabel.h
//  CommonControl
//
//  Created by Danyow on 16/7/4.
//  Copyright © 2016年 Danyow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBriefLabel : UILabel

@property (nonatomic, copy  ) NSString *briefText;
@property (nonatomic, strong) UIFont   *briefFont;
@property (nonatomic, strong) UIColor  *briefColor;

@property (nonatomic, copy  ) NSString *totalText;

@end
