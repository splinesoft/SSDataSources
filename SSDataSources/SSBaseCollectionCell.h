//
//  SSBaseCollectionCell.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/24/13.
//
//

/**
 * Generic collection view cell. Subclass me!
 * Override `configureCell` to do one-time setup at cell creation, like creating subviews.
 * You probably don't need to override `identifier`.
 */

#import <UIKit/UIKit.h>

@interface SSBaseCollectionCell : UICollectionViewCell

+ (NSString *) identifier;

+ (id) cellForCollectionView:(UICollectionView *)collectionView
                   indexPath:(NSIndexPath *)indexPath;

// Override me!
- (void) configureCell;

@end
