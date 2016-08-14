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

@interface AssetController ()

//[self.accountant intangibleAssetName:@"京东白条" resetQuota:@(6152)  balance:@(4.06)    borrowBalance:@(6147.94)];
//[self.accountant tangibleAssetName:@"工商储蓄" resetBalance:@(0.7)    borrowBalance:@(0) lendBalance:@(0)];
@property (nonatomic, strong) UIBriefLabel *balanceLabel;
@property (nonatomic, strong) UIBriefLabel *borrowBalanceLabel;

@property (nonatomic, strong) UIBriefLabel *lendBalanceLabel;
@property (nonatomic, strong) UIBriefLabel *quotaLabel;

@property (nonatomic, strong) AssetsAccountant *accountant;

@property (nonatomic, assign) BOOL isTangible;

@property (nonatomic, strong) TangibleAssets *tangibleAssets;
@property (nonatomic, strong) IntangibleAssets *intangibleAssets;

@end

@implementation AssetController


+ (instancetype)assetControllerWithAssetName:(NSString *)assetName
{
    AssetController *assetController = [[AssetController alloc] init];
    
    AssetsType assetsType = [assetController.accountant queryAssetsTypeWithAssetsName:assetName];
    id asset = [assetController.accountant queryAssetsObjectWithAssetsName:assetName];
    if (assetsType < AssetsTypeIOU) {
        assetController.isTangible = YES;
        assetController.tangibleAssets = asset;
    } else {
        assetController.isTangible = NO;
        assetController.intangibleAssets = asset;
    }
    return assetController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self.view addSubview:self.lendBalanceLabel];
    [self.lendBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borrowBalanceLabel.mas_bottom).offset(kMargin);
        make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
    }];
    
    [self.view addSubview:self.quotaLabel];
    [self.quotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lendBalanceLabel.mas_bottom).offset(kMargin);
        make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
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
#pragma mark lazy load

- (UIBriefLabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_balanceLabel briefString:@"余额"];
    }
    return _balanceLabel;
}

- (UIBriefLabel *)borrowBalanceLabel
{
    if (!_borrowBalanceLabel) {
        _borrowBalanceLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_borrowBalanceLabel briefString:@"欠额"];
    }
    return _borrowBalanceLabel;
}

- (UIBriefLabel *)lendBalanceLabel
{
    if (!_lendBalanceLabel) {
        _lendBalanceLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_lendBalanceLabel briefString:@"借额"];
    }
    return _lendBalanceLabel;
}

- (UIBriefLabel *)quotaLabel
{
    if (!_quotaLabel) {
        _quotaLabel = [[UIBriefLabel alloc] init];
        [self preparatoryWorkBriefLabel:_quotaLabel briefString:@"额度"];
    }
    return _quotaLabel;
}

@end
