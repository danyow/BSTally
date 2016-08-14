//
//  AssetsHolder+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AssetsHolder.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsHolder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSMutableSet<NSManagedObject *> *assets;

@end

@interface AssetsHolder (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(NSManagedObject *)value;
- (void)removeAssetsObject:(NSManagedObject *)value;
- (void)addAssets:(NSMutableSet<NSManagedObject *> *)values;
- (void)removeAssets:(NSMutableSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
