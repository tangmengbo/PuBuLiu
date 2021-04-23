//
//  NormalCollectionViewCell.m
//  WWCollectionWaterfallLayout
//
//  Created by 薛昭 on 2021/4/23.
//  Copyright © 2021 Tidus. All rights reserved.
//

#import "NormalCollectionViewCell.h"

@implementation NormalCollectionViewCell


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.contentView addSubview:self.topImage];
        
        self.btmlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.topImage.frame.origin.y+self.topImage.frame.size.height+10, 70, 20)];
        self.btmlabel.textAlignment = NSTextAlignmentCenter;
        self.btmlabel.textColor = [UIColor blackColor];
        self.btmlabel.font = [UIFont fontWithName:@"Verdana-Bold"size:19];
        [self.contentView addSubview:self.btmlabel];
    }
    
    return self;
}


@end
