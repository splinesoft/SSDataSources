//
//  SSArrayDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"
#import <CoreData/CoreData.h>

@interface SSArrayDataSource ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation SSArrayDataSource

- (instancetype)initWithItems:(NSArray *)anItems {
  
  if ((self = [self init])) {
      self.items = (anItems
                    ? [NSMutableArray arrayWithArray:anItems]
                    : [NSMutableArray array]);
  }
  
  return self;
}

- (void)dealloc {
  self.items = nil;
}

#pragma mark - Base Data source

- (NSUInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return [self.items count];
}

- (NSUInteger)numberOfItems {
    return [self.items count];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath)
        return nil;
  
    if (indexPath.row < (NSInteger)[self.items count])
        return self.items[(NSUInteger)indexPath.row];
  
    return nil;
}

#pragma mark - updating items

- (void)clearItems {
    [self.items removeAllObjects];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (void)removeAllItems {
    [self clearItems];
}

- (void)updateItems:(NSArray *)newItems {
    self.items = [NSMutableArray arrayWithArray:newItems];
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (NSArray *)allItems {
    return self.items;
}

- (void)appendItem:(id)item {
    [self appendItems:@[ item ]];
}

- (void)appendItems:(NSArray *)newItems {
    NSUInteger count = [self numberOfItems];
    
    [self.items addObjectsFromArray:newItems];
    
    if (self.tableView)
        [self.tableView insertRowsAtIndexPaths:
         [[self class] indexPathArrayWithRange:NSMakeRange(count, [newItems count])
                                     inSection:0]
                              withRowAnimation:self.rowAnimation];
    
    if (self.collectionView)
        [self.collectionView insertItemsAtIndexPaths:
         [[self class] indexPathArrayWithRange:NSMakeRange(count, [newItems count])
                                     inSection:0]];
}

- (void)insertItems:(NSArray *)newItems atIndexes:(NSIndexSet *)indexes {    
    [self.items insertObjects:newItems atIndexes:indexes];
    
    if (self.tableView)
        [self.tableView insertRowsAtIndexPaths:[[self class] indexPathArrayWithIndexSet:indexes
                                                                              inSection:0]
                              withRowAnimation:self.rowAnimation];
    
    if (self.collectionView)
        [self.collectionView insertItemsAtIndexPaths:
         [[self class] indexPathArrayWithIndexSet:indexes
                                        inSection:0]];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item {
    [self.items replaceObjectAtIndex:index withObject:item];

    if (self.tableView)
        [self.tableView reloadRowsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(NSInteger)index inSection:0]
         ]
                              withRowAnimation:self.rowAnimation];
    
    if (self.collectionView)
        [self.collectionView reloadItemsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(NSInteger)index inSection:0]
         ]];
}

- (void)moveItemAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2 {
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:(NSInteger)index1
                                                 inSection:0],
                *indexPath2 = [NSIndexPath indexPathForRow:(NSInteger)index2
                                                 inSection:0];
    
    id item = [self itemAtIndexPath:indexPath1];
    [self.items removeObject:item];
    [self.items insertObject:item atIndex:index2];
    
    if (self.tableView)
        [self.tableView moveRowAtIndexPath:indexPath1
                               toIndexPath:indexPath2];
    
    if (self.collectionView)
        [self.collectionView moveItemAtIndexPath:indexPath1
                                     toIndexPath:indexPath2];
}

- (void)removeItemsInRange:(NSRange)range {    
    [self.items removeObjectsInRange:range];
    
    if (self.tableView)
        [self.tableView deleteRowsAtIndexPaths:[[self class] indexPathArrayWithRange:range
                                                                           inSection:0]
                              withRowAnimation:self.rowAnimation];
    
    if (self.collectionView)
        [self.collectionView deleteItemsAtIndexPaths:
         [[self class] indexPathArrayWithRange:range
                                     inSection:0]];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self.items removeObjectAtIndex:index];
    
    if (self.tableView)
        [self.tableView deleteRowsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(NSInteger)index inSection:0]
         ]
                              withRowAnimation:self.rowAnimation];
    
    if (self.collectionView)
        [self.collectionView deleteItemsAtIndexPaths:@[
            [NSIndexPath indexPathForRow:(NSInteger)index inSection:0]
         ]];
}

#pragma mark - item access

- (NSIndexPath *)indexPathForItem:(id)item {
    NSUInteger row = [self.items indexOfObjectIdenticalTo:item];
  
    if (row == NSNotFound)
        return nil;
  
    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

- (NSIndexPath *)indexPathForItemWithId:(NSManagedObjectID *)itemId {
    NSUInteger row = [self.items indexOfObjectPassingTest:^BOOL(NSManagedObject *object,
                                                                NSUInteger index,
                                                                BOOL *stop) {
      return [[object objectID] isEqual:itemId];
    }];
  
    if( row == NSNotFound )
        return nil;
  
    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id item = [self itemAtIndexPath:sourceIndexPath];
    [self.items removeObject:item];
    [self.items insertObject:item atIndex:(NSUInteger)destinationIndexPath.row];
}

@end
