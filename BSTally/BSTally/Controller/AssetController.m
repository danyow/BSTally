//
//  AssetController.m
//  BSTally
//
//  Created by Danyow on 16/8/14.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "AssetController.h"
#import "UIBriefLabel.h"
#import "AssetsAccountant.h"
#import "Assets.h"
#import "AddDetailController.h"
#import "ControlCenter.h"

static NSString * const kTableViewCellReuseIdentifier = @"asljhflja";

@interface AssetController ()<MeshCollectionViewFlowLayoutDataSource>

@property (nonatomic, strong) UIBriefLabel *balanceLabel;
@property (nonatomic, strong) UIBriefLabel *borrowBalanceLabel;

@property (nonatomic, strong) UIBriefLabel *lendBalanceLabel;
@property (nonatomic, strong) UIBriefLabel *quotaLabel;

@property (nonatomic, strong) UICollectionView *detailsCollectionView;

@property (nonatomic, strong) AssetsAccountant *accountant;
@property (nonatomic, strong) Assets *asset;

@end

@implementation AssetController

+ (instancetype)assetControllerWithAssetName:(NSString *)assetName
{
    AssetController *assetController = [[AssetController alloc] init];
    assetController.titleLabel.text  = assetName;
    assetController.asset = [assetController.accountant queryAssetsObjectWithAssetsName:assetName];
    return assetController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.detailsCollectionView registerClass:[MeshCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
}

- (void)viewWillAddSubview
{
    [super viewWillAddSubview];
    
    [self.view addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kNavBarHeight + kMargin));
        make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
    }];
    [self.view addSubview:self.borrowBalanceLabel];
    [self.borrowBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(kMargin);
        make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
    }];
    
    UILabel *lastLabel = nil;
    if ([self.asset isKindOfClass:[IntangibleAssets class]]) {
        [self.view addSubview:self.quotaLabel];
        [self.quotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.borrowBalanceLabel.mas_bottom).offset(kMargin);
            make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
        }];
        lastLabel = self.quotaLabel;
    } else {
        [self.view addSubview:self.lendBalanceLabel];
        [self.lendBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.borrowBalanceLabel.mas_bottom).offset(kMargin);
            make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
        }];
        lastLabel = self.lendBalanceLabel;
    }
    
    [self.view addSubview:self.detailsCollectionView];
    [self.detailsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLabel.mas_bottom).offset(kMargin);
        make.leading.bottom.trailing.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark -
#pragma mark private method 

- (void)preparatoryWorkBriefLabel:(UIBriefLabel *)briefLabel briefString:(NSString *)briedString
{
    briefLabel.font = kFont_Size(18);
    briefLabel.text = @"---";
    briefLabel.textColor = kColor_Black;
    briefLabel.briefFont = kFont_Size(18);
    briefLabel.briefText = briedString;
    briefLabel.briefColor = kColor_Black;
}

#pragma mark -
#pragma mark MeshCollectionViewFlowLayoutDataSource

- (NSArray<NSNumber *> *)columnWidthArrayOfMeshCollectionViewFlowLayout:(MeshCollectionViewFlowLayout *)meshCollectionViewFlowLayout
{
    return @[@6, @4, @3, @3];
}


- (NSArray<NSNumber *> *)rowHeightArrayOfMeshCollectionViewFlowLayout:(MeshCollectionViewFlowLayout *)meshCollectionViewFlowLayout
{
    NSInteger count = self.asset.dailys.count;
    NSMutableArray *rowHeightArray = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count + 1; ++i) {
        [rowHeightArray addObject:@35];
    }
    return rowHeightArray;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtRow:(NSInteger)row column:(NSInteger)column indexPath:(NSIndexPath *)indexPath
{
    MeshCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    cell.layer.borderColor = kColor_Black.CGColor;
    cell.layer.borderWidth = 0.5;
    cell.label.textColor   = kColor_Black;
    
    NSArray *cellArray;
    if (!row) {
        cellArray = @[@"日期", @"金额", @"全部", @"备注"];
    } else {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSArray *array = [self.asset.dailys sortedArrayUsingDescriptors:@[sort]];
        Detail *detail = array[row - 1];
        
        
        NSString *date = [detail.date substringToIndex:[detail.date rangeOfString:@" "].location];
        cellArray = @[date, detail.amount.description, detail.remarks, @""];
    }
    cell.label.text = cellArray[column];
    return cell;
}


#pragma mark -
#pragma mark event method

- (void)rightButtonPressed:(UIButton *)sender
{
    AddDetailController *addDetailController = [AddDetailController addDetailControllerWithAssetsName:self.asset.name completeCallback:^{
        [self.detailsCollectionView reloadData];
        self.asset = [self.accountant queryAssetsObjectWithAssetsName:self.asset.name];
    }];
    [self presentViewController:addDetailController animated:YES completion:nil];
}

#pragma mark -
#pragma mark setter

- (void)setAsset:(Assets *)asset
{
    _asset = asset;
    self.balanceLabel.text = asset.balance.description;
    self.borrowBalanceLabel.text = asset.borrowBalance.description;
    if ([asset isKindOfClass:[TangibleAssets class]]) {
        TangibleAssets *tangible = (TangibleAssets *)asset;
        self.lendBalanceLabel.text = tangible.lendBalance.description;
    } else {
        IntangibleAssets *intangible = (IntangibleAssets *)asset;
        self.quotaLabel.text = intangible.quota.description;
    }
}

#pragma mark -
#pragma mark lazy load

- (UIBriefLabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_balanceLabel briefString:@"余额："];
    }
    return _balanceLabel;
}

- (UIBriefLabel *)borrowBalanceLabel
{
    if (!_borrowBalanceLabel) {
        _borrowBalanceLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_borrowBalanceLabel briefString:@"欠额："];
    }
    return _borrowBalanceLabel;
}

- (UIBriefLabel *)lendBalanceLabel
{
    if (!_lendBalanceLabel) {
        _lendBalanceLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_lendBalanceLabel briefString:@"借额："];
    }
    return _lendBalanceLabel;
}

- (UIBriefLabel *)quotaLabel
{
    if (!_quotaLabel) {
        _quotaLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_quotaLabel briefString:@"额度："];
    }
    return _quotaLabel;
}

- (UICollectionView *)detailsCollectionView
{
    if (!_detailsCollectionView) {
        _detailsCollectionView = [MeshCollectionViewFlowLayout meshCollectionViewWithDataSource:self FlexibleWidth:NO flexibleHeight:YES];
    }
    return _detailsCollectionView;
}

- (AssetsAccountant *)accountant
{
    if (!_accountant) {
        _accountant = [AssetsAccountant shareAccountant];
    }
    return _accountant;
}

@end
