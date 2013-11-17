//
//  SSSectionedDataSource.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 8/26/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSBaseDataSource.h"
#import "SSSection.h"

/**
 * SSSectionedDataSource is a data source for multi-sectioned table and collection views.
 * Each section is modeled using an `SSSection` object.
 */

#pragma mark - SSSectionedDataSource

@interface SSSectionedDataSource : SSBaseDataSource

/**
 * Sections appearing in the datasource.
 * You should not mutate this directly - rather, use the insert/move/remove accessors below.
 */
@property (nonatomic, strong) NSMutableArray *sections;

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

/**
 * Return the first section with a given identifier, or nil if not found.
 */
- (SSSection *) sectionWithIdentifier:(id)identifier;

/**
 * Return the index of the first section with a given identifier, or NSNotFound.
 * See `sectionIdentifier` in SSSection.
 */
- (NSUInteger) indexOfSectionWithIdentifier:(id)identifier;

#pragma mark - Moving sections

- (void) moveSectionAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

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
 * Destroy all sections.
 */
- (void) clearSections;
- (void) removeAllSections;

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

#pragma mark - UITableViewDelegate helpers

/**
 * It is UITableViewDelegate, not UITableViewDataSource,
 * that provides header and footer views.
 * SSDataSources provides these helpers for constructing table header and footer views.
 * Assumes your header/footer view is a subclass of SSBaseHeaderFooterView.
 * See the Example project for sample usage.
 */
- (SSBaseHeaderFooterView *) viewForHeaderInSection:(NSUInteger)section;
- (SSBaseHeaderFooterView *) viewForFooterInSection:(NSUInteger)section;

/**
 * As above, but for section header/footer heights.
 * This is simply a shortcut for
 * [myDataSource sectionAtIndex:section].headerHeight;
 */
- (CGFloat) heightForHeaderInSection:(NSUInteger)section;
- (CGFloat) heightForFooterInSection:(NSUInteger)section;

/**
 * As above, for section header/footer titles.
 * This is simply a shortcut for
 * [myDataSource sectionAtIndex:section].header/footer
 */
- (NSString *) titleForHeaderInSection:(NSUInteger)section;
- (NSString *) titleForFooterInSection:(NSUInteger)section;

@end
