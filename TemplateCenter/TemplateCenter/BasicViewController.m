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
    self.view.backgroundColor = kColor_Random;
    [self viewWillAddSubview];
}

- (void)viewWillAddSubview
{
    [self.view addSubview:self.bottomContainer];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(@0);
        make.height.equalTo(@(kBarHeight));
    }];
    
}

#pragma mark -
#pragma mark lazy load
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
        _backButton = [[UIButton alloc] init];
    }
    return _backButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

@end
