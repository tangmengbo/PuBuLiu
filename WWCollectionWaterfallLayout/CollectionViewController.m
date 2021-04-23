//
//  CollectionViewController.m
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//

#import "CollectionViewController.h"
#import "ViewController.h"
#import "CollectionWaterfallLayout.h"
#import "PuBuLiuLayout.h"
#import "CollectionHeaderView.h"


@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataList;


@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataList];
    
    CollectionWaterfallLayout * waterfallLayout = [[CollectionWaterfallLayout alloc] init];
    waterfallLayout.delegate = self;
    waterfallLayout.columns = 2;
    waterfallLayout.columnSpacing = 10;
    waterfallLayout.insets = UIEdgeInsetsMake(10, 10, 10, 10);
    
       //创建一个layout布局类

    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)collectionViewLayout:waterfallLayout];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UICollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"kCollectionViewItemReusableID"];
//
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kCollectionViewItemReusableID"];
//    UINib *headerViewNib = [UINib nibWithNibName:@"WFHeaderView" bundle:nil];
//    [collectionView registerNib:headerViewNib forSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:@"kCollectionViewHeaderReusableID"];
    [collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:@"kCollectionViewHeaderReusableID"];
//
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    
    
}
- (void)setupDataList
{
    _dataList = [NSMutableArray array];
    NSInteger dataCount = arc4random()%25+50;
    for(NSInteger i=0; i<dataCount; i++){
        NSInteger rowHeight = arc4random()%100+200;
        [_dataList addObject:@(rowHeight)];
    }
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCollectionViewItemReusableID" forIndexPath:indexPath];
    if(!cell){
        
        cell = [[UICollectionViewCell alloc] init];
    }
    CGFloat red = arc4random()%256/255.0;
    CGFloat green = arc4random()%256/255.0;
    CGFloat blue = arc4random()%256/255.0;
    
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return cell;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:kSupplementaryViewKindHeader]){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"kCollectionViewHeaderReusableID" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }
    return nil;
}

//
#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat cellHeight = [_dataList[row] floatValue];
    return cellHeight;
}

- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return 150;
    }
    return 0;
}
@end
