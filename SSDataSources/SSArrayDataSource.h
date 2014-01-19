//
//  SSArrayDataSource.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SSBaseDataSource.h"
#import <CoreData/CoreData.h>

/**
 * Data source for single-sectioned table and collection views.
 */

@interface SSArrayDataSource : SSBaseDataSource

/**
 * Create a new array data source by specifying an array of items.
 */
- (instancetype) initWithItems:(NSArray *)items;

#pragma mark - item access

/**
 * Add some more items to the end of the items array.
 */
- (void) appendItem:(id)item;
- (void) appendItems:(NSArray *)newItems;

/**
 * Insert some items at the specified indexes.
 * The count of `items` should be equal to the number of `indexes`.
 */
- (void) insertItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;

/**
 * Returns all items in the data source.
 */
- (NSArray *) allItems;

/**
 * Replace all items in the data source.
 * This will reload the table or collection view.
 */
- (void) updateItems:(NSArray *)newItems;

/**
 * Replace an item.
 */
- (void) replaceItemAtIndex:(NSUInteger)index withItem:(id)item;

/**
 * Remove the item at the specified index.
 */
- (void) removeItemAtIndex:(NSUInteger)index;

/**
 * Remove items in the specified range.
 */
- (void) removeItemsInRange:(NSRange)range;

/**
 * Remove items at the specified indexes.
 */
- (void) removeItemsAtIndexes:(NSIndexSet *)indexes;

/**
 * Move an item to a new index.
 */
- (void) moveItemAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2;

/**
 * Return the indexpath for a given item in the data source.
 */
- (NSIndexPath *) indexPathForItem:(id)item;

/**
 * Helper for managed objects. As with `indexPathForItem`, but for managed object IDs.
 */
- (NSIndexPath *) indexPathForItemWithId:(NSManagedObjectID *)itemId;

/**
 * Remove all objects in the data source.
 */
- (void) clearItems;
- (void) removeAllItems;

@end
