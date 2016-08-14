//
//  IntangibleAssets+CalculationBalance.m
//  BSTally
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/9.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "IntangibleAssets+CalculationBalance.h"
#import "Detail.h"

@implementation IntangibleAssets (CalculationBalance)

- (void)calculationBalanceWithSingleDetail:(Detail *)singleDetail isAdd:(BOOL)isAdd
{
    if (![singleDetail isKindOfClass:[BorrowDetail class]] &&
        ![singleDetail isKindOfClass:[BorrowExpendDetail class]] &&
        ![singleDetail isKindOfClass:[PayBorrowDetail class]]) {
        NSLog(@"IntangibleAssets只会有BorrowDetail, BorrowExpendDetail, PayBorrowDetail的");
        return;
    }
    double amount = singleDetail.amount.doubleValue  * (isAdd ? 1 : -1);
    
    if ([singleDetail isKindOfClass:[BorrowDetail class]]) {
        BorrowDetail *borrow = (BorrowDetail *)singleDetail;
        NSLog(@"[%@] 刷 %@", borrow.date, borrow.amount);
        self.borrowBalance = @(self.borrowBalance.doubleValue + amount);
    }
    if ([singleDetail isKindOfClass:[BorrowExpendDetail class]]) {
        BorrowExpendDetail *borrExpendDetail = (BorrowExpendDetail *)singleDetail;
        NSLog(@"[%@] 预支 %@", borrExpendDetail.date, borrExpendDetail.amount);
        self.borrowBalance = @(self.borrowBalance.doubleValue + amount);
    }
    if ([singleDetail isKindOfClass:[PayBorrowDetail class]]) {
        PayBorrowDetail *payBorrow = (PayBorrowDetail *)singleDetail;
        NSLog(@"[%@] 还 %@", payBorrow.date, payBorrow.amount);
        self.borrowBalance = @(self.borrowBalance.doubleValue - amount);
    }
    self.balance = @(self.quota.doubleValue - self.borrowBalance.doubleValue);
    NSLog(@"quota:%@, balance:%@, borrowBalance:%@", self.quota, self.balance, self.borrowBalance);
}

- (void)calculationBalance
{
    NSSortDescriptor *sortDescripator = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *dailys = [self.dailys sortedArrayUsingDescriptors:@[sortDescripator]];
    [dailys enumerateObjectsUsingBlock:^(Detail *singleDetail, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([singleDetail isKindOfClass:[BorrowDetail class]]) {
            BorrowDetail *borrow = (BorrowDetail *)singleDetail;
            NSLog(@"[%@] 刷 %@", borrow.date, borrow.amount);
            self.borrowBalance = @(self.borrowBalance.doubleValue + borrow.amount.doubleValue);
        }
        if ([singleDetail isKindOfClass:[BorrowExpendDetail class]]) {
            BorrowExpendDetail *borrExpendDetail = (BorrowExpendDetail *)singleDetail;
            NSLog(@"[%@] 预支 %@", borrExpendDetail.date, borrExpendDetail.amount);
            self.borrowBalance = @(self.borrowBalance.doubleValue + borrExpendDetail.amount.doubleValue);
        }
        if ([singleDetail isKindOfClass:[PayBorrowDetail class]]) {
            PayBorrowDetail *payBorrow = (PayBorrowDetail *)singleDetail;
            NSLog(@"[%@] 还 %@", payBorrow.date, payBorrow.amount);
            self.borrowBalance = @(self.borrowBalance.doubleValue - payBorrow.amount.doubleValue);
        }
        self.balance = @(self.quota.doubleValue - self.borrowBalance.doubleValue);
    }];
    NSLog(@"quota:%@, balance:%@, borrowBalance:%@", self.quota, self.balance, self.borrowBalance);
}



@end
