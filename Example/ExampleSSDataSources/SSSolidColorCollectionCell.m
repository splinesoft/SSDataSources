//
//  SSSolidColorCollectionCell.m
//  ExampleCollectionView
//
//  Created by Jonathan Hersh on 6/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSSolidColorCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSSolidColorCollectionCell

- (void)configureCell {
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.cornerRadius = 4.0f;
  
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont boldSystemFontOfSize:18.0f];
    self.label.textAlignment = NSTextAlignmentCenter;
  
    [self addSubview:self.label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:(CGRect){ {0, 0}, self.frame.size }];
}

@end
