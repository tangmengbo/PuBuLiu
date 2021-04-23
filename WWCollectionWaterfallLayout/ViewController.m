//
//  ViewController.m
//  WWCollectionWaterfallLayout
//
//  Created by Tidus on 17/1/13.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import "ViewController.h"
#import "CollectionWaterfallLayout.h"


static NSString *const kCollectionViewItemReusableID = @"kCollectionViewItemReusableID";
static NSString *const kCollectionViewHeaderReusableID = @"kCollectionViewHeaderReusableID";


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionWaterfallLayoutProtocol>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionWaterfallLayout *waterfallLayout;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupDataList];
    [self setupRightButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)setupRightButton
{
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self action:@selector(buttonClick)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, nil];
}

- (void)buttonClick
{
    [self setupDataList];
    [self.collectionView reloadData];
    
}
#pragma mark - getter
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _waterfallLayout = [[CollectionWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = 10;
        _waterfallLayout.insets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-StatusBarHeight-NavigationBarHeight) collectionViewLayout:_waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewItemReusableID];
        UINib *headerViewNib = [UINib nibWithNibName:@"WFHeaderView" bundle:nil];
        [_collectionView registerNib:headerViewNib forSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:kCollectionViewHeaderReusableID];
    }
    
    
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return _dataList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewItemReusableID forIndexPath:indexPath];
    
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
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCollectionViewHeaderReusableID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor blueColor];
        return headerView;
    }
    return nil;
}

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
        return 200;
    }
    return 0;
}
@end
