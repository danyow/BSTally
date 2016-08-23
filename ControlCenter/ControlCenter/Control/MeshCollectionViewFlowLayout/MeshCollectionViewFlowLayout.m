//
//  MeshCollectionViewFlowLayout.m
//  MeshCollectionView
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/19.
//  Copyright © 2016年 联新. All rights reserved.
//

#import "MeshCollectionViewFlowLayout.h"

@interface MeshCollectionViewFlowLayout ()

@property (nonatomic, assign) IBInspectable BOOL flexibleWidth;
@property (nonatomic, assign) IBInspectable BOOL flexibleHeight;

@property (nonatomic, strong) NSMutableArray *attributes;

@property (nonatomic, strong) NSArray <NSNumber*>*columnWidthArray;
@property (nonatomic, strong) NSArray <NSNumber*>*rowHeightArray;
@property (nonatomic, assign) CGFloat sumColumnWidth;
@property (nonatomic, assign) CGFloat sumRowHeight;
@end

@implementation MeshCollectionViewFlowLayout

+ (UICollectionView *)meshCollectionViewWithDataSource:(id <MeshCollectionViewFlowLayoutDataSource>)dataSource FlexibleWidth:(BOOL)flexibleWidth flexibleHeight:(BOOL)flexibleHeight
{
    MeshCollectionViewFlowLayout *flowLayout = [MeshCollectionViewFlowLayout flowLayoutWithFlexibleWidth:flexibleWidth flexibleHeight:flexibleHeight];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.dataSource = flowLayout;
    collectionView.delegate   = flowLayout;
    flowLayout.dataSource = dataSource;
    return collectionView;
}

+ (instancetype)flowLayoutWithFlexibleWidth:(BOOL)flexibleWidth flexibleHeight:(BOOL)flexibleHeight
{
    MeshCollectionViewFlowLayout *flowLayout = [[MeshCollectionViewFlowLayout alloc] init];
    flowLayout.flexibleWidth           = flexibleWidth;
    flowLayout.flexibleHeight          = flexibleHeight;
    flowLayout.minimumLineSpacing      = 0;
    flowLayout.minimumInteritemSpacing = 0;
    return flowLayout;
}

- (void)prepareLayout
{
    [self.attributes removeAllObjects];
    [super prepareLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    CGFloat collectionViewWidth  = self.collectionView.frame.size.width;
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    __block CGRect preRow  = CGRectZero;
    __block CGFloat y      = 0;
    __block CGFloat height = 0;
    [self.rowHeightArray enumerateObjectsUsingBlock:^(NSNumber *heightNumber, NSUInteger row, BOOL *stop) {
        y      = CGRectGetMaxY(preRow);
        height = heightNumber.doubleValue / (self.flexibleHeight ? : self.sumRowHeight / collectionViewHeight);
        __block CGRect preColumn = CGRectZero;
        __block CGFloat x        = 0;
        __block CGFloat width    = 0;
        [self.columnWidthArray enumerateObjectsUsingBlock:^(NSNumber *widthNumber, NSUInteger column, BOOL *stop) {
            x     = CGRectGetMaxX(preColumn);
            width = widthNumber.doubleValue / (self.flexibleWidth ? : self.sumColumnWidth / collectionViewWidth);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row * self.columnWidthArray.count + column inSection:0];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
            if ([self.dataSource respondsToSelector:@selector(collectionView:cellEdgeInsetsForItemAtRow:column:indexPath:)]) {
                edgeInsets = [self.dataSource collectionView:self.collectionView cellEdgeInsetsForItemAtRow:row column:column indexPath:indexPath];
            }
            
            CGFloat top    = edgeInsets.top / (self.flexibleHeight ? : self.sumRowHeight / collectionViewHeight);
            CGFloat left   = edgeInsets.left / (self.flexibleWidth ? : self.sumColumnWidth / collectionViewWidth);
            CGFloat right  = edgeInsets.right / (self.flexibleWidth ? : self.sumColumnWidth / collectionViewWidth);
            CGFloat bottom = edgeInsets.bottom / (self.flexibleHeight ? : self.sumRowHeight / collectionViewHeight);
            
            
            CGRect frame = CGRectMake(x, y, width, height);
            frame.origin.x    -= left;
            frame.origin.y    -= top;
            frame.size.width  += (left + right);
            frame.size.height += (top + bottom);
            
            attributes.frame = frame;
            [self.attributes addObject:attributes];
            preColumn = CGRectMake(x, 0, width, 0);
        }];
        preRow = CGRectMake(0, y, 0, height);
    }];
}


