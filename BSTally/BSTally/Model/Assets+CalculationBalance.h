//
//  Assets+CalculationBalance.h
//  BSTally
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "Assets.h"

@interface Assets (CalculationBalance)

- (void)calculationBalanceWithSingleDetail:(Detail *)singleDetail isAdd:(BOOL)isAdd;
- (void)calculationBalance;

@end
