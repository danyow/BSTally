//
//  PayBorrowDetail+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PayBorrowDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayBorrowDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) BorrowDetail *whichBorrowDetail;
@property (nullable, nonatomic, retain) BorrowExpendDetail *whichBorrowExpendDetail;

@end

NS_ASSUME_NONNULL_END
