//
//  AddAssetsController.m
//  BSTally
//
//  Created by Danyow on 16/8/13.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "AddAssetsController.h"
#import "PureColorButton.h"
#import "UISegmentView.h"
#import "AssetsAccountant.h"

@interface AddAssetsController ()<UISegmentViewDelegate>

@property (nonatomic, strong) UISegmentView   *assetTypeSegmentView;
@property (nonatomic, strong) UITextField     *assetNameField;
@property (nonatomic, strong) UITextField     *balanceField;
@property (nonatomic, strong) UITextField     *borrowBalanceField;
@property (nonatomic, strong) UITextField     *anotherField;
@property (nonatomic, strong) PureColorButton *completeButton;

@property (nonatomic, copy) void (^completeCallback)();

@property (nonatomic, strong) AssetsAccountant *accountant;

@end

@implementation AddAssetsController

#pragma mark -
#pragma mark public method

+ (instancetype)addAssetsControllerWithCompleteCallback:(void(^)())completeCallback
{
    AddAssetsController *addAssetsController = [self new];
    addAssetsController.completeCallback = completeCallback;
    return addAssetsController;
}

- (void)viewWillAddSubview
{
    self.rightButton.hidden = YES;
    [super viewWillAddSubview];
    
    [self.view addSubview:self.assetTypeSegmentView];
    [self.assetTypeSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight + kMargin, kMargin, 0, kMargin));
        make.height.equalTo(@kBarHeight);
    }];
    
    [self.view addSubview:self.assetNameField];
    [self.assetNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.assetTypeSegmentView.mas_bottom).offset(kMargin);
        make.left.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
    }];
    
    [self.view addSubview:self.balanceField];
    [self.balanceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.assetNameField.mas_bottom).offset(kMargin);
        make.left.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
    }];
    
    [self.view addSubview:self.borrowBalanceField];
    [self.borrowBalanceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceField.mas_bottom).offset(kMargin);
        make.left.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
    }];
    
    [self.view addSubview:self.anotherField];
    [self.anotherField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borrowBalanceField.mas_bottom).offset(kMargin);
        make.left.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
    }];
    
    [self.view addSubview:self.completeButton];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.anotherField.mas_bottom).offset(kMargin);
        make.left.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
        make.height.equalTo(@kBarHeight);
    }];
}

- (void)completeButtonPressed:(UIButton *)sender
{
    AssetsType type = AssetsTypeCash;
    switch (self.assetTypeSegmentView.selectedIndex) {
        case 0: type = AssetsTypeCash;        break;
        case 1: type = AssetsTypeYueBao;      break;
        case 2: type = AssetsTypeChange;      break;
        case 3: type = AssetsTypeDebitCard;   break;
        case 4: type = AssetsTypeIOU;         break;
        case 5: type = AssetsTypeGoldBar;     break;
        case 6: type = AssetsTypeHuaBei;      break;
        case 7: type = AssetsTypeJieBei;      break;
        case 8: type = AssetsTypeCreditCards; break;
    }
    
    [self.accountant creatNewAssetsName:self.assetNameField.text assetsType:type];
    
    if (type < AssetsTypeIOU) {
        [self.accountant tangibleAssetName:self.assetNameField.text resetBalance:[self numberFromString:self.balanceField.text] borrowBalance:[self numberFromString:self.borrowBalanceField.text] lendBalance:[self numberFromString:self.anotherField.text]];
    } else {
        [self.accountant intangibleAssetName:self.assetNameField.text resetQuota:[self numberFromString:self.anotherField.text] balance:[self numberFromString:self.balanceField.text] borrowBalance:[self numberFromString:self.borrowBalanceField.text]];
    }
    
    if (self.completeCallback) {
        self.completeCallback();
    }
    
    [self backButtonPressed:self.backButton];
}

- (NSNumber *)numberFromString:(NSString *)string
{
    return @(string.doubleValue);
}


#pragma mark -
#pragma mark UISegmentViewDelegate
- (void)segmentView:(UISegmentView *)view didSelectedIndex:(NSInteger)index segmentTitle:(NSString *)string
{
    if (index < 3) {
        self.anotherField.placeholder = @"请输入借额";
    } else {
        self.anotherField.placeholder = @"请输入额度";
    }
}


#pragma mark -
#pragma mark lazy load

- (UITextField *)assetNameField
{
    if (!_assetNameField) {
        _assetNameField = [[UITextField alloc] init];
        _assetNameField.borderStyle = UITextBorderStyleRoundedRect;
        _assetNameField.placeholder = @"请输入名称";
    }
    return _assetNameField;
}

- (UITextField *)balanceField
{
    if (!_balanceField) {
        _balanceField = [[UITextField alloc] init];
        _balanceField.borderStyle = UITextBorderStyleRoundedRect;
        _balanceField.placeholder = @"请输入余额";
        _balanceField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _balanceField;
}

- (UITextField *)borrowBalanceField
{
    if (!_borrowBalanceField) {
        _borrowBalanceField = [[UITextField alloc] init];
        _borrowBalanceField.borderStyle = UITextBorderStyleRoundedRect;
        _borrowBalanceField.placeholder = @"请输入欠额";
        _borrowBalanceField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _borrowBalanceField;
}

- (UITextField *)anotherField
{
    if (!_anotherField) {
        _anotherField = [[UITextField alloc] init];
        _anotherField.borderStyle = UITextBorderStyleRoundedRect;
        _anotherField.placeholder = @"请输入借额";
        _anotherField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _anotherField;
}

- (PureColorButton *)completeButton
{
    if (!_completeButton) {
        _completeButton = [[PureColorButton alloc] init];
        [_completeButton setTitle:@"OK" forState:UIControlStateNormal];
        [_completeButton setNormalColor:kColor_Theme];
        [_completeButton setDisableColor:kColor_Alpha(kColor_Theme, 0.5)];
        [_completeButton addTarget:self action:@selector(completeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

- (UISegmentView *)assetTypeSegmentView
{
    if (!_assetTypeSegmentView) {
        _assetTypeSegmentView = [[UISegmentView alloc] init];
        [self.accountant creatNewAssetsName:@"平安信用" assetsType:AssetsTypeCreditCards];
        _assetTypeSegmentView.tintColor = kColor_Theme;
        [_assetTypeSegmentView setButtonsWithDictArray:@[@{kUISegmentViewLabelText : @"钱包"},
                                                         @{kUISegmentViewLabelText : @"支宝"},
                                                         @{kUISegmentViewLabelText : @"微信"},
                                                         @{kUISegmentViewLabelText : @"储蓄"},
                                                         @{kUISegmentViewLabelText : @"白条"},
                                                         @{kUISegmentViewLabelText : @"金条"},
                                                         @{kUISegmentViewLabelText : @"花呗"},
                                                         @{kUISegmentViewLabelText : @"借呗"},
                                                         @{kUISegmentViewLabelText : @"信用"},]];
        _assetTypeSegmentView.delegate = self;
    }
    return _assetTypeSegmentView;
}

- (AssetsAccountant *)accountant
{
    if (!_accountant) {
        _accountant = [AssetsAccountant shareAccountant];
    }
    return _accountant;
}

@end
