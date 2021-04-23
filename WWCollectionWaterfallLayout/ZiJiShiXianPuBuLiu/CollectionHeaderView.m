//
//  CollectionHeaderView.m
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//

#import "CollectionHeaderView.h"
#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20)];
        imageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:imageView];
    }
    return self;
    
}

@end
