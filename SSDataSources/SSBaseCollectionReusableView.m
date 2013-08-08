//
//  SSBaseCollectionReusableView.m
//  Pods
//
//  Created by Jonathan Hersh on 8/8/13.
//
//

#import "SSDataSources.h"

@implementation SSBaseCollectionReusableView

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (id)supplementaryViewForCollectionView:(UICollectionView *)cv
                                    kind:(NSString *)kind
                               indexPath:(NSIndexPath *)indexPath {
    return [cv dequeueReusableSupplementaryViewOfKind:kind
                                  withReuseIdentifier:[self identifier]
                                         forIndexPath:indexPath];
}

@end
