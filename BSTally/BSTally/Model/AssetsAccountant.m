//
//  AssetsAccountant.m
//  BSTally
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "AssetsAccountant.h"
#import "AppDelegate.h"

#import "Detail.h"
#import "TangibleAssets.h"
#import "IntangibleAssets.h"
#import "AssetsHolder.h"
#import "ToolCenter.h"
#import "TangibleAssets+CalculationBalance.h"
#import "IntangibleAssets+CalculationBalance.h"

@interface AssetsAccountant ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *tangibleAssetsController;

@property (nonatomic, strong) NSMutableSet *allAssets;
@property (nonatomic, strong) AssetsHolder *holder;

@end

@implementation AssetsAccountant

static AssetsAccountant *accountant_;

+ (instancetype)shareAccountant
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountant_ = [[self alloc] init];
        [accountant_ loadHolderData];
    });
    return accountant_;
}

- (void)loadHolderData
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([AssetsHolder class])];
    [fetch setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"userName" ascending:YES]]];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    controller.delegate = self;
    NSError *fetchError = nil;
    
    if ([controller performFetch:&fetchError]) {
        NSLog(@"Fecth Holder Data Success!!");
    } else {
        NSLog(@"Fecth Holder Data Failed??");
    }
    
    if ([[controller.sections objectAtIndex:0] numberOfObjects]) {
        self.holder = [controller objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        self.holder = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([AssetsHolder class]) inManagedObjectContext:self.context];
        self.holder.userName = @"Danyow.Ed";
        [self save];
    }
}

- (void)save
{
    NSError *error;
    if ([self.context save:&error]) {
        NSLog(@"Save Success");
    } else {
        NSLog(@"Save Faild %@", error);
    }
}

- (AssetsType)queryAssetsName:(NSString *)assetsName
{
    __block AssetsType type;
    [self.allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj name] isEqualToString:assetsName]) {
            if ([obj isKindOfClass:[CashAssets class]]) {
                type = AssetsTypeCash;
            } else if ([obj isKindOfClass:[YueBaoAssets class]]) {
                type = AssetsTypeYueBao;
            } else if ([obj isKindOfClass:[ChangeAssets class]]) {
                type = AssetsTypeChange;
            } else if ([obj isKindOfClass:[DebitCardAssets class]]) {
                type = AssetsTypeDebitCard;
            } else if ([obj isKindOfClass:[IOUAssets class]]) {
                type = AssetsTypeIOU;
            } else if ([obj isKindOfClass:[GoldBarAssets class]]) {
                type = AssetsTypeGoldBar;
            } else if ([obj isKindOfClass:[CreditCardsAssets class]]) {
                type = AssetsTypeCreditCards;
            } else if ([obj isKindOfClass:[HuaBeiAssets class]]) {
                type = AssetsTypeHuaBei;
            } else if ([obj isKindOfClass:[JieBeiAsset class]]) {
                type = AssetsTypeJieBei;
            } else {
                NSLog(@"查询时：没用找到对应的类型");
            }
        }
    }];
    return type;
}

