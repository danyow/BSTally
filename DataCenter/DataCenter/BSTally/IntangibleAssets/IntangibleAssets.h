//
//  IntangibleAssets.h
//  DataCenter
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Detail, AssetsHolder;

NS_ASSUME_NONNULL_BEGIN

@interface IntangibleAssets : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "IntangibleAssets+CoreDataProperties.h"
#import "IOUAssets.h"
#import "GoldBarAssets.h"
#import "CreditCardsAssets.h"
#import "HuaBeiAssets.h"
#import "JieBeiAsset.h"
