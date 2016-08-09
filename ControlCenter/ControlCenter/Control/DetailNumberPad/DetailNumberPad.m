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

@property (nonatomic, assign) BOOL moving;
@property (nonatomic, assign) BOOL touching;

@end

@implementation DetailNumberPad


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
    
    if (touchPoint.x < 0 ||
        touchPoint. y < 0 ||
        touchPoint.x > kView_Width(self) ||
        touchPoint.y > kView_Height(self)) {
        return;
    }
    
    NSLog(@"%@", NSStringFromCGPoint(touchPoint));
    
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
//    CGPoint touchPoint = [[touches anyObject] locationInView:self];
//    NSInteger rowIndex   = touchPoint.x / self.keyWidth;
//    NSInteger sectionIndex = touchPoint.y / self.keyHeight;
//    self.indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
//    [self setNeedsDisplay];
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
    if (self.touching) {
        CGRect pathRect = CGRectMake(self.indexPath.row * self.keyWidth, self.indexPath.section * self.keyHeight, self.keyWidth, self.keyHeight);
        UIBezierPath *beginPath = [UIBezierPath bezierPathWithRoundedRect:({
            CGRect beginRect;
            if (self.moving) {
                beginRect = CGRectMake(self.touchPoint.x, self.touchPoint.y, 0, 0);
            } else {
                beginRect = CGRectMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect), 0, 0);
            }
            beginRect;
        }) cornerRadius:0];
        
        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:0];
        
        CAShapeLayer *rectLayer = [CAShapeLayer layer];
        rectLayer.frame         = rect;
        rectLayer.path          = endPath.CGPath;
        rectLayer.strokeColor   = [UIColor clearColor].CGColor;
        rectLayer.fillColor     = kColor_Black.CGColor;
        rectLayer.fillMode      = kCAFillModeRemoved;
        
        CABasicAnimation *rectAimation   = [CABasicAnimation animationWithKeyPath:@"path"];
        rectAimation.fromValue           = (__bridge id)beginPath.CGPath;
        rectAimation.toValue             = (__bridge id)endPath.CGPath;
        rectAimation.duration            = 0.2;
        [rectLayer addAnimation:rectAimation forKey:nil];
        
        self.touchAnimation = rectAimation;
        self.touchLayer = rectLayer;
        [self.layer addSublayer:rectLayer];
    }
}


- (void)removeTouchAnimation
{
    CGRect pathRect = CGRectMake(self.indexPath.row * self.keyWidth, self.indexPath.section * self.keyHeight, self.keyWidth, self.keyHeight);
    self.touchAnimation.fromValue = self.touchAnimation.toValue;
    self.touchAnimation.toValue = (__bridge id)[UIBezierPath bezierPathWithRoundedRect:({
        CGRect beginRect;
        if (self.moving) {
            beginRect = CGRectMake(self.touchPoint.x, self.touchPoint.y, 0, 0);
        } else {
            beginRect = CGRectMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect), 0, 0);
        }
        beginRect;
    }) cornerRadius:0].CGPath;
    [self.touchLayer addAnimation:self.touchAnimation forKey:nil];
    CAShapeLayer *rectLayer = self.touchLayer;
    rectLayer.fillColor = kColor_Clear.CGColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [rectLayer removeFromSuperlayer];
    });
}

- (CGFloat)keyWidth
{
    return kView_Width(self) / kColumn;
}

- (CGFloat)keyHeight
{
    return kView_Height(self) / kRow;
}





@end