- (void)creatNewAssetsName:(NSString *)name assetsType:(AssetsType)assetsType
{
    for (id obj in self.allAssets) {
        if ([[obj name] isEqualToString:name]) {
            NSLog(@"创建Assets时：已经有重名的assets了");
            return;
        }
    }
    Class assetsClass;
    switch (assetsType) {
        case AssetsTypeCash:
            assetsClass = [CashAssets class];
            break;
        case AssetsTypeYueBao:
            assetsClass = [YueBaoAssets class];
            break;
        case AssetsTypeChange:
            assetsClass = [ChangeAssets class];
            break;
        case AssetsTypeDebitCard:
            assetsClass = [DebitCardAssets class];
            break;
        case AssetsTypeIOU:
            assetsClass = [IOUAssets class];
            break;
        case AssetsTypeGoldBar:
            assetsClass = [GoldBarAssets class];
            break;
        case AssetsTypeCreditCards:
            assetsClass = [CreditCardsAssets class];
            break;
        case AssetsTypeHuaBei:
            assetsClass = [HuaBeiAssets class];
            break;
        case AssetsTypeJieBei:
            assetsClass = [JieBeiAsset class];
            break;
    }
    id assets = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([assetsClass class]) inManagedObjectContext:self.context];
    
    [assets setValue:name forKey:@"name"];
    [assets setValue:self.holder forKey:@"whoHolder"];
    [assets setValue:[ToolCenter currentDateStringWithDateFormat:@"yyyy-MM-dd"] forKey:@"createDate"];
    if (assetsType < AssetsTypeIOU) {
        [self.holder.tangibleAssets addObject:assets];
        NSLog(@"创建Assets时：holder添加了一个%@，tangibleAssets", name);
    } else {
        [self.holder.intangibleAssets addObject:assets];
        NSLog(@"创建Assets时：holder添加了一个%@，intangibleAssets", name);
    }
    [self save];
}

- (void)tangibleAssetName:(NSString *)name resetBalance:(NSNumber *)balance borrowBalance:(NSNumber *)borrowBalance lendBalance:(NSNumber *)lendBalance
{
    __block NSInteger count = 0;
    [self.allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj name] isEqualToString:name]) {
            if ([obj isKindOfClass:[IntangibleAssets class]]) {
                NSLog(@"重置时：找到了名字一样的 但是Assets类型不一致")
                *stop = YES;
                return;
            }
            TangibleAssets *tangible = obj;
            tangible.balance = balance;
            tangible.borrowBalance = borrowBalance;
            tangible.lendBalance = lendBalance;
            [self save];
            *stop = YES;
            return;
        }
        if (count == self.allAssets.count - 1) {
            NSLog(@"重置时：没有对应的tangibleAsset");
        }
        count++;
    }];
}
- (void)intangibleAssetName:(NSString *)name resetQuota:(NSNumber *)quota balance:(NSNumber *)balance borrowBalance:(NSNumber *)borrowBalance
{
    __block NSInteger count = 0;
    [self.allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj name] isEqualToString:name]) {
            if ([obj isKindOfClass:[TangibleAssets class]]) {
                NSLog(@"重置时：找到了名字一样的 但是Assets类型不一致")
                *stop = YES;
                return;
            }
            IntangibleAssets *intangible = obj;
            intangible.balance = balance;
            intangible.borrowBalance = borrowBalance;
            intangible.quota = quota;
            [self save];
            *stop = YES;
            return;
        }
        if (count == self.allAssets.count - 1) {
            NSLog(@"重置时：没有对应的intangibleAsset");
        }
        count++;
    }];
}

- (void)assetsName:(NSString *)oldName changeNewName:(NSString *)newName;
{
    __block NSInteger count = 0;
    [self.allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj name] isEqualToString:oldName]) {
            [obj setName:newName];
            [self save];
            *stop = YES;
            return;
        }
        if (count == self.allAssets.count - 1) {
            NSLog(@"改名时：没有对应的assets");
        }
        count++;
    }];
}

