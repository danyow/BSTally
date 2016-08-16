//
//  HomeViewController.m
//  BSTally
//
//  Created by Danyow on 16/8/7.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "HomeViewController.h"
#import "AddDetailController.h"
#import "AssetsAccountant.h"
#import "PureColorButton.h"
#import "ControlDefine.h"
#import "Masonry.h"
#import "AddAssetsController.h"
#import "AssetController.h"


static NSString * const kTableViewCellReuseIdentifier = @"askfjhkal";


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bottomBarContainer;
@property (nonatomic, strong) PureColorButton *addDetailButton;
@property (nonatomic, strong) AssetsAccountant *accountant;

@property (nonatomic, strong) NSArray     *assetsNameArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideTabBar];
    [self loadAssets];
}

#pragma mark -
#pragma mark private method

- (void)hideTabBar
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAddSubview
{
    [super viewWillAddSubview];
    self.view.backgroundColor = kColor_White;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0));
    }];
}




- (void)loadAssets
{
    [self.accountant creatNewAssetsName:@"钱包现金" assetsType:AssetsTypeCash];
    [self.accountant creatNewAssetsName:@"支付余额" assetsType:AssetsTypeYueBao];
    [self.accountant creatNewAssetsName:@"微信零钱" assetsType:AssetsTypeChange];
    [self.accountant creatNewAssetsName:@"中信储蓄" assetsType:AssetsTypeDebitCard];
    [self.accountant creatNewAssetsName:@"工商储蓄" assetsType:AssetsTypeDebitCard];
    [self.accountant creatNewAssetsName:@"京东白条" assetsType:AssetsTypeIOU];
    [self.accountant creatNewAssetsName:@"京东金条" assetsType:AssetsTypeGoldBar];
    [self.accountant creatNewAssetsName:@"蚂蚁花呗" assetsType:AssetsTypeHuaBei];
    [self.accountant creatNewAssetsName:@"蚂蚁借呗" assetsType:AssetsTypeJieBei];
    [self.accountant creatNewAssetsName:@"中信信用" assetsType:AssetsTypeCreditCards];
    [self.accountant creatNewAssetsName:@"招商信用" assetsType:AssetsTypeCreditCards];
    [self.accountant creatNewAssetsName:@"交通信用" assetsType:AssetsTypeCreditCards];
    [self.accountant creatNewAssetsName:@"平安信用" assetsType:AssetsTypeCreditCards];
    
    [self.accountant tangibleAssetName:@"钱包现金" resetBalance:@(30)     borrowBalance:@(0) lendBalance:@(3000)];
    [self.accountant tangibleAssetName:@"支付余额" resetBalance:@(731.66) borrowBalance:@(0) lendBalance:@(0)];
    [self.accountant tangibleAssetName:@"微信零钱" resetBalance:@(15.34)  borrowBalance:@(0) lendBalance:@(0)];
    [self.accountant tangibleAssetName:@"中信储蓄" resetBalance:@(8.27)   borrowBalance:@(0) lendBalance:@(0)];
    [self.accountant tangibleAssetName:@"工商储蓄" resetBalance:@(0.7)    borrowBalance:@(0) lendBalance:@(0)];
    
    [self.accountant intangibleAssetName:@"京东白条" resetQuota:@(6152)  balance:@(4.06)    borrowBalance:@(6147.94)];
    [self.accountant intangibleAssetName:@"京东金条" resetQuota:@(9000)  balance:@(7500)    borrowBalance:@(1500)];
    [self.accountant intangibleAssetName:@"蚂蚁花呗" resetQuota:@(3000)  balance:@(2238.05) borrowBalance:@(761.95)];
    [self.accountant intangibleAssetName:@"蚂蚁借呗" resetQuota:@(5000)  balance:@(5000)    borrowBalance:@(0)];
    [self.accountant intangibleAssetName:@"中信信用" resetQuota:@(8000)  balance:@(162)     borrowBalance:@(7883)];
    [self.accountant intangibleAssetName:@"招商信用" resetQuota:@(14000) balance:@(4270.31) borrowBalance:@(9729.69)];
    [self.accountant intangibleAssetName:@"交通信用" resetQuota:@(2000)  balance:@(1920.5)  borrowBalance:@(79.5)];
    [self.accountant intangibleAssetName:@"平安信用" resetQuota:@(20000) balance:@(20000)   borrowBalance:@(0)];
    self.assetsNameArray = @[@"钱包现金", @"支付余额", @"微信零钱", @"中信储蓄", @"工商储蓄", @"京东白条", @"京东金条", @"蚂蚁花呗", @"蚂蚁借呗", @"中信信用", @"招商信用", @"交通信用", @"平安信用"];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier];
    cell.textLabel.text = self.assetsNameArray[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetController *assetController = [AssetController assetControllerWithAssetName:self.assetsNameArray[indexPath.row]];
    [self.navigationController pushViewController:assetController animated:YES];
}

#pragma mark -
#pragma mark event handle

- (void)rightButtonPressed:(UIButton *)sender
{
    AddAssetsController *addAssetsController = [[AddAssetsController alloc] init];
    [self presentViewController:addAssetsController animated:YES completion:nil];
}


#pragma mark -
#pragma mark lazy load

- (UIView *)bottomBarContainer
{
    if (!_bottomBarContainer) {
        _bottomBarContainer = [[UIView alloc] init];
    }
    return _bottomBarContainer;
}

- (PureColorButton *)addDetailButton
{
    if (!_addDetailButton) {
        _addDetailButton = [[PureColorButton alloc] init];
        UIColor *randomColor = kColor_Random;
        _addDetailButton.normalColor    = kColor_Alpha(randomColor, 0.5);
        _addDetailButton.selectedColor  = randomColor;
        _addDetailButton.highlightColor = randomColor;
        [_addDetailButton setTitle:@"记账" forState:UIControlStateNormal];
//        [_addDetailButton addTarget:self action:@selector(addDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addDetailButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (AssetsAccountant *)accountant
{
    if (!_accountant) {
        _accountant = [AssetsAccountant shareAccountant];
    }
    return _accountant;
}

@end
