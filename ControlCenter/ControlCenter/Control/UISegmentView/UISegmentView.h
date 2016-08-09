//
//  UISegmentView.h
//  baseControl
//
//  Created by Danyow on 16/5/31.
//  Copyright © 2016年 Raryo Information. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kUISegmentViewImageName;
UIKIT_EXTERN NSString * const kUISegmentViewLabelText;

@class UISegmentView;

@protocol UISegmentViewDelegate <NSObject>

- (void)segmentView:(UISegmentView *)view didSelectedIndex:(NSInteger)index segmentTitle:(NSString *)string;

@end

@interface UISegmentButton : UIButton

+ (instancetype)buttonWithUIButton:(UIButton *)button;

@end

@interface UISegmentView : UIView

@property (nonatomic, weak) IBOutlet id<UISegmentViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray <UISegmentButton *>*buttons;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) BOOL needlessCornerRadius;

- (void)addButton:(UISegmentButton *)button;
- (void)reloadButtons;
- (void)setIndex:(NSInteger)index;

- (void)setButtonsWithDictArray:(NSArray <NSDictionary *>*)dictArray;

@end
