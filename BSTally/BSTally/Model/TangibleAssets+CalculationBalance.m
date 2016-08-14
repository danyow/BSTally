//
//  TangibleAssets+CalculationBalance.m
//  BSTally
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/9.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "TangibleAssets+CalculationBalance.h"
#import "Detail.h"

@implementation TangibleAssets (CalculationBalance)

- (void)calculationBalanceWithSingleDetail:(Detail *)singleDetail isAdd:(BOOL)isAdd
{
    if ([singleDetail isKindOfClass:[BorrowExpendDetail class]]) {
        NSLog(@"TangibleAssets是不能有BorrowExpendDetail的");
        return;
    }
    
    double amount = singleDetail.amount.doubleValue  * (isAdd ? 1 : -1);
    
    if ([singleDetail isKindOfClass:[IncomeDetail class]]) {
        IncomeDetail *income = (IncomeDetail *)singleDetail;
        NSLog(@"[%@] 入 %@", income.date, income.amount);
        self.balance = @(self.balance.doubleValue + amount);
    }
    if ([singleDetail isKindOfClass:[ExpendDetail class]]) {
        ExpendDetail *expend = (ExpendDetail *)singleDetail;
        NSLog(@"[%@] 出 %@", expend.date, expend.amount);
        self.balance = @(self.balance.doubleValue - amount);
    }
    if ([singleDetail isKindOfClass:[LendDetail class]]) {
        LendDetail *lend = (LendDetail *)singleDetail;
        NSLog(@"[%@] 借 %@", lend.date, lend.amount);
        self.balance = @(self.balance.doubleValue - amount);
        self.lendBalance = @(self.lendBalance.doubleValue + amount);
    }
    if ([singleDetail isKindOfClass:[PayLendDetail class]]) {
        PayLendDetail *payLend = (PayLendDetail *)singleDetail;
        NSLog(@"[%@] 收 %@", payLend.date, payLend.amount);
        self.balance = @(self.balance.doubleValue + amount);
        self.lendBalance = @(self.lendBalance.doubleValue - amount);
    }
    if ([singleDetail isKindOfClass:[BorrowDetail class]]) {
        BorrowDetail *borrow = (BorrowDetail *)singleDetail;
        NSLog(@"[%@] 欠 %@", borrow.date, borrow.amount);
        self.balance = @(self.balance.doubleValue + amount);
        self.borrowBalance = @(self.borrowBalance.doubleValue + amount);
    }
    if ([singleDetail isKindOfClass:[PayBorrowDetail class]]) {
        PayBorrowDetail *payBorrow = (PayBorrowDetail *)singleDetail;
        NSLog(@"[%@] 还 %@", payBorrow.date, payBorrow.amount);
        self.balance = @(self.balance.doubleValue - amount);
        self.borrowBalance = @(self.borrowBalance.doubleValue - amount);
    }
    NSLog(@"balance:%@, lendBalance:%@, borrowBalance:%@", self.balance, self.lendBalance, self.borrowBalance);
}

- (void)calculationBalance
{
    NSSortDescriptor *sortDescripator = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *dailys = [self.dailys sortedArrayUsingDescriptors:@[sortDescripator]];
    
    [dailys enumerateObjectsUsingBlock:^(Detail *singleDetail, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([singleDetail isKindOfClass:[IncomeDetail class]]) {
            IncomeDetail *income = (IncomeDetail *)singleDetail;
            NSLog(@"[%@] 入 %@", income.date, income.amount);
            self.balance = @(self.balance.doubleValue + income.amount.doubleValue);
        }
        if ([singleDetail isKindOfClass:[ExpendDetail class]]) {
            ExpendDetail *expend = (ExpendDetail *)singleDetail;
            NSLog(@"[%@] 出 %@", expend.date, expend.amount);
            self.balance = @(self.balance.doubleValue - expend.amount.doubleValue);
        }
        if ([singleDetail isKindOfClass:[LendDetail class]]) {
            LendDetail *lend = (LendDetail *)singleDetail;
            NSLog(@"[%@] 借 %@", lend.date, lend.amount);
            self.balance = @(self.balance.doubleValue - lend.amount.doubleValue);
            self.lendBalance = @(self.lendBalance.doubleValue + lend.amount.doubleValue);
        }
        if ([singleDetail isKindOfClass:[PayLendDetail class]]) {
            PayLendDetail *payLend = (PayLendDetail *)singleDetail;
            NSLog(@"[%@] 收 %@", payLend.date, payLend.amount);
            self.balance = @(self.balance.doubleValue + payLend.amount.doubleValue);
            self.lendBalance = @(self.lendBalance.doubleValue - payLend.amount.doubleValue);
        }
        if ([singleDetail isKindOfClass:[BorrowDetail class]]) {
            BorrowDetail *borrow = (BorrowDetail *)singleDetail;
            NSLog(@"[%@] 欠 %@", borrow.date, borrow.amount);
            self.balance = @(self.balance.doubleValue + borrow.amount.doubleValue);
            self.borrowBalance = @(self.borrowBalance.doubleValue + borrow.amount.doubleValue);
        }
        
        if ([singleDetail isKindOfClass:[PayBorrowDetail class]]) {
            PayBorrowDetail *payBorrow = (PayBorrowDetail *)singleDetail;
            NSLog(@"[%@] 还 %@", payBorrow.date, payBorrow.amount);
            self.balance = @(self.balance.doubleValue - payBorrow.amount.doubleValue);
            self.borrowBalance = @(self.borrowBalance.doubleValue - payBorrow.amount.doubleValue);
        }
    }];
    NSLog(@"balance:%@, lendBalance:%@, borrowBalance:%@", self.balance, self.lendBalance, self.borrowBalance);
}


@end
