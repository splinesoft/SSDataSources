//
//  SSCoreDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"

@interface SSCoreDataSource ()

// For UICollectionView
@property (nonatomic, strong) NSMutableArray *sectionUpdates;
@property (nonatomic, strong) NSMutableArray *objectUpdates;

- (void) _performFetch;

@end

@implementation SSCoreDataSource

- (instancetype)init {
    if ((self = [super init])) {
        _sectionUpdates = [NSMutableArray new];
        _objectUpdates = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype) initWithFetchedResultsController:(NSFetchedResultsController *)aController {
    if ((self = [self init])) {
        _controller = aController;
        _controller.delegate = self;
        
        if (!_controller.fetchedObjects) {
            [self _performFetch];
        }
    }
    
    return self;
}

- (instancetype)initWithFetchRequest:(NSFetchRequest *)request
                           inContext:(NSManagedObjectContext *)context
                  sectionNameKeyPath:(NSString *)sectionNameKeyPath {
    
    if ((self = [self init])) {
        _controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                          managedObjectContext:context
                                                            sectionNameKeyPath:sectionNameKeyPath
                                                                     cacheName:nil];
        
        _controller.delegate = self;
        
        [self _performFetch];
    }
    
    return self;
}

- (void)dealloc {
    self.controller.delegate = nil;
    self.controller = nil;
    [self.sectionUpdates removeAllObjects];
    [self.objectUpdates removeAllObjects];
}

#pragma mark - Fetching

- (void)_performFetch {
    NSError *fetchErr;
    [_controller performFetch:&fetchErr];
    _fetchError = fetchErr;
}

#pragma mark - Base data source

- (NSUInteger)numberOfSections {
    return (NSUInteger)[[_controller sections] count];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [_controller sections][(NSUInteger)section];
    return (NSUInteger)[sectionInfo numberOfObjects];
}

- (NSUInteger)numberOfItems {
    NSUInteger count = 0;
  
    for (id <NSFetchedResultsSectionInfo> section in [_controller sections])
        count += [section numberOfObjects];
  
    return count;
}

#pragma mark - item access

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [_controller objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForItemWithId:(NSManagedObjectID *)objectId {
    for (NSUInteger section = 0; section < [self numberOfSections]; section++) {
        id <NSFetchedResultsSectionInfo> sec = [_controller sections][section];
        
        NSUInteger index = [[sec objects] indexOfObjectPassingTest:^BOOL(NSManagedObject *object,
                                                                         NSUInteger idx,
                                                                         BOOL *stop) {
            return [[object objectID] isEqual:objectId];
        }];
    
        if (index != NSNotFound)
            return [NSIndexPath indexPathForRow:(NSInteger)index inSection:(NSInteger)section];
    }
  
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return [_controller sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_controller sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [_controller sections][(NSUInteger)section];
    return [sectionInfo name];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    return sectionName;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                                  withRowAnimation:self.rowAnimation];
            break;
            
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                                  withRowAnimation:self.rowAnimation];
            break;
            
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                                  withRowAnimation:self.rowAnimation];
            break;
            
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[ indexPath, newIndexPath ];
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                                  withRowAnimation:self.rowAnimation];
            [self.tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                                  withRowAnimation:self.rowAnimation];
            break;
    }
    
    [self.objectUpdates addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:self.rowAnimation];
            change[@(type)] = @[@(sectionIndex)];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:self.rowAnimation];
            change[@(type)] = @[@(sectionIndex)];
            break;
    }
    
    [self.sectionUpdates addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
    if (self.collectionView) {
        
        if ([self.sectionUpdates count] > 0) {
            [self.collectionView performBatchUpdates:^{
                for (NSDictionary *change in self.sectionUpdates) {
                    [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id secnum, BOOL *stop) {
                        NSFetchedResultsChangeType type = (NSFetchedResultsChangeType)[key unsignedIntegerValue];
                        NSIndexSet *section = [NSIndexSet indexSetWithIndex:[secnum unsignedIntegerValue]];
                        
                        switch( type ) {
                            case NSFetchedResultsChangeInsert:
                                [self.collectionView insertSections:section];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self.collectionView deleteSections:section];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self.collectionView reloadSections:section];
                                break;
                        }
                    }];
                }
            } completion:nil];
        }
        
        if ([self.objectUpdates count] > 0 && [self.sectionUpdates count] == 0) {
            [self.collectionView performBatchUpdates:^{
                for (NSDictionary *change in self.objectUpdates) {
                    [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id indexPath, BOOL *stop) {
                        NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                        
                        switch( type ) {
                            case NSFetchedResultsChangeInsert:
                                [self.collectionView insertItemsAtIndexPaths:@[ indexPath ]];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self.collectionView deleteItemsAtIndexPaths:@[ indexPath ]];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self.collectionView reloadItemsAtIndexPaths:@[ indexPath ]];
                                break;
                            case NSFetchedResultsChangeMove:
                                [self.collectionView moveItemAtIndexPath:indexPath[0]
                                                             toIndexPath:indexPath[1]];
                                break;
                        }
                    }];
                }
            } completion:nil];
        }
    }
    
    [self.sectionUpdates removeAllObjects];
    [self.objectUpdates removeAllObjects];
}

@end
