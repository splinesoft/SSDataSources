//
//  SSDataSourceItemAccess.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 4/6/14.
//
//

/**
 *  Objects implementing the SSDataSourceItemAccess protocol support
 *  a standard interface for accessing items in a multi-sectioned data source.
 */

#import <Foundation/Foundation.h>

// Enumeration block for enumerating data source items.
typedef void (^SSDataSourceEnumerator) (NSIndexPath *indexPath, // Index path for the item
                                        id item,                // the item itself
                                        BOOL *stop);            // Out-only stop parameter to stop enumerating

@protocol SSDataSourceItemAccess <NSObject>

@required

/**
 * Return the item at a given index path. Override me in your subclass.
 */
- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Search the data source for the first instance of the specified item.
 *  Sends isEqual: to every item in the data source.
 *
 *  @param item an item to search for
 *
 *  @return the item's index path if found, or nil
 */
- (NSIndexPath *) indexPathForItem:(id)item;

/**
 * Return the total number of items in the data source. Override me in your subclass.
 */
- (NSUInteger) numberOfItems;

/**
 * Return the total number of sections in the data source. Override me!
 */
- (NSUInteger) numberOfSections;

/**
 * Return the total number of items in a given section. Override me!
 */
- (NSUInteger) numberOfItemsInSection:(NSUInteger)section;

/**
 *  Enumerate every item in the data source (or currently-active filter), executing a block for each item.
 *
 *  @param itemBlock block to execute for each item
 */
- (void) enumerateItemsWithBlock:(SSDataSourceEnumerator)itemBlock;

@end
