//
//  ViewController.h
//  WWCollectionWaterfallLayout
//
//  Created by Tidus on 17/1/13.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)


@interface ViewController : UIViewController


@end

