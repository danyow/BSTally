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

static NSString * const kTableViewCellReuseIdentifier = @"asljhflja";

@interface AssetController ()<UITableViewDataSource>

@property (nonatomic, strong) UIBriefLabel *balanceLabel;
@property (nonatomic, strong) UIBriefLabel *borrowBalanceLabel;

@property (nonatomic, strong) UIBriefLabel *lendBalanceLabel;
@property (nonatomic, strong) UIBriefLabel *quotaLabel;

@property (nonatomic, strong) UITableView *detailsTableView;

@property (nonatomic, strong) AssetsAccountant *accountant;
@property (nonatomic, strong) Assets *asset;

@end

@implementation AssetController


+ (instancetype)assetControllerWithAssetName:(NSString *)assetName
{
    AssetController *assetController = [[AssetController alloc] init];
    assetController.asset = [assetController.accountant queryAssetsObjectWithAssetsName:assetName];
    return assetController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDetailsTableView];
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
    if ([self.asset isKindOfClass:[IntangibleAssets class]]) {
        [self.view addSubview:self.quotaLabel];
        [self.quotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.borrowBalanceLabel.mas_bottom).offset(kMargin);
            make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
        }];
    } else {
        [self.view addSubview:self.lendBalanceLabel];
        [self.lendBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.borrowBalanceLabel.mas_bottom).offset(kMargin);
            make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, 0, kMargin * 2));
        }];
    }
    
    [self.view addSubview:self.detailsTableView];
    [self.detailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borrowBalanceLabel.mas_bottom).offset(kMargin + 50);
        make.leading.bottom.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin * 2, kMargin * 2, kMargin * 2));
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


- (void)setupDetailsTableView
{
    self.detailsTableView.dataSource = self;
//    [self.detailsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.asset.dailys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellReuseIdentifier];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSArray *array = [self.asset.dailys sortedArrayUsingDescriptors:@[sort]];
    cell.textLabel.text = [[array[indexPath.row] remarks] stringByAppendingString:[array[indexPath.row] amount].description];
    cell.detailTextLabel.text = [array[indexPath.row] date].description;
    return cell;
}


#pragma mark -
#pragma mark event method

- (void)rightButtonPressed:(UIButton *)sender
{
    AddDetailController *addDetailController = [AddDetailController addDetailControllerWithAssetsName:self.asset.name completeCallback:^{
        [self.detailsTableView reloadData];
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

- (UITableView *)detailsTableView
{
    if (!_detailsTableView) {
        _detailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _detailsTableView;
}

- (AssetsAccountant *)accountant
{
    if (!_accountant) {
        _accountant = [AssetsAccountant shareAccountant];
    }
    return _accountant;
}

@end
