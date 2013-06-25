//
//  SSBaseCollectionCell.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/24/13.
//
//

/**
 * Generic collection view cell. Subclass me!
 */

#import <UIKit/UIKit.h>

@interface SSBaseCollectionCell : UICollectionViewCell

+ (NSString *) identifier;

+ (id) cellForCollectionView:(UICollectionView *)collectionView
                   indexPath:(NSIndexPath *)indexPath;

@end
