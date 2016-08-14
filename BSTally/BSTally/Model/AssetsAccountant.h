//
//  AssetsAccountant.h
//  BSTally
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Detail.h"
#import "IntangibleAssets.h"
#import "TangibleAssets.h"

typedef enum {
    AssetsTypeCash          = 100,
    AssetsTypeYueBao        = 101,
    AssetsTypeChange        = 102,
    AssetsTypeDebitCard     = 103,
    
    AssetsTypeIOU           = 200,
    AssetsTypeGoldBar       = 201,
    AssetsTypeCreditCards   = 202,
    AssetsTypeHuaBei        = 203,
    AssetsTypeJieBei        = 204,
}AssetsType;

typedef enum {
    DetailTypeIncome        = 100,
    DetailTypeExpend        = 101,
    
    DetailTypeLend          = 200,
    DetailTypePayLend       = 201,
    
    DetailTypeBorrow        = 300,
    DetailTypeBorrowExpend  = 301,
    DetailTypePayBorrow     = 302,
}DetailType;

@interface AssetsAccountant : NSObject

+ (instancetype)shareAccountant;

- (AssetsType)queryAssetsTypeWithAssetsName:(NSString *)assetsName;
- (id)queryAssetsObjectWithAssetsName:(NSString *)assetsName;

- (Detail *)addDetailType:(DetailType)detailType amount:(NSNumber *)amount date:(NSString *)date remarks:(NSString *)remarks tags:(NSArray *)tags toWhichAssets:(NSString *)assetsName;
- (void)moveDetail:(Detail*)detail toNewAssets:(NSString *)assetsName;
- (void)deleteDetail:(Detail *)detail;

- (void)creatNewAssetsName:(NSString *)name assetsType:(AssetsType)assetsType;

- (void)tangibleAssetName:(NSString *)name resetBalance:(NSNumber *)balance borrowBalance:(NSNumber *)borrowBalance lendBalance:(NSNumber *)lendBalance;
- (void)intangibleAssetName:(NSString *)name resetQuota:(NSNumber *)quota balance:(NSNumber *)balance borrowBalance:(NSNumber *)borrowBalance;

- (void)assetsName:(NSString *)oldName changeNewName:(NSString *)newName;

@end
