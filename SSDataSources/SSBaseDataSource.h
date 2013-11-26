//
//  SSBaseDataSource.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

/**
 * A generic data source object for table and collection views. Takes care of creating new cells 
 * and exposes a block interface to configure cells with the object they represent.
 * Don't use this class directly except to subclass - instead, see 
 * SSArrayDataSource, SSSectionedDataSource, and SSCoreDataSource.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSBaseDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

#pragma mark - SSDataSources block signatures

// Block called to configure each table and collection cell.
typedef void (^SSCellConfigureBlock) (id cell,                 // The cell to configure
                                      id object,               // The object being presented in this cell
                                      id parentView,           // The parent table or collection view
                                      NSIndexPath *indexPath); // Index path for this cell

// Optional block used to create a table or collection cell.
typedef id   (^SSCellCreationBlock)  (id object,               // The object being presented in this cell
                                      id parentView,           // The parent table or collection view
                                      NSIndexPath *indexPath); // Index path for this cell

// Optional block used to create a UICollectionView supplementary view.
typedef UICollectionReusableView * (^SSCollectionSupplementaryViewCreationBlock)
                                                            (UICollectionView *cv,    // the parent collection view
                                                             NSString *kind,          // the kind of reusable view
                                                             NSIndexPath *indexPath); // index path for this view

// Optional block used to configure UICollectionView supplementary views.
typedef void (^SSCollectionSupplementaryViewConfigureBlock) (id view,                 // the header/footer view
                                                             UICollectionView *cv,    // the parent collection view
                                                             NSString *kind,          // the kind of reusable view
                                                             NSIndexPath *indexPath); // index path where this view appears

// Optional block used to configure table move/edit behavior.
typedef NS_ENUM(NSUInteger, SSCellActionType) {
    SSCellActionTypeEdit,
    SSCellActionTypeMove
};

typedef BOOL (^SSTableCellActionBlock) (UITableView *parentView,      // the parent table view
                                        NSIndexPath *indexPath,       // the indexPath being edited or moved
                                        SSCellActionType actionType); // The action type requested for this cell (edit or move)

// Optional block used to handle deletion behavior.
typedef void (^SSTableCellDeletionBlock) (UITableView *parentView, // the parent table view
                                          NSIndexPath *indexPath,  // the indexPath being deleted
                                          id dataSource);          // the datasource performing the deletion

#pragma mark - base data source setup

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
 * 
 * Assigning this property will set the reciever as the tableView's `dataSource`
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 * Optional animation to use when updating the table.
 * Defaults to UITableViewRowAnimationAutomatic.
 */
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation;

/**
 * In lieu of implementing
 * tableView:canEditRowAtIndexPath: and
 * tableView:canMoveRowAtIndexPath:
 * you may instead specify this block, which will be called to determine whether editing
 * and moving is allowed for a given indexPath.
 */
@property (nonatomic, copy) SSTableCellActionBlock tableActionBlock;

/**
 * To implement cell deletion, first specify a `tableActionBlock` that returns
 * YES when called with SSCellActionTypeEdit. Then specify this deletion block,
 * which can be as simple as removing the item in question.
 * See the Example project for a full implementation.
 */
@property (nonatomic, copy) SSTableCellDeletionBlock tableDeletionBlock;

#pragma mark - UICollectionView

/**
 * Optional: If the collectionview property is assigned, the data source will perform
 * insert/reload/delete calls on it as data changes.
 * 
 * Assigning this property will set the reciever as the collectionView's `dataSource`
 */
@property (nonatomic, weak) UICollectionView *collectionView;

/**
 * The base class to use to instantiate new supplementary collection view elements.
 * These are assumed to be subclasses of SSBaseCollectionReusableView.
 * If you want to use a class that does not inherit SSBaseCollectionReusableView,
 * or if you want to use your own custom logic to create supplementary elements,
 * then you can ignore this property and instead specify a collectionSupplementaryCreationBlock.
 */
@property (nonatomic, weak) Class collectionViewSupplementaryElementClass;

/**
 * Optional block used to create supplementary collection view elements.
 */
@property (nonatomic, copy) SSCollectionSupplementaryViewCreationBlock collectionSupplementaryCreationBlock;

/**
 * Optional configure block for supplementary collection view elements.
 */
@property (nonatomic, copy) SSCollectionSupplementaryViewConfigureBlock collectionSupplementaryConfigureBlock;

#pragma mark - item access

/**
 * Return the item at a given index path. Override me in your subclass.
 */
- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

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

#pragma mark - helpers

/**
 * Helper functions to generate arrays of NSIndexPaths.
 */
+ (NSArray *) indexPathArrayWithRange:(NSRange)range inSection:(NSUInteger)section;
+ (NSArray *) indexPathArrayWithIndexSet:(NSIndexSet *)indexes inSection:(NSUInteger)section;

@end
