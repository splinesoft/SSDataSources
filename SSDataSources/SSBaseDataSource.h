//
//  SSBaseDataSource.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

/**
 * A generic data source object for table and collection views. Takes care of creating new cells 
 * and exposes a block interface to configure cells with the object they represent.
 * Don't use this class directly except to subclass - instead, see SSArrayDataSource and
 * SSCoreDataSource.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Block called to configure each table and collection cell.
typedef void (^SSCellConfigureBlock) (id cell,                 // The cell to configure
                                      id object,               // The object being presented in this cell
                                      id parentView,           // The parent table or collection view
                                      NSIndexPath *indexPath); // Index path for this cell

// Optional block used to create a table or collection cell.
typedef id   (^SSCellCreationBlock)  (id object,               // The object being presented in this cell
                                      id parentView,           // The parent table or collection view
                                      NSIndexPath *indexPath); // Index path for this cell

@interface SSBaseDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

- (instancetype) init;

#pragma mark - base data source

/**
 * The base class to use to instantiate new cells.
 * Assumed to be a subclass of SSBaseTableCell or SSBaseCollectionCell.
 * If you use a cell class that does not inherit one of those two,
 * or if you want to specify your own custom cell creation logic, 
 * you can ignore this property and instead specify a cellCreationBlock.
 */
@property (nonatomic, weak) Class cellClass;

/**
 * Cell configuration block, called for each table and collection 
 * cell with the object to display in that cell. See block signature above.
 */
@property (nonatomic, copy) SSCellConfigureBlock cellConfigureBlock;

/**
 * Optional block to use to instantiate new table and collection cells.
 * See block signature above.
 */
@property (nonatomic, copy) SSCellCreationBlock cellCreationBlock;

#pragma mark - UITableView

/**
 * Optional: If the tableview property is assigned, the data source will perform
 * insert/reload/delete calls on it as data changes.
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 * Optional animation to use when updating the table.
 * Defaults to UITableViewRowAnimationNone.
 */
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation;

/**
 * Optional data source fallback.
 * If this is set, it will receive data source delegate calls for:
 * tableView:canEditRowAtIndexPath:
 * tableView:commitEditingStyle:forRowAtIndexPath:
 * tableView:canMoveRowAtIndexPath:
 * but not tableView:moveRowAtIndexPath:toIndexPath: - SSArrayDataSource does this for you.
 *
 * See 'ExampleTable' for an example of editing, deleting, and drag-to-reorder rows.
 */
@property (nonatomic, weak) id <UITableViewDataSource> fallbackTableDataSource;

#pragma mark - UICollectionView

/**
 * Optional: If the collectionview property is assigned, the data source will perform
 * insert/reload/delete calls on it as data changes.
 */
@property (nonatomic, weak) UICollectionView *collectionView;

/**
 * Optional data source fallback for supplementary elements.
 * If this is set, it will receive data source delegate calls for
 * collectionView:viewForSupplementaryElementOfKind:atIndexPath:
 */
@property (nonatomic, weak) id <UICollectionViewDataSource> fallbackCollectionDataSource;

#pragma mark - item access

/**
 * Return the item at a given index path. Override me in your subclass.
 */
- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - helpers

/**
 * Helper functions to generate arrays of NSIndexPaths.
 */
+ (NSArray *) indexPathArrayWithRange:(NSRange)range;
+ (NSArray *) indexPathArrayWithIndexSet:(NSIndexSet *)indexes;

@end
