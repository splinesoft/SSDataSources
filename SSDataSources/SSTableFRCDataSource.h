//
//  SSTableFRCDataSource.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SSBaseDataSource.h"

/**
 * Generic table data source, useful when your data comes from an NSFetchedResultsController.
 * Optional: assign this object to be the FRC's delegate, in which case it'll call
 * tableview updates in response to FRC events.
 */

@interface SSTableFRCDataSource : SSBaseDataSource <NSFetchedResultsControllerDelegate>

/**
 * Create a table view data source with a fetched results controller and a configuration block.
 * @param controller - the FRC backing this data source
 */
- (instancetype) initWithFetchedResultsController:(NSFetchedResultsController *)controller;

/**
 * Create a table view data source with a fetch request and a managed object context.
 * Optionally, specify a section keypath.
 */
- (instancetype) initWithFetchRequest:(NSFetchRequest *)request
                            inContext:(NSManagedObjectContext *)context
                   sectionNameKeyPath:(NSString *)sectionNameKeyPath;

@end
