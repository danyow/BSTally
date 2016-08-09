//
//  AssetsHolder+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AssetsHolder.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsHolder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSMutableSet<TangibleAssets *> *tangibleAssets;
@property (nullable, nonatomic, retain) NSMutableSet<IntangibleAssets *> *intangibleAssets;

@end

@interface AssetsHolder (CoreDataGeneratedAccessors)

- (void)addTangibleAssetsObject:(TangibleAssets *)value;
- (void)removeTangibleAssetsObject:(TangibleAssets *)value;
- (void)addTangibleAssets:(NSMutableSet<TangibleAssets *> *)values;
- (void)removeTangibleAssets:(NSMutableSet<TangibleAssets *> *)values;

- (void)addIntangibleAssetsObject:(IntangibleAssets *)value;
- (void)removeIntangibleAssetsObject:(IntangibleAssets *)value;
- (void)addIntangibleAssets:(NSMutableSet<IntangibleAssets *> *)values;
- (void)removeIntangibleAssets:(NSMutableSet<IntangibleAssets *> *)values;

@end

NS_ASSUME_NONNULL_END
