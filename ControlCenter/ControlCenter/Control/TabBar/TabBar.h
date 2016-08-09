//
//  DNOTabBar.h
//  ControlCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBar : UITabBar

@property (nonatomic, strong) UIButton *centerButton;

+ (instancetype)tabBarReplaceTabBarController:(UITabBarController *)tabBarController;

@end
