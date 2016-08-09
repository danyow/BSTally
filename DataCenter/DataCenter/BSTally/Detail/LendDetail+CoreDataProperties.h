//
//  LendDetail+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LendDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface LendDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSMutableSet<PayLendDetail *> *paylendDetails;

@end

@interface LendDetail (CoreDataGeneratedAccessors)

- (void)addPaylendDetailsObject:(PayLendDetail *)value;
- (void)removePaylendDetailsObject:(PayLendDetail *)value;
- (void)addPaylendDetails:(NSMutableSet<PayLendDetail *> *)values;
- (void)removePaylendDetails:(NSMutableSet<PayLendDetail *> *)values;

@end

NS_ASSUME_NONNULL_END
