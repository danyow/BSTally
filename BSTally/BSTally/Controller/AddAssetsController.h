//
//  AddAssetsController.h
//  BSTally
//
//  Created by Danyow on 16/8/13.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "BasicViewController.h"

@class Assets;

@interface AddAssetsController : BasicViewController

+ (instancetype)addAssetsControllerWithCompleteCallback:(void(^)())completeCallback;

@end
