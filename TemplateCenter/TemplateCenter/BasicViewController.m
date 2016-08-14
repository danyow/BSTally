//
//  BasicViewController.m
//  TemplateCenter
//
//  Created by Danyow on 16/8/4.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()



@end

@implementation BasicViewController

#pragma mark -
#pragma mark life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = kColor_White;
    [self viewWillAddSubview];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAddSubview
{
    [self.view addSubview:self.headerContainer];
    [self.headerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@(kNavBarHeight));
    }];
    
    [self.view addSubview:self.bottomContainer];
    [self.bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(@0);
        make.height.equalTo(@(kBarHeight));
    }];
    
    if (self.backButton) {
        [self.headerContainer addSubview:self.backButton];
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
            make.width.height.equalTo(@(kBarHeight));
        }];
    }
    
    [self.headerContainer addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(UIEdgeInsetsMake(20, 0, 0, 0));
        make.width.height.equalTo(@(kBarHeight));
    }];
    
    [self.headerContainer addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(kStateBarHeight * 0.5));
    }];
    
    
}

#pragma mark -
#pragma mark event handle

- (void)backButtonPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightButtonPressed:(UIButton *)sender
{
    
}

#pragma mark -
#pragma mark lazy load

- (UIView *)headerContainer
{
    if (!_headerContainer) {
        _headerContainer = [[UIView alloc] init];
        _headerContainer.backgroundColor = kColor_Random;
    }
    return _headerContainer;
}

- (UIView *)bottomContainer
{
    if (!_bottomContainer) {
        _bottomContainer = [[UIView alloc] init];
        _bottomContainer.backgroundColor = kColor_Random;
    }
    return _bottomContainer;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        
        if (self.parentViewController) {
            
            if (self.navigationController.childViewControllers.count <= 1) {
                return nil;
            } else {
                _backButton = [[UIButton alloc] init];
                [_backButton setTitle:@"返回" forState:UIControlStateNormal];
            }
        } else {
            _backButton = [[UIButton alloc] init];
            [_backButton setTitle:@"退出" forState:UIControlStateNormal];
        }
        [_backButton setTitleColor:kColor_Black forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:kColor_Black forState:UIControlStateNormal];
        [_rightButton setTitle:@"添加" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标题";
    }
    return _titleLabel;
}

@end