- (Detail *)addDetailType:(DetailType)detailType amount:(NSNumber *)amount date:(NSString *)date remarks:(NSString *)remarks tags:(NSArray *)tags toWhichAssets:(NSString *)assetsName
{
    __block NSInteger count = 0;
    __block Detail *detail;
    [self.allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj name] isEqualToString:assetsName]) {
            Class detailClass;
            switch (detailType) {
                case DetailTypeIncome:
                    detailClass = [IncomeDetail class];
                    break;
                case DetailTypeExpend:
                    detailClass = [ExpendDetail class];
                    break;
                case DetailTypeLend:
                    detailClass = [LendDetail class];
                    break;
                case DetailTypePayLend:
                    detailClass = [PayLendDetail class];
                    break;
                case DetailTypeBorrow:
                    detailClass = [BorrowDetail class];
                    break;
                case DetailTypeBorrowExpend:
                    detailClass = [BorrowExpendDetail class];
                    break;
                case DetailTypePayBorrow:
                    detailClass = [PayBorrowDetail class];
                    break;
            }
            
            detail = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([detailClass class]) inManagedObjectContext:self.context];
            
            detail.amount = amount;
            detail.remarks = remarks;
            detail.tags = tags;
            detail.date = date ? [date stringByAppendingString:@" 12:00:00"] : [ToolCenter currentDateStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            if ([obj isKindOfClass:[TangibleAssets class]]) {
                detail.whichTangibleAssets = obj;
            } else {
                detail.whichIntangibleAssets = obj;
            }
            [[obj dailys] addObject:detail];
            [obj calculationBalanceWithSingleDetail:detail isAdd:YES];
            [self save];
            *stop = YES;
            return;
        }
        if (count == self.allAssets.count - 1) {
            NSLog(@"要添加Detail时：没有找到对应的assets");
        }
        count++;
    }];
    return detail;
}

- (void)moveDetail:(Detail*)detail toNewAssets:(NSString *)assetsName
{
    __block NSInteger count = 0;
    [self.allAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[obj name] isEqualToString:assetsName]) {
            if (detail.whichTangibleAssets) {
                [detail.whichTangibleAssets calculationBalanceWithSingleDetail:detail isAdd:NO];
            } else if (detail.whichIntangibleAssets) {
                [detail.whichIntangibleAssets calculationBalanceWithSingleDetail:detail isAdd:NO];
            }
            if ([obj isKindOfClass:[TangibleAssets class]]) {
                detail.whichTangibleAssets = obj;
            } else {
                detail.whichIntangibleAssets = obj;
            }
            [[obj dailys] addObject:detail];
            [obj calculationBalanceWithSingleDetail:detail isAdd:YES];
            [self save];
            *stop = YES;
            return;
        }
        if (count == self.allAssets.count - 1) {
            NSLog(@"移动时：没有找到对应的assets");
        }
        count++;
    }];
}

- (void)deleteDetail:(Detail *)detail
{
    if (detail.whichIntangibleAssets || detail.whichTangibleAssets) {
        if (detail.whichTangibleAssets) {
            [detail.whichTangibleAssets calculationBalanceWithSingleDetail:detail isAdd:NO];
            [detail.whichTangibleAssets removeDailysObject:detail];
        } else if (detail.whichIntangibleAssets) {
            [detail.whichIntangibleAssets calculationBalanceWithSingleDetail:detail isAdd:NO];
            [detail.whichIntangibleAssets removeDailysObject:detail];
        }
        [self.context deleteObject:detail];
        [self save];
    } else {
        NSLog(@"删除时：这个Detail并没有对应的Assets");
    }
}
#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"%@ %@ %zd %zd", controller, sectionInfo, sectionIndex, type);
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"%s", [[[NSString stringWithUTF8String:__FUNCTION__] substringToIndex:[NSString stringWithUTF8String:__FUNCTION__].length > 50 ? 50 : [NSString stringWithUTF8String:__FUNCTION__].length] UTF8String]);
    
    NSLog(@"%@ %@ %zd %@", controller, anObject, type, newIndexPath);
}

#pragma mark -
#pragma mark lazy load
- (NSManagedObjectContext *)context
{
    if (!_context) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _context = delegate.managedObjectContext;
    }
    return _context;
}

- (NSMutableSet *)allAssets
{
    NSMutableSet *allAssets = [NSMutableSet setWithSet:self.holder.tangibleAssets];
    if (!allAssets) {
        allAssets = [NSMutableSet set];
    }
    allAssets = [[allAssets setByAddingObjectsFromSet:self.holder.intangibleAssets] mutableCopy];
    return allAssets;
}

@end
