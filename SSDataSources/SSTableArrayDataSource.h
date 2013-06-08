//
//  SSTableArrayDataSource.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SSBaseDataSource.h"
#import <CoreData/CoreData.h>

/**
 * Generic table data source, useful when your data is an array of objects.
 * If this datasource's `tableView` property is set to your tableview, the data source will
 * perform insert/reload/delete calls when the data changes.
 */

@interface SSTableArrayDataSource : SSBaseDataSource

/**
 * Create a new table data source by specifying an array of items and a
 * block to configure each cell with its item.
 * @param items - the array of items to display in the table.
 */
- (instancetype) initWithItems:(NSArray *)items;

#pragma mark - item access

/**
 * Add some more items to the end of the items array.
 */
- (void) appendItems:(NSArray *)newItems;

/**
 * Returns all items, or updates them.
 */
- (NSArray *) allItems;
- (void) updateItems:(NSArray *)newItems;

/*
 * Replace an item.
 */
- (void) replaceItemAtIndex:(NSUInteger)index withItem:(id)item;

/**
 * Remove items.
 */
- (void) removeItemsInRange:(NSRange)range;
- (void) removeItemAtIndex:(NSUInteger)index;

/**
 * Return the number of items in the data source.
 */
- (NSUInteger) numberOfItems;

/**
 * Return the item appearing at a given indexpath in the table.
 */
- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

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

@end
