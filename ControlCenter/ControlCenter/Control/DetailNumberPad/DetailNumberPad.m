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

- (void)setInputField:(UITextField *)textField completeCallback:(void(^)(NSInteger number))completeCallback
{
    self.needInputField = textField;
    self.completeCallback = completeCallback;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touching = YES;
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    NSInteger rowIndex   = touchPoint.x / self.keyWidth;
    NSInteger sectionIndex = touchPoint.y / self.keyHeight;
    self.indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.touching = NO;
    self.moving = NO;
    [self removeTouchAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    });
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
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
    
    __block CGFloat centerX = 0;
    __block CGFloat centerY = 0;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:30]};
    [self.keyValues enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop) {
        CGSize valueSize = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        centerX = self.keyWidth * 0.5 + self.keyWidth * (idx % 3) - valueSize.width * 0.5;
        centerY = self.keyHeight * 0.5 + self.keyHeight * (idx / 3) - valueSize.height * 0.5;
        [value drawAtPoint:CGPointMake(centerX, centerY) withAttributes:attributes];
    }];
    
    if (self.touching) {
        CGRect pathRect = CGRectMake(self.indexPath.row * self.keyWidth, self.indexPath.section * self.keyHeight, self.keyWidth, self.keyHeight);
        
//        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:pathRect];
//        [rectPath addClip];

        UIBezierPath *beginPath;
            if (self.moving) {
                UIBezierPath *beginPath = [UIBezierPath bezierPathWithRoundedRect:({
                    CGRectMake(self.touchPoint.x, self.touchPoint.y, 0, 0);
                }) cornerRadius:0];
            } else {
                beginPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect)) radius:self.keyHeight * 0.5 startAngle:-M_PI endAngle:M_PI clockwise:YES];
//                [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect), self.keyHeight, self.keyHeight) cornerRadius:self.keyHeight * 0.5];
                
//                [UIBezierPath bezierPathWithOvalInRect:CGRectMake(CGRectGetMinX(pathRect) + (self.keyWidth - self.keyHeight) * 0.5, CGRectGetMinY(pathRect), self.keyHeight, self.keyHeight)];
            }
        
        UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect)) radius:sqrt(self.keyWidth * 0.5 * self.keyWidth * 0.5 + self.keyHeight * 0.5 * self.keyHeight * 0.5) startAngle:-M_PI endAngle:M_PI clockwise:YES];
//        [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:0];
        
        CAShapeLayer *rectLayer = [CAShapeLayer layer];
        rectLayer.frame         = rect;
        rectLayer.path          = endPath.CGPath;
        rectLayer.strokeColor   = [UIColor clearColor].CGColor;
        rectLayer.fillColor     = kColor_Black.CGColor;
        rectLayer.fillMode      = kCAFillModeRemoved;
        
        CABasicAnimation *rectAimation   = [CABasicAnimation animationWithKeyPath:@"path"];
        rectAimation.fromValue           = (__bridge id)beginPath.CGPath;
        rectAimation.toValue             = (__bridge id)endPath.CGPath;
        rectAimation.duration            = 2;
        [rectLayer addAnimation:rectAimation forKey:nil];
        
        self.touchAnimation = rectAimation;
        self.touchLayer = rectLayer;
        [self.layer addSublayer:rectLayer];
    }
    
   
}


- (void)removeTouchAnimation
{
//    CGRect pathRect = CGRectMake(self.indexPath.row * self.keyWidth, self.indexPath.section * self.keyHeight, self.keyWidth, self.keyHeight);
//    self.touchAnimation.fromValue = self.touchAnimation.toValue;
//    self.touchAnimation.toValue = (__bridge id)[UIBezierPath bezierPathWithRoundedRect:({
//        CGRect beginRect;
//        if (self.moving) {
//            beginRect = CGRectMake(self.touchPoint.x, self.touchPoint.y, 0.7 * self.keyWidth, 0.7 * self.keyHeight);
//        } else {
//            beginRect = CGRectMake(CGRectGetMidX(pathRect) - 0.35 * self.keyWidth, CGRectGetMidY(pathRect) - 0.35 * self.keyHeight, 0.7 * self.keyWidth, 0.7 * self.keyHeight);
//
//        }
//        beginRect;
//    }) cornerRadius:0].CGPath;
//    [self.touchLayer addAnimation:self.touchAnimation forKey:nil];
    CAShapeLayer *rectLayer = self.touchLayer;
//    rectLayer.fillColor = kColor_Clear.CGColor;
    
    [UIView animateWithDuration:0.1 animations:^{
        rectLayer.fillColor = kColor_Clear.CGColor;
    } completion:^(BOOL finished) {
        [rectLayer removeFromSuperlayer];
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [rectLayer removeFromSuperlayer];
//    });
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


@end
