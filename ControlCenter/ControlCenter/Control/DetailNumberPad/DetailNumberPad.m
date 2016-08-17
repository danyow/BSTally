//
//  DetailNumberPad.m
//  ControlCenter
//
//  Created by Danyow on 16/8/8.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "DetailNumberPad.h"
#import "ControlDefine.h"

#define kRow                4
#define kColumn             3

@interface DetailNumberPad ()

@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, strong) CAShapeLayer *touchLayer;
@property (nonatomic, strong) CABasicAnimation *touchAnimation;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign, readonly) CGFloat keyWidth;
@property (nonatomic, assign, readonly) CGFloat keyHeight;
@property (nonatomic, strong, readonly) NSArray *keyValues;

@property (nonatomic, assign) BOOL moving;
@property (nonatomic, assign) BOOL touching;

@property (nonatomic, copy) void (^completeCallback)(NSInteger number);

@end

@implementation DetailNumberPad

#pragma mark -
#pragma mark public method

+ (instancetype)numberPadWithInputField:(UITextField *)textField completeCallback:(void(^)(NSInteger number))completeCallback
{
    DetailNumberPad *numberPad = [[self alloc] initWithFrame:CGRectMake(0, 0, kWindow_Width, kWindow_Height * 0.5)];
    numberPad.backgroundColor = kColor_White;
    numberPad.layer.borderColor = kColor_Black.CGColor;
    numberPad.layer.borderWidth = 0.5;
    numberPad.completeCallback = completeCallback;
    numberPad.needInputField = textField;
    return numberPad;
}

- (void)setInputField:(UITextField *)textField completeCallback:(void(^)(NSInteger number))completeCallback
{
    self.needInputField = textField;
    self.completeCallback = completeCallback;
}

#pragma mark -
#pragma mark event handle

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.touching = YES;
    NSInteger rowIndex   = touchPoint.x / self.keyWidth;
    NSInteger sectionIndex = touchPoint.y / self.keyHeight;
    self.indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];

    if (touch.tapCount >= 2) {
        if (rowIndex == 0 && sectionIndex == kRow - 1) {
            if (self.completeCallback) {
                [self.needInputField resignFirstResponder];
                self.completeCallback(self.needInputField.text.doubleValue);
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchMoveWithTouchPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchEndWithTouchPoint:[[touches anyObject] locationInView:self]];
}

#pragma mark -
#pragma mark private method

- (void)touchMoveWithTouchPoint:(CGPoint)touchPoint
{
    touchPoint.x = touchPoint.x < 0 ? 0 : touchPoint.x;
    touchPoint.y = touchPoint.y < 0 ? 0 : touchPoint.y;
    touchPoint.x = touchPoint.x > kView_Width(self) ? kView_Width(self) : touchPoint.x;
    touchPoint.y = touchPoint.x > kView_Height(self) ? kView_Height(self) : touchPoint.y;
    
    NSInteger rowIndex   = touchPoint.x / self.keyWidth;
    NSInteger sectionIndex = touchPoint.y / self.keyHeight;
    
    if (self.indexPath.row == rowIndex && self.indexPath.section == sectionIndex) {
        return;
    }
    self.moving = YES;
    self.touchPoint = touchPoint;
    [self removeTouchAnimation];
    self.indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    [self setNeedsDisplay];
}
- (void)touchEndWithTouchPoint:(CGPoint)touchPoint
{
    
    self.touching = NO;
    self.moving = NO;
    [self removeTouchAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    });
    touchPoint.x = touchPoint.x < 0 ? 0 : touchPoint.x;
    touchPoint.y = touchPoint.y < 0 ? 0 : touchPoint.y;
    touchPoint.x = touchPoint.x > kView_Width(self) ? kView_Width(self) - 0.01: touchPoint.x;
    touchPoint.y = touchPoint.x > kView_Height(self) ? kView_Height(self) - 0.01 : touchPoint.y;
    NSInteger rowIndex   = touchPoint.x / self.keyWidth;
    NSInteger sectionIndex = touchPoint.y / self.keyHeight;
    self.indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    
    
    NSString *keyValue = self.keyValues[sectionIndex * 3 + rowIndex];
    NSString *dot      = self.keyValues[9];
    NSString *zero     = self.keyValues[10];
    NSString *delete   = self.keyValues[11];
    if ([self.needInputField.text containsString:dot] && [keyValue isEqualToString:dot]) {
        return;
    }
    if ([self.needInputField.text hasPrefix:zero] && [keyValue isEqualToString:zero]) {
        return;
    }
    if (self.needInputField.text.length && [keyValue isEqualToString:delete]) {
        self.needInputField.text = [self.needInputField.text substringToIndex:self.needInputField.text.length - 1];
        return;
    }
    if (!self.needInputField.text.length && [keyValue isEqualToString:delete]) {
        return;
    }
    self.needInputField.text = [self.needInputField.text stringByAppendingString:keyValue];
}

