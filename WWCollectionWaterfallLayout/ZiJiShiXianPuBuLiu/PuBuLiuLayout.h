//
//  PuBuLiuLayout.h
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  Collection_header_define  @"Header"

NS_ASSUME_NONNULL_BEGIN


@protocol PuBuLiuLayoutDelegate <NSObject>

//代理事件获取cell的高度
- (CGFloat)collectionViewLayout:(UICollectionViewLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//代理事件获取header的高度
- (CGFloat)collectionViewLayout:(UICollectionViewLayout *)layout heightForHeaderAtIndexPath:(NSIndexPath *)indexPath;



@end

@interface PuBuLiuLayout : UICollectionViewLayout

@property (nonatomic, weak) id<PuBuLiuLayoutDelegate> delegate;

@property (nonatomic, assign)NSUInteger columns;//有多少列

@property (nonatomic, strong)NSMutableArray * columnHeights;//存放每一列的高度

@property (nonatomic, strong)NSMutableArray * attributesArray;//存放 UICollectionViewLayoutAttributes

@property (nonatomic, assign) CGFloat columnSpacing;//列与列之间的间距

@property (nonatomic, assign) UIEdgeInsets insets;//cell的边距



@end

NS_ASSUME_NONNULL_END
