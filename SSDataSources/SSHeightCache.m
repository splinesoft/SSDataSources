//
//  SSHeightCache.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 3/15/14.
//
//

#import "SSHeightCache.h"
#import "SSBaseDataSource.h"

@implementation SSHeightCache

- (void)cacheHeight:(CGFloat)height forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setObject:@(height) forKey:indexPath];
}

- (void)cacheSize:(CGSize)size forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setObject:[NSValue valueWithCGSize:size] forKey:indexPath];
}

- (CGFloat)cachedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self objectForKey:indexPath];
    
    if (!height) {
        return 0.0f;
    }
    
    return [height floatValue];
}

- (CGSize)cachedSizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSValue *size = [self objectForKey:indexPath];
    
    if (!size) {
        return CGSizeZero;
    }
    
    return [size CGSizeValue];
}

- (void)removeCachedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self removeObjectForKey:indexPath];
}

- (void)removeCachedHeightForRowsInRange:(NSRange)range
                               inSection:(NSUInteger)section {
    [self removeCachedHeightForRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]
                                   inSection:section];
}

- (void)removeCachedHeightForRowsAtIndexes:(NSIndexSet *)indexes
                                 inSection:(NSUInteger)section {
    [self removeCachedHeightForRowsAtIndexPaths:
     [SSBaseDataSource indexPathArrayWithIndexSet:indexes
                                        inSection:section]];
}

- (void)removeCachedHeightForRowsAtIndexPaths:(NSArray *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *index,
                                             NSUInteger i,
                                             BOOL *stop) {
        [self removeCachedHeightForRowAtIndexPath:index];
    }];
}

- (void)removeAllCachedHeights {
    [self removeAllObjects];
}

@end
