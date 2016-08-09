//
//  PureColorButton.m
//  ControlCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "PureColorButton.h"

@implementation PureColorButton

#pragma mark -
#pragma mark life cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self preparatoryWork];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self preparatoryWork];
    }
    return self;
}


#pragma mark -
#pragma mark over write

- (void)setHighlighted:(BOOL)highlighted
{
    if([super isHighlighted] != highlighted) {
        [super setHighlighted:highlighted];
        [self changeColor];
        if ([self.delegate respondsToSelector:@selector(pureButtonStateChanged:)]) {
            [self.delegate pureButtonStateChanged:self];
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    if([super isSelected] != selected) {
        [super setSelected:selected];
        [self changeColor];
        if ([self.delegate respondsToSelector:@selector(pureButtonStateChanged:)]) {
            [self.delegate pureButtonStateChanged:self];
        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if([super isEnabled] != enabled) {
        [super setEnabled:enabled];
        [self changeColor];
        if ([self.delegate respondsToSelector:@selector(pureButtonStateChanged:)]) {
            [self.delegate pureButtonStateChanged:self];
        }
    }
}

#pragma mark -
#pragma mark private method

- (void)preparatoryWork
{
    self.duration = 0.3;
    self.selected = NO;
}

- (void)changeColor
{
    UIColor *backgroundColor;
    if(![self isEnabled]) {
        backgroundColor = self.disableColor;
    } else if([self isHighlighted]) {
        backgroundColor = [self isSelected] ? self.normalColor : self.highlightColor;
    } else if([self isSelected]) {
       backgroundColor = self.selectedColor;
    } else {
       backgroundColor = self.normalColor;
    }
    [UIView animateWithDuration:self.duration animations:^{
        self.backgroundColor = backgroundColor;
    }];
}

#pragma mark -
#pragma mark setter

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [self changeColor];
}

-(void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
    [self changeColor];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [self changeColor];
}

- (void)setDisableColor:(UIColor *)disableColor
{
    _disableColor = disableColor;
    [self changeColor];
}

@end