- (void)removeTouchAnimation
{
    CAShapeLayer *rectLayer = self.touchLayer;
    [rectLayer removeFromSuperlayer];
}


- (void)setNeedInputField:(UITextField *)needInputField
{
    _needInputField = needInputField;
    needInputField.inputView = self;
}

- (CGFloat)keyWidth
{
    return kView_Width(self) / kColumn;
}

- (CGFloat)keyHeight
{
    return kView_Height(self) / kRow;
}


- (NSArray *)keyValues
{
    return @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @".", @"0", @"⌫"];
}


- (void)drawRect:(CGRect)rect
{
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    linePath.lineWidth = 0.2;
    
    [linePath moveToPoint:CGPointMake(0, self.keyHeight)];
    for (int i = 1; i < kRow; ++i) {
        [linePath addLineToPoint:CGPointMake(kView_Width(self), i * self.keyHeight)];
        [linePath stroke];
        [linePath moveToPoint:CGPointMake(0, (i + 1) * self.keyHeight)];
    }
    [linePath moveToPoint:CGPointMake(self.keyWidth, 0)];
    for (int i = 1; i < kColumn; ++i) {
        [linePath addLineToPoint:CGPointMake(i * self.keyWidth, kView_Height(self))];
        [linePath stroke];
        [linePath moveToPoint:CGPointMake((i + 1) * self.keyWidth, 0)];
    }
    
    [[UIColor grayColor] set];
    
    if (self.touching) {
        CGRect pathRect = CGRectMake(self.indexPath.row * self.keyWidth, self.indexPath.section * self.keyHeight, self.keyWidth, self.keyHeight);
        
        UIBezierPath *beginPath;
        if (self.moving) {
            beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.touchPoint.x, self.touchPoint.y, 0, 0) cornerRadius:0.001];
        } else {
            beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(pathRect) + (self.keyWidth - self.keyHeight) * 0.5, CGRectGetMinY(pathRect), self.keyHeight, self.keyHeight) cornerRadius:self.keyHeight * 0.5];
        }
        UIBezierPath *endPath =
        [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:0.001];
        
        CAShapeLayer *rectLayer = [CAShapeLayer layer];
        rectLayer.frame         = rect;
        rectLayer.path          = endPath.CGPath;
        rectLayer.strokeColor   = [UIColor clearColor].CGColor;
        rectLayer.fillColor     = kColor_Black.CGColor;
        rectLayer.fillMode      = kCAFillModeBackwards;
        
        CABasicAnimation *rectAimation   = [CABasicAnimation animationWithKeyPath:@"path"];
        rectAimation.fromValue           = (__bridge id)beginPath.CGPath;
        rectAimation.toValue             = (__bridge id)endPath.CGPath;
        rectAimation.duration            = .2;
        [rectLayer addAnimation:rectAimation forKey:nil];
        
        self.touchAnimation = rectAimation;
        self.touchLayer = rectLayer;
        [self.layer addSublayer:rectLayer];
    }
    
    
    __block CGFloat centerX = 0;
    __block CGFloat centerY = 0;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:30],
                                 NSForegroundColorAttributeName : kColor_Random
                                 };
    [self.keyValues enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop) {
        CGSize valueSize = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        centerX = self.keyWidth * 0.5 + self.keyWidth * (idx % 3) - valueSize.width * 0.5;
        centerY = self.keyHeight * 0.5 + self.keyHeight * (idx / 3) - valueSize.height * 0.5;
        
        
        
        if (self.indexPath) {
            if (self.touching) {
                NSMutableDictionary *attribute = [NSMutableDictionary dictionaryWithDictionary:attributes];
                [attribute setObject:kColor_Random forKey:NSForegroundColorAttributeName];
                [value drawAtPoint:CGPointMake(centerX, centerY) withAttributes:attribute];
            }
        } else {
            [value drawAtPoint:CGPointMake(centerX, centerY) withAttributes:attributes];
        }
        
    }];
    
}

@end
