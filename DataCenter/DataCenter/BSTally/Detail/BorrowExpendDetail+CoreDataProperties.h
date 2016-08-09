//
//  BorrowExpendDetail+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BorrowExpendDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface BorrowExpendDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSMutableSet<PayBorrowDetail *> *payBorrowDetails;

@end

@interface BorrowExpendDetail (CoreDataGeneratedAccessors)

- (void)addPayBorrowDetailsObject:(PayBorrowDetail *)value;
- (void)removePayBorrowDetailsObject:(PayBorrowDetail *)value;
- (void)addPayBorrowDetails:(NSMutableSet<PayBorrowDetail *> *)values;
- (void)removePayBorrowDetails:(NSMutableSet<PayBorrowDetail *> *)values;

@end

NS_ASSUME_NONNULL_END
