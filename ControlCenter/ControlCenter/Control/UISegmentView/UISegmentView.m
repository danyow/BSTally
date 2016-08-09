//
//  UISegmentView.m
//  baseControl
//
//  Created by Danyow on 16/5/31.
//  Copyright © 2016年 Raryo Information. All rights reserved.
//

#import "UISegmentView.h"

NSString * const kUISegmentViewLabelText = @"text";
NSString * const kUISegmentViewImageName = @"name";

@interface UISegmentView ()

@property (nonatomic, strong) UISegmentButton *selectedButton;

@property (nonatomic, assign) BOOL isClick;

@end

@implementation UISegmentView
- (void)prepareUI
{
    if (!self.needlessCornerRadius) {        
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = (self.tintColor ? : [UIColor blackColor]).CGColor;
        self.clipsToBounds = YES;
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)setIndex:(NSInteger)index
{
    if (self.isClick || index > self.buttons.count - 1 || self.buttons.count == 0) {
        return;
    }
    [self changeButtonState:self.buttons[index]];
}

- (void)addButton:(UISegmentButton *)button
{
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    [self layoutIfNeeded];
    if ([self.buttons containsObject:button]) {
        return;
    }
    [self.buttons addObject:button];
}

- (void)reloadButtons
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons enumerateObjectsUsingBlock:^(UISegmentButton *button, NSUInteger idx, BOOL *stop) {
        [self addButton:button];
    }];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.buttons enumerateObjectsUsingBlock:^(UISegmentButton * button, NSUInteger idx, BOOL *stop) {
        
        
//        UISegmentButton *segmentButton = [UISegmentButton buttonWithUIButton:button];
        
        [self addSubview:button];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:(self.tintColor ? : [UIColor blackColor])forState:UIControlStateNormal];
        
        if (button.imageView.image) {
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, -68, 0, 0);
        }
        
        [button setFrame:({
            CGFloat height = self.frame.size.height;
            CGFloat width = self.frame.size.width / self.buttons.count;
            CGFloat x = idx * width;
            CGFloat y = 0;
            CGRectMake(x, y, width, height);
        })];

        if (idx == 0) {
            [self buttonDidClick:button];
        }
        
        if (idx == self.buttons.count - 1) {
            return ;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:({
            CGFloat height = self.frame.size.height;
            CGFloat width = 1;
            CGFloat x = CGRectGetMaxX(button.frame) - 1;
            CGFloat y = 0;
            CGRectMake(x, y, width, height);
        })];
        
        
        
        [self addSubview:lineView];
        lineView.backgroundColor = self.tintColor ? : [UIColor blackColor];
    }];
}

- (void)buttonDidClick:(UISegmentButton *)sender
{
    if (self.isClick || self.selectedButton == sender) {
        return;
    }
    
    self.isClick = YES;
    
    [self changeButtonState:sender];
    
    if ([self.delegate respondsToSelector:@selector(segmentView:didSelectedIndex:segmentTitle:)]) {
        [self.delegate segmentView:self didSelectedIndex:[self.buttons indexOfObject:sender] segmentTitle:sender.currentTitle];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isClick = NO;
    });
}

- (void)changeButtonState:(UISegmentButton *)sender
{
    [self.selectedButton setBackgroundColor:[UIColor clearColor]];
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    [self.selectedButton setBackgroundColor:(self.tintColor ? : [UIColor blackColor])];
    
    if (!sender) {
        return;
    }
    
    self.selectedIndex = [self.buttons indexOfObject:sender];
}

- (NSMutableArray<UISegmentButton *> *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [self changeButtonState:self.buttons.firstObject];
    [self prepareUI];
    
//    [self.buttons enumerateObjectsUsingBlock:^(UISegmentButton *button, NSUInteger idx, BOOL *stop) {
//        UIImage *image = [button imageForState:UIControlStateSelected];
//        [button setImage:[ImageHelper imageWithColor:tintColor
//                                           baseImage:image] forState:UIControlStateNormal];
//    }];
    
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    [self.buttons enumerateObjectsUsingBlock:^(UISegmentButton *button, NSUInteger idx, BOOL *stop) {
        UIImage *image = [button imageForState:UIControlStateSelected];
        button.titleLabel.font = textFont;
    }];
}

- (void)setNeedlessCornerRadius:(BOOL)needlessCornerRadius
{
    _needlessCornerRadius = needlessCornerRadius;
    self.layer.cornerRadius = 0;
    self.layer.borderWidth = 0;
}

- (void)setButtonsWithDictArray:(NSArray <NSDictionary *>*)dictArray
{
    [self.buttons removeAllObjects];
    for (NSDictionary *dict in dictArray) {
        UISegmentButton *button = [UISegmentButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = (self.textFont ? : [UIFont systemFontOfSize:18]);
        [button setBackgroundColor:[UIColor whiteColor]];
        if (dict[kUISegmentViewLabelText]) {
            [button setTitle:(NSString *)dict[kUISegmentViewLabelText]
                    forState:UIControlStateNormal];
        }
        if (dict[kUISegmentViewImageName]) {
            [button setImage:(UIImage *)dict[kUISegmentViewImageName]
                    forState:UIControlStateSelected];
//            [button setImage:[ImageHelper imageWithColor:(self.tintColor ? : [UIColor blackColor]) baseImage:(UIImage *)dict[kUISegmentViewImageName]]
//                    forState:UIControlStateNormal];
        }
        [self.buttons addObject:button];
    }
    [self reloadButtons];
}


@end

@implementation UISegmentButton



- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image) {
        [self.titleLabel setFrame:({
            CGRect frame = self.titleLabel.frame;
            frame.origin.x = self.frame.size.width * 0.5 + 8;
            frame;
        })];
    }else{
        [self.titleLabel setCenter:({
            CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        })];
    }
}



+ (instancetype)buttonWithUIButton:(UIButton *)button
{
    UISegmentButton *segmentButton = [UISegmentButton buttonWithType:button.buttonType];
    
    [segmentButton setTitle:button.currentTitle forState:UIControlStateNormal];
    [segmentButton setImage:button.currentImage forState:UIControlStateNormal];
    
    return segmentButton;
}



@end

