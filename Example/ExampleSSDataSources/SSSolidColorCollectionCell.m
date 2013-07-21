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

+ (id)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    SSSolidColorCollectionCell *cell = [super cellForCollectionView:collectionView indexPath:indexPath];
    
    if( !cell.label ) {
        cell.label = [[UILabel alloc] initWithFrame:CGRectZero];
        cell.label.backgroundColor = [UIColor clearColor];
        cell.label.textColor = [UIColor whiteColor];
        cell.label.font = [UIFont boldSystemFontOfSize:18.0f];
        cell.label.textAlignment = NSTextAlignmentCenter;
        
        [cell addSubview:cell.label];
    }
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.layer.cornerRadius = 4.0f;
    
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:(CGRect){ 0, 0, self.frame.size }];
}

@end
