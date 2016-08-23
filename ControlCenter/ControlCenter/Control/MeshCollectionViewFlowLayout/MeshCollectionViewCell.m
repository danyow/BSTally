//
//  MeshCollectionViewCell.m
//  MINS-UIHD
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/22.
//  Copyright © 2016年 联新. All rights reserved.
//

#import "MeshCollectionViewCell.h"

@interface MeshCollectionViewCell ()

@end

@implementation MeshCollectionViewCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_label) {
        self.label.frame = self.bounds;
    }
    if (_button) {
        self.button.frame = self.bounds;
    }
    if (_imageView) {
        self.imageView.frame = self.bounds;
    }
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return _label;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor clearColor];
        [_button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self addSubview:_button];
    }
    return _button;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
