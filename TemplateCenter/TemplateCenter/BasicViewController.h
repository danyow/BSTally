//
//  BasicViewController.h
//  TemplateCenter
//
//  Created by Danyow on 16/8/4.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "ControlDefine.h"

@interface BasicViewController : UIViewController

@property (nonatomic, strong) UIView   *bottomContainer;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel  *titleLabel;

- (void)viewWillAddSubview;

@end
