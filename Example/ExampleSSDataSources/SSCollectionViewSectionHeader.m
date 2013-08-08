//
//  SSCollectionViewSectionHeader.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 8/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSCollectionViewSectionHeader.h"

@implementation SSCollectionViewSectionHeader

+ (id)supplementaryViewForCollectionView:(UICollectionView *)cv kind:(NSString *)kind indexPath:(NSIndexPath *)indexPath {
    SSCollectionViewSectionHeader *header = [super supplementaryViewForCollectionView:cv
                                                                                 kind:kind
                                                                            indexPath:indexPath];
    
    if( !header.label ) {
        header.label = [[UILabel alloc] initWithFrame:(CGRect){
            5, 0,
            CGRectGetWidth(cv.frame) - 10,
            40}];
        header.label.backgroundColor = [UIColor clearColor];
        header.label.font = [UIFont boldSystemFontOfSize:18.0f];
        header.label.textColor = [UIColor darkGrayColor];
        
        [header addSubview:header.label];
    }
    
    return header;
}

@end
