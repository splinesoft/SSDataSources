//
//  SSBaseDataSource.h
//  SSPods
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SSTableViewCellConfigureBlock) (id cell, id object);

/**
 * A generic data source object for table views. Takes care of creating new cells 
 * and exposes a block interface to configure cells with the object they represent.
 * Don't use this class directly - instead, see SSTableArrayDataSource and
 * SSTableFRCDataSource.
 */

@interface SSBaseDataSource : NSObject <UITableViewDataSource>

- (instancetype) init;

/**
 * The class to use to instantiate new table cells.
 */
@property (nonatomic, weak) Class cellClass;

/**
 * Cell configuration block, called once for each cell with the object to display in that cell.
 */
@property (nonatomic, copy) SSTableViewCellConfigureBlock cellConfigureBlock;

/**
 * Optional animation to use when updating the table.
 * Defaults to UITableViewRowAnimationNone.
 */
@property (nonatomic, assign) UITableViewRowAnimation rowAnimation;

/**
 * Optional data source fallback.
 * If this is set, it will receive data source delegate calls for editing/deleting cells.
 */
@property (nonatomic, weak) id <UITableViewDataSource> fallbackDataSource;

/**
 * Optional: If the tableview property is assigned, the data source will perform
 * insert/reload/delete calls on it as data changes.
 */
@property (nonatomic, weak) UITableView *tableView;

#pragma mark - item access

/**
 * Return the item at a given index path. Override me in your subclass.
 */
- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

@end
