//
//  Assets.h
//  DataCenter
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssetsHolder, Detail;

NS_ASSUME_NONNULL_BEGIN

@interface Assets : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Assets+CoreDataProperties.h"
#import "TangibleAssets.h"
#import "IntangibleAssets.h"