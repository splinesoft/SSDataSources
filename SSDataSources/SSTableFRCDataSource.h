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
#import <CoreData/CoreData.h>

/**
 * Generic table data source, useful when your data comes from an NSFetchedResultsController.
 * Optional: assign this object to be the FRC's delegate, in which case it'll make
 * tableview updates in response to FRC events.
 */

@interface SSTableFRCDataSource : SSBaseDataSource <NSFetchedResultsControllerDelegate>

/**
 * Create a table view data source with a fetched results controller.
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

/**
 * Returns the total number of fetched items across all sections.
 */
- (NSUInteger) itemCount;

@end
