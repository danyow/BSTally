//
//  UIBriefLabel.m
//  CommonControl
//
//  Created by Danyow on 16/7/4.
//  Copyright © 2016年 Danyow. All rights reserved.
//

#import "UIBriefLabel.h"

#define DefaultFont  [UIFont systemFontOfSize:16]
#define DefaultColor [UIColor darkTextColor]

@interface UIBriefLabel ()

@property (nonatomic, copy) NSString *defaultText;
@property (nonatomic, strong) UIColor *defaultTextColor;
@property (nonatomic, strong) UIFont *defaultFont;

@end

@implementation UIBriefLabel

#pragma mark -
#pragma mark over write

- (void)sizeToFit
{
    [super sizeToFit];
    NSDictionary *briefAttributed =
    @{NSFontAttributeName : self.briefFont ? : DefaultFont,
      NSForegroundColorAttributeName : self.briefColor ? : DefaultColor};
    NSDictionary *defaultAttributed =
    @{NSFontAttributeName : self.defaultFont ? : DefaultFont,
      NSForegroundColorAttributeName : self.defaultTextColor ? : DefaultColor};
    CGSize briedSize = [self text:self.briefText withAttributed:briefAttributed];
    CGSize defaultSize = [self text:self.defaultText withAttributed:defaultAttributed];
    [self setFrame:({
        CGRect frame = self.frame;
        frame.size.width = briedSize.width + defaultSize.width;
        frame.size.height = MAX(briedSize.height, defaultSize.height);
        frame;
    })];
    [self drawRect:self.frame];
}

- (void)drawRect:(CGRect)rect
{
    if (!self.briefText || !self.defaultText) {
        return;
    }
    
    NSString *briefText = self.briefText;
    NSDictionary *briefAttributed =
    @{NSFontAttributeName : self.briefFont ? : DefaultFont,
      NSForegroundColorAttributeName : self.briefColor ? : DefaultColor};
    NSString *text = self.defaultText;
    NSDictionary *defaultAttributed =
    @{NSFontAttributeName : self.defaultFont ? : DefaultFont,
      NSForegroundColorAttributeName : self.defaultTextColor ? : DefaultColor};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.totalText];
    [attributedString addAttributes:briefAttributed range:[self.totalText rangeOfString:briefText]];
    [attributedString addAttributes:defaultAttributed range:[self.totalText rangeOfString:text]];
    self.attributedText = attributedString;
    
    CGSize briedSize = [self text:briefText withAttributed:briefAttributed];
    CGSize defaultSize = [self text:text withAttributed:defaultAttributed];
    [briefText drawInRect:CGRectMake(0, (MAX(briedSize.height, defaultSize.height) - briedSize.height) * 0.5, briedSize.width, briedSize.height) withAttributes:briefAttributed];
    [text drawInRect:CGRectMake(briedSize.width, (MAX(briedSize.height, defaultSize.height) - defaultSize.height) * 0.5, defaultSize.width, defaultSize.height) withAttributes:defaultAttributed];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.defaultFont = font;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.defaultText = text;
    self.totalText = [NSString stringWithFormat:@"%@%@", self.briefText, self.defaultText];
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    self.defaultTextColor = textColor;
    [self setNeedsDisplay];
}

- (NSString *)text
{
    return self.defaultText;
}


#pragma mark -
#pragma mark private method

- (CGSize)text:(NSString *)text withAttributed:(NSDictionary *)attributed
{
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attributed context:nil].size;
}

#pragma mark -
#pragma mark setter
- (void)setBriefText:(NSString *)briefText
{
    _briefText = briefText;
    self.totalText = [NSString stringWithFormat:@"%@%@", self.briefText, self.defaultText];
   [self setNeedsDisplay];
}

- (void)setBriefFont:(UIFont *)briefFont
{
    _briefFont = briefFont;
    [self setNeedsDisplay];
}

- (void)setBriefColor:(UIColor *)briefColor
{
    _briefColor = briefColor;
    [self setNeedsDisplay];
}




@end
