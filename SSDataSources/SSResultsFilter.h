//
//  SSResultsFilter.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 4/2/14.
//
//

#import <Foundation/Foundation.h>
#import "SSBaseDataSource.h"

@interface SSResultsFilter : NSObject

/**
 *  Start here - create a data source filter with the specified filter predicate block.
 *
 *  @param predicate predicate block to use
 *
 *  @return an initialized filter
 */
+ (instancetype) filterWithPredicate:(SSFilterPredicate)predicate;

#pragma mark - Item access

/**
 *  Return the item at the specified index path in the filter.
 *
 *  @param indexPath indexpath to check
 *
 *  @return an item
 */
- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Search the filter for the first instance of the specified item.
 *  Sends isEqual: to each item in the filter.
 *
 *  @param item search item
 *
 *  @return the item's index path if found, or nil
 */
- (NSIndexPath *) indexPathForItem:(id)item;

/**
 *  Number of sections in the filtered data set.
 *
 *  @return number of sections
 */
- (NSUInteger) numberOfSections;

/**
 *  Number of items in the specified section of the filtered data set.
 *
 *  @param section section to check
 *
 *  @return number of items in that section
 */
- (NSUInteger) numberOfItemsInSection:(NSUInteger)section;

/**
 *  Total number of items appearing in the filtered data set.
 *
 *  @return a total item count
 */
- (NSUInteger) numberOfItems;

@property (nonatomic, copy) SSFilterPredicate filterPredicate;
@property (nonatomic, strong) NSMutableArray *sections;

@end
