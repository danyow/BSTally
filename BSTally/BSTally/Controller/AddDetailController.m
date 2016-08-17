//
//  AddDetailController.m
//  BSTally
//
//  Created by Danyow on 16/8/4.
//  Copyright © 2016年 Danyow.Ed. All rights reserved.
//

#import "AddDetailController.h"
#import "AssetsAccountant.h"
#import "PureColorButton.h"
#import "UISegmentView.h"
#import "DetailNumberPad.h"

@interface AddDetailController ()<UITextFieldDelegate, UISegmentViewDelegate>

@property (nonatomic, strong) UITextField *amountField;
@property (nonatomic, strong) UITextField *dateField;

@property (nonatomic, strong) AssetsAccountant *accountant;
@property (nonatomic, strong) Detail           *testDetail;
@property (nonatomic, strong) UISegmentView    *detailSegmentView;
@property (nonatomic, strong) PureColorButton  *completeButton;

@property (nonatomic, strong) NSString   *assetsName;
@property (nonatomic, assign) AssetsType assetsType;
@property (nonatomic, assign) DetailType detailType;
@property (nonatomic, strong) NSArray    *detailTitles;
@property (nonatomic, strong) NSArray    *detailTypesArray;
@property (nonatomic, copy) NSString *used;

@property (nonatomic, copy) void (^completeCallback)();

@end

@implementation AddDetailController

#pragma mark -
#pragma mark public method

+ (instancetype)addDetailControllerWithAssetsName:(NSString *)assetsName completeCallback:(void(^)())completeCallback
{
    AddDetailController *controller = [self new];
    controller.assetsName = assetsName;
    controller.completeCallback = completeCallback;
    return controller;
}

#pragma mark -
#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.amountField becomeFirstResponder];
    
}

- (void)viewWillAddSubview {
    [super viewWillAddSubview];
    [self.view setBackgroundColor:kColor_White];
    [self.view addSubview:self.amountField];
    [self.view addSubview:self.detailSegmentView];
    [self.view addSubview:self.completeButton];
    
    
    [self.amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(UIEdgeInsetsMake(kNavBarHeight, kMargin, 0, kMargin));
        make.height.equalTo(@kBarHeight);
    }];
    
    [self.detailSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountField.mas_bottom).offset(kMargin * 2);
        make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
        make.height.equalTo(@kBarHeight);
    }];
    
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailSegmentView.mas_bottom).offset(16);
        make.leading.trailing.mas_equalTo(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
        make.height.equalTo(@kBarHeight);
    }];

}

#pragma mark -
#pragma mark event handle

- (void)completeButtonPressed:(PureColorButton *)sender
{
    [self.accountant addDetailType:self.detailType amount:@([self.amountField.text doubleValue]) date:nil remarks:self.used tags:@[@1] toWhichAssets:self.assetsName];
    if (self.completeCallback) {
        self.completeCallback();
    }
    [self backButtonPressed:self.backButton];
} 

- (void)amountFieldTextChange:(UITextField *)sender
{
    // TODO: 如果光标移动到中间的话下面代码失效
    if (sender.text.length > 1) {
        if ([sender.text hasSuffix:@"."]) {
            NSString *subString = [sender.text substringToIndex:sender.text.length - 1];
            if ([subString containsString:@"."]) {
                sender.text = subString;
            }
        }
    }
    if (sender.text.length == 2) {
        if ([sender.text hasSuffix:@"0"]) {
            if ([sender.text hasPrefix:@"0"]) {
                sender.text = @"0";
            }
        }
    }
    
//    NSString *searchText = sender.text;
//    NSError *error = NULL;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([1-9][0-9]*([.]{0,1}[0-9]*){0,1})|([0]{0,1}([.][0-9]*){0,1})$" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//    if (result) {
//        sender.text = [searchText substringWithRange:result.range];
//    } else {
//        sender.text = self.beforeAmount;
//    }
//    self.beforeAmount = sender.text;
}

#pragma mark -
#pragma mark UISegmentViewDelegate

- (void)segmentView:(UISegmentView *)view didSelectedIndex:(NSInteger)index segmentTitle:(NSString *)string
{
    self.detailType = (DetailType)[self.detailTypesArray[index] integerValue];
    self.used = string;
}

- (void)setAssetsName:(NSString *)assetsName
{
    _assetsName = assetsName;
    
    self.assetsType = [self.accountant queryAssetsTypeWithAssetsName:assetsName];
    if (self.assetsType < AssetsTypeIOU) {
        self.detailTitles = @[@"支出", @"收入", @"借出", @"收还", @"赊账", @"补账",];
        self.detailTypesArray = @[@(DetailTypeExpend),
                                  @(DetailTypeIncome),
                                  @(DetailTypeLend),
                                  @(DetailTypePayLend),
                                  @(DetailTypeBorrow),
                                  @(DetailTypePayBorrow),];
    } else {
        self.detailTitles = @[@"刷得", @"预支", @"已还",];
        self.detailTypesArray = @[@(DetailTypeBorrow),
                                  @(DetailTypeBorrowExpend),
                                  @(DetailTypePayBorrow)];
    }
    
    self.used = [self.detailTitles firstObject];
    
    NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:self.detailTitles.count];
    [self.detailTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dictArray addObject:@{kUISegmentViewLabelText: obj}];
    }];
    [self.detailSegmentView setButtonsWithDictArray:dictArray];
}

#pragma mark -
#pragma mark lazy load
- (AssetsAccountant *)accountant
{
    if (!_accountant) {
        _accountant = [AssetsAccountant shareAccountant];
    }
    return _accountant;
}

- (UITextField *)amountField
{
    if (!_amountField) {
        _amountField = [[UITextField alloc] init];
        [_amountField addTarget:self action:@selector(amountFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        _amountField.borderStyle = UITextBorderStyleRoundedRect;
        _amountField.backgroundColor = kColor_White;
        _amountField.placeholder = @"请输入金额";
        __weak typeof(self) weakSelf = self;
        [DetailNumberPad numberPadWithInputField:_amountField completeCallback:^(NSInteger number) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _amountField;
}

- (UITextField *)dateField
{
    if (!_dateField) {
        _dateField = [[UITextField alloc] init];
        [_dateField addTarget:self action:@selector(amountFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        _dateField.borderStyle = UITextBorderStyleRoundedRect;
        _dateField.keyboardType = UIKeyboardTypeDecimalPad;
        _dateField.backgroundColor = kColor_White;
        _dateField.placeholder = @"请输入日期";
    }
    return _dateField;
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

- (UISegmentView *)detailSegmentView
{
    if (!_detailSegmentView) {
        _detailSegmentView = [[UISegmentView alloc] init];
        _detailSegmentView.delegate = self;
        _detailSegmentView.tintColor = kColor_Theme;
    }
    return _detailSegmentView;
}

@end