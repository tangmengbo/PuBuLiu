//
//  NormalCollectionViewController.m
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//


#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#import "PuBuLiuCollectionViewController.h"
#import "CollectionHeaderView.h"
#import "NormalCollectionViewCell.h"
#import "PuBuLiuLayout.h"

@interface PuBuLiuCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PuBuLiuLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation PuBuLiuCollectionViewController

#pragma mark - 数据源
- (void)setupDataList
{
    _dataList = [NSMutableArray array];
    NSInteger dataCount = arc4random()%25+50;
    for(NSInteger i=0; i<dataCount; i++){
        NSInteger rowHeight = arc4random()%100+200;
        [_dataList addObject:@(rowHeight)];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataList];
    
    
    PuBuLiuLayout * waterfallLayout = [[PuBuLiuLayout alloc] init];
    waterfallLayout.delegate = self;
    waterfallLayout.columns = 2;
    waterfallLayout.columnSpacing = 10;
    waterfallLayout.insets = UIEdgeInsetsMake(10, 10, 10, 10);

    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)collectionViewLayout:waterfallLayout];
    if (@available(iOS 11.0, *)) {//解决iOS11collectionView下移20pt问题
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
    //注册cell
    [collectionView registerClass:[NormalCollectionViewCell class] forCellWithReuseIdentifier:@"kCollectionViewItemReusableID"];
    //注册headerView
    [collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:Collection_header_define withReuseIdentifier:@"kCollectionViewHeaderReusableID"];
    //注册footerView
//    [collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:Collection_footer_define withReuseIdentifier:@"kCollectionViewFooterReusableID"];

    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCollectionViewItemReusableID" forIndexPath:indexPath];
    if(!cell){
        
        cell = [[NormalCollectionViewCell alloc] init];
    }
    CGFloat red = arc4random()%256/255.0;
    CGFloat green = arc4random()%256/255.0;
    CGFloat blue = arc4random()%256/255.0;
    
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    cell.topImage.backgroundColor = [UIColor yellowColor];
    cell.btmlabel.adjustsFontSizeToFitWidth = YES;
    cell.btmlabel.text = [NSString stringWithFormat:@"爱微游-%d",(int)indexPath.row];
    cell.btmlabel.textColor = [UIColor whiteColor];
    return cell;
    
}
//设置UICollectionView的头布局
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:Collection_header_define]){
        
        CollectionHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"kCollectionViewHeaderReusableID" forIndexPath:indexPath];
        return headView;
    }
    return nil;
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NormalCollectionViewCell *cell = (NormalCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *msg = cell.btmlabel.text;
    NSLog(@"%@",msg);
}
//返回cell的高度
-(CGFloat)collectionViewLayout:(UICollectionViewLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat cellHeight = [_dataList[row] floatValue];
    return cellHeight;

}
//返回header的高度
- (CGFloat)collectionViewLayout:(UICollectionViewLayout *)layout heightForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        
        return 150;
    }
    return 0;
}
@end
