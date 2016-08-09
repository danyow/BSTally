//
//  PureColorButton.h
//  ControlCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PureColorButton;

@protocol PureColorButtonDelegate <NSObject>

- (void)pureButtonStateChanged:(PureColorButton *)button;

@end

@interface PureColorButton : UIButton

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *disableColor;

@property (nonatomic, assign) CFTimeInterval duration;

@property (nonatomic, weak) id<PureColorButtonDelegate> delegate;

@end
