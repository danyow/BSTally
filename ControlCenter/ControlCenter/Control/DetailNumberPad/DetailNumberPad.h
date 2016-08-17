//
//  DetailNumberPad.h
//  ControlCenter
//
//  Created by Danyow on 16/8/8.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailNumberPad : UIView

@property (nonatomic, strong) UITextField *needInputField;

+ (instancetype)numberPadWithInputField:(UITextField *)textField completeCallback:(void(^)(NSInteger number))completeCallback;
- (void)setInputField:(UITextField *)textField completeCallback:(void(^)(NSInteger number))completeCallback;

@end
