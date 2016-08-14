//
//  Assets+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Assets.h"

NS_ASSUME_NONNULL_BEGIN

@interface Assets (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *balance;
@property (nullable, nonatomic, retain) NSNumber *borrowBalance;
@property (nullable, nonatomic, retain) NSString *createDate;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSMutableSet<Detail *> *dailys;
@property (nullable, nonatomic, retain) AssetsHolder *whoHolder;

@end

@interface Assets (CoreDataGeneratedAccessors)

- (void)addDailysObject:(Detail *)value;
- (void)removeDailysObject:(Detail *)value;
- (void)addDailys:(NSMutableSet<Detail *> *)values;
- (void)removeDailys:(NSMutableSet<Detail *> *)values;

@end

NS_ASSUME_NONNULL_END
