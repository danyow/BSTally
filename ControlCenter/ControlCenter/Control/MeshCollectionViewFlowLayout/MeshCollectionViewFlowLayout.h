//
//  MeshCollectionViewFlowLayout.h
//  MeshCollectionView
//
//  Created by junhong.zhu@lachesis-mh.com on 16/8/19.
//  Copyright © 2016年 联新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeshCollectionViewFlowLayout;

@protocol MeshCollectionViewFlowLayoutDataSource <NSObject>

- (NSArray <NSNumber *>*)rowHeightArrayOfMeshCollectionViewFlowLayout:(MeshCollectionViewFlowLayout *)meshCollectionViewFlowLayout;
- (NSArray <NSNumber *>*)columnWidthArrayOfMeshCollectionViewFlowLayout:(MeshCollectionViewFlowLayout *)meshCollectionViewFlowLayout;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtRow:(NSInteger)row column:(NSInteger)column indexPath:(NSIndexPath *)indexPath;
@optional
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView cellEdgeInsetsForItemAtRow:(NSInteger)row column:(NSInteger)column indexPath:(NSIndexPath *)indexPath;

@end

@protocol MeshCollectionViewFlowLayoutDelegate <NSObject>

@optional
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtRow:(NSInteger)row column:(NSInteger)column indexPath:(NSIndexPath *)indexPath;

@end









IB_DESIGNABLE
@interface MeshCollectionViewFlowLayout : UICollectionViewFlowLayout<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet id<MeshCollectionViewFlowLayoutDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<MeshCollectionViewFlowLayoutDelegate> delegate;
@property (nonatomic, assign, readonly) IBInspectable BOOL flexibleWidth;
@property (nonatomic, assign, readonly) IBInspectable BOOL flexibleHeight;

+ (UICollectionView *)meshCollectionViewWithDataSource:(id <MeshCollectionViewFlowLayoutDataSource>)dataSource FlexibleWidth:(BOOL)flexibleWidth flexibleHeight:(BOOL)flexibleHeight;

+ (instancetype)flowLayoutWithFlexibleWidth:(BOOL)flexibleWidth flexibleHeight:(BOOL)flexibleHeight;


@end
