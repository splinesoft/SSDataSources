//
//  SSHeightCache.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 3/15/14.
//
//

#import <Foundation/Foundation.h>

@interface SSHeightCache : NSCache

#pragma mark - Storing heights

/**
 *  Cache the result of a height calculation for the row at the specified index path.
 *
 *  @param height    height to cache
 *  @param indexPath index path being cached
 */
- (void) cacheHeight:(CGFloat)height forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Cache the result of a height calculation for the row at the specified index path.
 *  You might use sizes for collection cells.
 *
 *  @param size    size to cache
 *  @param indexPath index path being cached
 */
- (void) cacheSize:(CGSize)size forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Fetching heights

/**
 *  Fetch the cached height for a given index path.
 *
 *  @param indexPath index path being read
 *
 *  @return the cached height, or 0 if not found
 */
- (CGFloat) cachedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Fetch the cached size for a given index path.
 *
 *  @param indexPath index path being read
 *
 *  @return the cached size, or CGSizeZero if not found
 */
- (CGSize) cachedSizeForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Removing heights

/**
 *  Remove the cached height value for the row at a given index path
 *
 *  @param indexPath index path to clear
 */
- (void) removeCachedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Remove the cached height values for the rows at the given index paths
 *
 *  @param indexPaths index paths to clear
 */
- (void) removeCachedHeightForRowsAtIndexPaths:(NSArray *)indexPaths;

/**
 *  Remove the cached height values for the rows in the given range.
 *
 *  @param range range of rows to remove
 *  @param section section containing these rows
 */
- (void) removeCachedHeightForRowsInRange:(NSRange)range inSection:(NSUInteger)section;

/**
 *  Remove the cached height values for the rows at the specified indexes.
 *
 *  @param indexes indexes to un-cache
 *  @param section section for these indexes
 */
- (void) removeCachedHeightForRowsAtIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section;

/**
 *  Empty the height cache values for all rows.
 */
- (void) removeAllCachedHeights;

@end