- (CGSize)collectionViewContentSize
{
    [super collectionViewContentSize];
    if (!self.flexibleWidth && !self.flexibleHeight) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
    if (!self.flexibleWidth && self.flexibleHeight) {
        return CGSizeMake(self.collectionView.frame.size.width, self.sumRowHeight);
    }
    if (self.flexibleWidth && !self.flexibleHeight) {
        return CGSizeMake(self.sumColumnWidth, self.collectionView.frame.size.height);
    }
    if (self.flexibleWidth && self.flexibleHeight) {
        return CGSizeMake(self.sumColumnWidth, self.sumRowHeight);
    }
    return CGSizeZero;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributes;
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(rowHeightArrayOfMeshCollectionViewFlowLayout:)]) {
        self.rowHeightArray = [self.dataSource rowHeightArrayOfMeshCollectionViewFlowLayout:self];
        self.sumRowHeight   = [[self.rowHeightArray valueForKeyPath:@"@sum.doubleValue"] doubleValue];
    }
    if ([self.dataSource respondsToSelector:@selector(columnWidthArrayOfMeshCollectionViewFlowLayout:)]) {
        self.columnWidthArray = [self.dataSource columnWidthArrayOfMeshCollectionViewFlowLayout:self];
        self.sumColumnWidth   = [[self.columnWidthArray valueForKeyPath:@"@sum.doubleValue"] doubleValue];
    }
    return self.rowHeightArray.count * self.columnWidthArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.item / self.columnWidthArray.count;
    NSInteger column = indexPath.item % self.columnWidthArray.count;
    UICollectionViewCell *cell;
    if ([self.dataSource respondsToSelector:@selector(collectionView:cellForItemAtRow:column:indexPath:)]) {
        cell = [self.dataSource collectionView:collectionView cellForItemAtRow:row column:column indexPath:indexPath];
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    cell.selectedBackgroundView = view;
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = indexPath.item / self.columnWidthArray.count;
//    [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath *index = [collectionView indexPathForCell:obj];
//        if (row == index.item / self.columnWidthArray.count) {
//            obj.selected = YES;
//        }
//    }];
//    return YES;
//}

//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = indexPath.item / self.columnWidthArray.count;
//    [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath *index = [collectionView indexPathForCell:obj];
//        if (row == index.item / self.columnWidthArray.count) {
//            obj.selected = YES;
//        }
//    }];
//    NSLog(@"%s", __FUNCTION__);
//}

//- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row = indexPath.item / self.columnWidthArray.count;
//    [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath *index = [collectionView indexPathForCell:obj];
//        if (row == index.item / self.columnWidthArray.count) {
//            obj.selected = NO;
//        }
//    }];
//    NSLog(@"%s", __FUNCTION__);
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.item / self.columnWidthArray.count;
    NSInteger column = indexPath.item % self.columnWidthArray.count;
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtRow:column:indexPath:)]) {
        [self.delegate collectionView:collectionView didSelectItemAtRow:row column:column indexPath:indexPath];
    }
}

#pragma mark -
#pragma mark lazy load

- (NSMutableArray *)attributes
{
    if (!_attributes) {
        _attributes = [[NSMutableArray alloc] initWithCapacity:self.rowHeightArray.count * self.columnWidthArray.count];
    }
    return _attributes;
}

@end
