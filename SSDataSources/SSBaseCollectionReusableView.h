//
//  SSBaseCollectionReusableView.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 8/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

/**
 * A simple base collection reusable view. Subclass me if necessary.
 */

#import <UIKit/UIKit.h>

@interface SSBaseCollectionReusableView : UICollectionReusableView

+ (NSString *) identifier;

+ (id) supplementaryViewForCollectionView:(UICollectionView *)cv
                                     kind:(NSString *)kind
                                indexPath:(NSIndexPath *)indexPath;

@end
