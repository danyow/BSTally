//
//  TabBarController.h
//  BSTally
//
//  Created by Danyow on 16/7/29.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

- (void)addChildViewController:(UIViewController *)childController;

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers;

@end
