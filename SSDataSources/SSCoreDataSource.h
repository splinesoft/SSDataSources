//
//  SSCoreDataSource.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SSBaseDataSource.h"
#import <CoreData/CoreData.h>

/**
 * Generic table/collectionview data source, useful when your data comes from an NSFetchedResultsController.
 * Optional: assign this object to be the FRC's delegate, in which case it'll make
 * updates in response to FRC events.
 */

@interface SSCoreDataSource : SSBaseDataSource <NSFetchedResultsControllerDelegate>

/**
 * The data source's fetched results controller. You probably don't need to set this directly
 * as both initializers will do this for you.
 */
@property (nonatomic, strong) NSFetchedResultsController *controller;

/**
 * Create a data source with a fetched results controller.
 * @param controller - the FRC backing this data source
 */
- (instancetype) initWithFetchedResultsController:(NSFetchedResultsController *)controller;

/**
 * Create a data source with a fetch request and a managed object context.
 * Optionally, specify a section keypath.
 */
- (instancetype) initWithFetchRequest:(NSFetchRequest *)request
                            inContext:(NSManagedObjectContext *)context
                   sectionNameKeyPath:(NSString *)sectionNameKeyPath;

/**
 * Determine an indexpath for the record with a given managed object ID.
 */
- (NSIndexPath *)indexPathForItemWithId:(NSManagedObjectID *)objectId;

@end
