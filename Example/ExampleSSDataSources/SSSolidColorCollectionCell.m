//
//  SSSolidColorCollectionCell.m
//  ExampleCollectionView
//
//  Created by Jonathan Hersh on 6/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSSolidColorCollectionCell.h"
#import <QuartzCore/QuartzCore.h>

CGSize const kColoredCollectionCellSize = (CGSize) { 93, 93 };

@implementation SSSolidColorCollectionCell

- (void)configureCell {
    self.backgroundColor = [UIColor colorWithRed:0.55f
                                           green:0.57f
                                            blue:0.64f
                                           alpha:1.0f];
    self.layer.cornerRadius = 4.0f;
  
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                           kColoredCollectionCellSize.width,
                                                           kColoredCollectionCellSize.height)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont boldSystemFontOfSize:30.0f];
    self.label.textAlignment = NSTextAlignmentCenter;
  
    [self addSubview:self.label];
}

@end
