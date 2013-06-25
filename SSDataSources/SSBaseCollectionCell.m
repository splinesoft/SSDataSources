//
//  SSBaseCollectionCell.m
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/24/13.
//
//

#import "SSBaseCollectionCell.h"

@implementation SSBaseCollectionCell

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (id)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self identifier]
                                                     forIndexPath:indexPath];
}

@end
