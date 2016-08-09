//
//  DNOTabBar.m
//  ControlCenter
//
//  Created by Danyow on 16/8/3.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "TabBar.h"
#import "ColorDefine.h"
#import "CommonDefine.h"
#import "ViewDefine.h"

@interface TabBar ()

@property (nonatomic, strong) NSMutableArray     *tabBarButton;
@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation TabBar

#pragma mark -
#pragma mark public method

+ (instancetype)tabBarReplaceTabBarController:(UITabBarController *)tabBarController
{
    UITabBar *replaceTabBar = tabBarController.tabBar;
    TabBar *tabBar = [[self alloc] initWithFrame:replaceTabBar.bounds];
    [tabBarController setValue:tabBar forKey:@"tabBar"];
    tabBar.tabBarController = tabBarController;
    return tabBar;
}

#pragma mark -
#pragma mark life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.centerButton];
    }
    return self;
}

#pragma mark -
#pragma mark over write

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tabBarButton removeAllObjects];
    [self.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [self.tabBarButton addObject:view];
        }
    }];
    
    NSInteger count = self.tabBarButton.count;
    if (!count) {
        return;
    }
    
    NSInteger mid  = count / 2;
    if (count % 2) {
        self.tabBarButton[mid] = self.centerButton;
    }
    
    CGFloat width  = kView_Width(self) / count;
    CGFloat height = kView_Height(self);
    CGFloat y      = 0;
    [self.tabBarButton enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGFloat x = idx * width;
        view.frame = CGRectMake(x, y, width, height);
    }];
}

#pragma mark -
#pragma mark private method
- (void)centerButtonPressed:(UIButton *)button
{
    NSInteger count = self.tabBarButton.count;
    [self.tabBarController setSelectedIndex:(count % 2)];
}

#pragma mark -
#pragma mark lazyload

- (UIButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        _centerButton.backgroundColor = kColor_Random;
        [_centerButton addTarget:self action:@selector(centerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}

- (NSMutableArray *)tabBarButton
{
    if (!_tabBarButton) {
        _tabBarButton = [[NSMutableArray alloc] init];
    }
    return _tabBarButton;
}

@end
