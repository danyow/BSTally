//
//  TangibleAssets+CalculationBalance.h
//  BSTally
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/9.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "TangibleAssets.h"

@interface TangibleAssets (CalculationBalance)
- (void)calculationBalanceWithSingleDetail:(Detail *)singleDetail isAdd:(BOOL)isAdd;
- (void)calculationBalance;
@end
