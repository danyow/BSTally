//
//  Detail.h
//  DataCenter
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Assets;

NS_ASSUME_NONNULL_BEGIN

@interface Detail : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Detail+CoreDataProperties.h"
#import "IncomeDetail.h"
#import "ExpendDetail.h"
#import "LendDetail.h"
#import "PayLendDetail.h"
#import "BorrowDetail.h"
#import "BorrowExpendDetail.h"
#import "PayBorrowDetail.h"
