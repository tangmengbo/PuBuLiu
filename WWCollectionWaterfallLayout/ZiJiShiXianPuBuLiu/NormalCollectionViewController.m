//
//  NormalCollectionViewController.m
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//

#import "NormalCollectionViewController.h"

#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

#import "PuBuLiuCollectionViewController.h"
#import "CollectionHeaderView.h"
#import "NormalCollectionViewCell.h"

@interface NormalCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataList;

@end

@implementation NormalCollectionViewController

-(void)setupDataList
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
    
    UICollectionViewFlowLayout * waterfallLayout = [[UICollectionViewFlowLayout alloc] init];
    waterfallLayout.sectionHeadersPinToVisibleBounds = YES; //header 悬停 YES 悬停 NO 跟随
    waterfallLayout.sectionFootersPinToVisibleBounds = NO;//footer 悬停 YES 悬停 NO 跟随
    

    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)collectionViewLayout:waterfallLayout];
    if (@available(iOS 11.0, *)) {//解决iOS11collectionView下移20pt问题
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
    //注册cell
    [collectionView registerClass:[NormalCollectionViewCell class] forCellWithReuseIdentifier:@"kCollectionViewItemReusableID"];
    //注册headerView
    [collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"kCollectionViewHeaderID"];
    //注册footerView
    [collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"kCollectionViewFooterID"];

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
//设置UICollectionView的头布局和脚布局
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        CollectionHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"kCollectionViewHeaderID" forIndexPath:indexPath];
        return headView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        CollectionHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"kCollectionViewFooterID" forIndexPath:indexPath];
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

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth-30)/2, 250);

}
//定义每个UICollectionView item 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}
//设置UICollectionView的header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth-20, 150);
}
//设置UICollectionView的footer的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, 150);
}



@end
