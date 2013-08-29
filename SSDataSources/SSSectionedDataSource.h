//
//  SSSectionedDataSource.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 8/26/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSBaseDataSource.h"

/**
 * SSSectionedDataSource is a data source for multi-sectioned table and collection views.
 * Each section is modeled using the `SSSection` object.
 */

#pragma mark - SSSection

/**
 * SSSection models a single section in a multi-sectioned table or collection view.
 * It maintains an array of items appearing within its section,
 * plus a header and footer string.
 */
@interface SSSection : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;

+ (instancetype) sectionWithItems:(NSArray *)items;

- (NSUInteger) numberOfItems;

- (id) itemAtIndex:(NSUInteger)index;

@end

#pragma mark - SSSectionedDataSource

@interface SSSectionedDataSource : SSBaseDataSource

/**
 * Create a sectioned data source with a single section.
 * Creates the `SSSection` object for you.
 */
- (instancetype) initWithItems:(NSArray *)items;

/**
 * Create a sectioned data source with a single SSSection object.
 */
- (instancetype) initWithSection:(SSSection *)section;

/**
 * Create a sectioned data source with multiple sections.
 * Each item in the sections array should be a `SSSection` object.
 */
- (instancetype) initWithSections:(NSArray *)sections;

#pragma mark - Section access

/**
 * Return the section object at a particular index.
 * Use `itemAtIndexPath:` for items.
 */
- (SSSection *) sectionAtIndex:(NSUInteger)index;

#pragma mark - Inserting sections

/**
 * Add a new section to the end of the table or collectionview.
 */
- (void) appendSection:(SSSection *)newSection;

/**
 * Insert a section at a particular index.
 */
- (void) insertSection:(SSSection *)newSection atIndex:(NSUInteger)index;

/**
 * Insert some new sections at the specified indexes.
 * Each item in the `sections` array should itself be an SSSection object
 * or an array, in which case an SSSection object will be created for it.
 * The number of `sections` should equal the number of `indexes`.
 */
- (void) insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes;

#pragma mark - Inserting items

/**
 * Insert an item at a particular section (indexPath.section) and row (indexPath.row).
 */
- (void) insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath;

/**
 * Insert multiple items within a single section.
 * The number of `items` should be equal to the number of `indexes`.
 */
- (void) insertItems:(NSArray *)items
           atIndexes:(NSIndexSet *)indexes
           inSection:(NSUInteger)section;

/**
 * Append multiple items to the end of a single section.
 */
- (void) appendItems:(NSArray *)items toSection:(NSUInteger)section;

#pragma mark - Removing sections

/**
 * Remove the section at a given index.
 */
- (void) removeSectionAtIndex:(NSUInteger)index;

/**
 * Remove the sections in a given range.
 */
- (void) removeSectionsInRange:(NSRange)range;

/**
 * Remove the sections at specified indexes.
 */
- (void) removeSectionsAtIndexes:(NSIndexSet *)indexes;

#pragma mark - Removing items

/**
 * Remove the item at a given indexpath.
 */
- (void) removeItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Remove multiple items within a single section.
 */
- (void) removeItemsAtIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section;

/**
 * Remove multiple items in a range within a single section.
 */
- (void) removeItemsInRange:(NSRange)range inSection:(NSUInteger)section;

#pragma mark - NSIndexPath helpers

+ (NSArray *) indexPathArrayWithIndexSet:(NSIndexSet *)indexes 
                               inSection:(NSUInteger)section;

+ (NSArray *) indexPathArrayWithRange:(NSRange)range 
                            inSection:(NSUInteger)section;

@end
