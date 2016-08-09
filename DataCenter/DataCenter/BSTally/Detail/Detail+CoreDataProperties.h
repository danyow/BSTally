//
//  Detail+CoreDataProperties.h
//  DataCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Detail.h"

NS_ASSUME_NONNULL_BEGIN

@interface Detail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *remarks;
@property (nullable, nonatomic, retain) id tags;
@property (nullable, nonatomic, retain) IntangibleAssets *whichIntangibleAssets;
@property (nullable, nonatomic, retain) TangibleAssets *whichTangibleAssets;

@end

NS_ASSUME_NONNULL_END
