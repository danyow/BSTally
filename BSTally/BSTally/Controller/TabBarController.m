//
//  TabBarController.m
//  BSTally
//
//  Created by Danyow on 16/7/29.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
#import "TabBar.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)addChildViewController:(UIViewController *)childController
{
    if (![childController isKindOfClass:[NavigationController class]]) {
        childController = [[NavigationController alloc] initWithRootViewController:childController];
    }
    [super addChildViewController:childController];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    NSMutableArray *newViewControllers = [viewControllers mutableCopy];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *childController, NSUInteger idx, BOOL *stop) {
        if (![childController isKindOfClass:[NavigationController class]]) {
            newViewControllers[idx] = [[NavigationController alloc] initWithRootViewController:childController];
        }
    }];
    [super setViewControllers:newViewControllers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[TabBar tabBarReplaceTabBarController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
