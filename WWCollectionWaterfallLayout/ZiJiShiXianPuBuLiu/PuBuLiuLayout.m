//
//  PuBuLiuLayout.m
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//

#import "PuBuLiuLayout.h"

#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

@implementation PuBuLiuLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
}


- (instancetype)init
{
    if(self = [super init]) {
        _columns = 1;
        _columnSpacing = 10;
        _columnSpacing = 10;
        _insets = UIEdgeInsetsZero;
    }
    return self;
}
/**
 一旦UICollectionView需要刷新（放到屏幕上或需要reloadData）或者被标记为需要重新计算布局（调用了layout对象的invalidateLayout方法）时，UICollectionView就会向布局对象请求一系列的方法：

 首先会调用prepareLayout方法，在此方法中尽可能将后续布局时需要用到的前置计算处理好，每次重新布局都是从此方法开始。
 调用collectionViewContentSize方法，根据第一点中的计算来返回所有内容的滚动区域大小，。
 调用layoutAttributesForElementsInRect:方法，计算rect内相应的布局，并返回一个装有UICollectionViewLayoutAttributes的数组，Attributes 跟所有Item一一对应，UICollectionView就是根据这个Attributes来对Item进行布局，并当新的Rect区域滚动进入屏幕时再次请求此方法。
 */
- (void)prepareLayout
{
    [super prepareLayout];

//    _headerHeight = 150;
    //初始化数组
    self.columnHeights = [NSMutableArray array];
    for(NSInteger column=0; column<_columns; column++){
        self.columnHeights[column] = @(0);
    }
    self.attributesArray = [NSMutableArray array];
    NSInteger numSections = [self.collectionView numberOfSections];
    for(NSInteger section=0; section<numSections; section++){
        NSInteger numItems = [self.collectionView numberOfItemsInSection:0];
        for(NSInteger item=0; item<numItems; item++){
            //遍历每一项
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            //计算LayoutAttributes
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];

            [self.attributesArray addObject:attributes];
        }
    }
}
- (CGSize)collectionViewContentSize
{
    NSInteger mostColumn = [self columnOfMostHeight];
    //所有列当中最大的高度
    CGFloat mostHeight = [self.columnHeights[mostColumn] floatValue];
    return CGSizeMake(self.collectionView.bounds.size.width, mostHeight+self.insets.top+self.insets.bottom);
}


//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributesArray = self.attributesArray;
    NSArray<NSIndexPath *> *indexPaths;
    //1、计算rect中出现的items
    indexPaths = [self indexPathForItemsInRect:rect];
    for(NSIndexPath *indexPath in indexPaths){
        //计算对应的LayoutAttributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributesArray addObject:attributes];
    }
    
    //2、计算rect中出现的SupplementaryViews
    //这里只计算了kSupplementaryViewKindHeader
    indexPaths = [self indexPathForSupplementaryViewsOfKind:Collection_header_define InRect:rect];
    for(NSIndexPath *indexPath in indexPaths){
        //计算对应的LayoutAttributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:Collection_header_define atIndexPath:indexPath];
        [attributesArray addObject:attributes];
    }
    return attributesArray;

}
//计算所有的cell的高度 返回cell的LayoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //外部返回Item高度
    CGFloat itemHeight = [self.delegate collectionViewLayout:self heightForRowAtIndexPath:indexPath];
    CGFloat headerHeight = [self.delegate collectionViewLayout:self heightForHeaderAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    //找出所有列中高度最小的
    NSInteger columnIndex = [self columnOfLessHeight];
    CGFloat lessHeight = [self.columnHeights[columnIndex] floatValue];

    //计算LayoutAttributes
    CGFloat width = (self.collectionView.frame.size.width-(self.insets.left+self.insets.right)-_columnSpacing*(_columns-1)) / _columns;
    CGFloat height = itemHeight;
    CGFloat x = _insets.left+(width+self.columnSpacing)*columnIndex;
    CGFloat y = lessHeight==0 ? headerHeight+self.insets.top : lessHeight+self.columnSpacing;

    attributes.frame = CGRectMake(x, y, width, height);

    //更新列高度
    self.columnHeights[columnIndex] = @(y+height);

    return attributes;
}

/**
 *  根据kind、indexPath，计算对应的header的LayoutAttributes
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    //计算LayoutAttributes
    if([elementKind isEqualToString:Collection_header_define]){
        CGFloat width = self.collectionView.bounds.size.width;
        CGFloat height = [self.delegate collectionViewLayout:self heightForHeaderAtIndexPath:indexPath];
        CGFloat x = 0;
        //根据offset计算kSupplementaryViewKindHeader的y
        //y = offset.y-(header高度-固定高度)
        CGFloat offsetY = self.collectionView.contentOffset.y;
        CGFloat y = MAX(0,
                        offsetY-(height-[self.delegate collectionViewLayout:self heightForHeaderAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]));
        attributes.frame = CGRectMake(x, y, width, height);
        attributes.zIndex = 1024;
    }
    return attributes;
}
#pragma mark - helpers
/**
 *  找到高度最小的那一列的下标
 */
- (NSInteger)columnOfLessHeight
{
    if(self.columnHeights.count == 0 || self.columnHeights.count == 1){
        return 0;
    }

    __block NSInteger leastIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        
        if([number floatValue] < [self.columnHeights[leastIndex] floatValue]){
            leastIndex = idx;
        }
    }];
    
    return leastIndex;
}

/**
 *  找到高度最大的那一列的下标
 */
- (NSInteger)columnOfMostHeight
{
    if(self.columnHeights.count == 0 || self.columnHeights.count == 1){
        return 0;
    }
    
    __block NSInteger mostIndex = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        
        if([number floatValue] > [self.columnHeights[mostIndex] floatValue]){
            mostIndex = idx;
        }
    }];
    
    return mostIndex;
}
#pragma mark - 根据rect返回应该出现的Items
/**
 *  计算目标rect中含有的item
 */
- (NSMutableArray<NSIndexPath *> *)indexPathForItemsInRect:(CGRect)rect
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    
    
    return indexPaths;
}

/**
 *  计算目标rect中含有的某类SupplementaryView
 */
- (NSMutableArray<NSIndexPath *> *)indexPathForSupplementaryViewsOfKind:(NSString *)kind InRect:(CGRect)rect
{
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    if([kind isEqualToString:Collection_header_define]){
        //在这个瀑布流自定义布局中，只有一个位于列表顶部的SupplementaryView
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        
        [indexPaths addObject:indexPath];
    }
    
    return indexPaths;
}
/**
 *  每当offset改变时，是否需要重新布局，newBounds为offset改变后的rect
 *  瀑布流中不需要，因为滑动时，cell的布局不会随offset而改变
 *  如果需要实现悬浮Header，需要改为YES
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
