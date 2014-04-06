//
//  SSArrayDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"
#import <CoreData/CoreData.h>

static void *SSArrayKeyPathDataSourceContext = &SSArrayKeyPathDataSourceContext;

@interface SSArrayDataSource ()

/**
 * The array that was given to the receiver in -initWithItems:
 */
@property (nonatomic, copy) NSArray *internalItems;

/**
 * The object that the receiver is observing at the given key path when initialized
 * via -initwithitems:.
 */
@property (nonatomic, unsafe_unretained) id target;

/**
 * The key path for an NSArray off of target the receiver is initialized via
 * -initwithitems:.
 */
@property (nonatomic, copy) NSString *keyPath;

@end

@implementation SSArrayDataSource

- (instancetype)initWithItems:(NSArray *)anItems {
    if ((self = [self init])) {
        self.internalItems = anItems ?: @[];

        self.target = self;
        self.keyPath = @"internalItems";

        [self registerKVO];
    }
  
    return self;
}

- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath {
    if ((self = [self init])) {
        self.target = target;
        self.keyPath = keyPath;
        [self registerKVO];
    }
    return self;
}

- (void)dealloc {
    [self unregisterKVO];
}

#pragma mark - Internal mutable items

/**
 * An NSMutableArray proxy for whatever source array is backing the receiver
 * data source.
 */
- (NSMutableArray *)items {
    return [self.target mutableArrayValueForKey:self.keyPath];
}

#pragma mark - Base Data source

- (NSUInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return [self numberOfItems];
}

- (NSUInteger)numberOfItems {
    return [self.items count];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
  
    if (indexPath.row < (NSInteger)[self.items count]) {
        return self.items[(NSUInteger)indexPath.row];
    }
  
    return nil;
}

#pragma mark - updating items

- (void)clearItems {
    [self.items removeAllObjects];
    [self reloadData];
}

- (void)removeAllItems {
    [self clearItems];
}

- (void)updateItems:(NSArray *)newItems {
    [self.items replaceObjectsInRange:NSMakeRange(0, self.items.count) withObjectsFromArray:newItems];
    [self reloadData];
}

- (NSArray *)allItems {
    return self.items;
}

- (void)appendItem:(id)item {
    [self appendItems:@[ item ]];
}

- (void)appendItems:(NSArray *)newItems {
    if ([newItems count] == 0) {
        return;
    }
    
    NSUInteger count = [self numberOfItems];
    NSRange newItemsRange = NSMakeRange(count, [newItems count]);

    [self.items insertObjects:newItems
                    atIndexes:[NSIndexSet indexSetWithIndexesInRange:newItemsRange]];
}

- (void)insertItem:(id)item atIndex:(NSUInteger)index {
    [self insertItems:@[ item ]
            atIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)insertItems:(NSArray *)newItems atIndexes:(NSIndexSet *)indexes {
    if ([newItems count] == 0 || [newItems count] != [indexes count]) {
        return;
    }
    
    [self.items insertObjects:newItems atIndexes:indexes];
}

- (void)replaceItemAtIndex:(NSUInteger)index withItem:(id)item {
    [self.items replaceObjectAtIndex:index withObject:item];
}

- (void)moveItemAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2 {
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:(NSInteger)index1
                                                 inSection:0],
                *indexPath2 = [NSIndexPath indexPathForRow:(NSInteger)index2
                                                 inSection:0];
    
    id item = [self itemAtIndexPath:indexPath1];
    [self unregisterKVO];
    [self.items removeObject:item];
    [self.items insertObject:item atIndex:index2];
    
    [self moveCellAtIndexPath:indexPath1
                  toIndexPath:indexPath2];
    [self registerKVO];
}

- (void)removeItemsInRange:(NSRange)range {
    [self.items removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self.items removeObjectAtIndex:index];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes {
    [self.items removeObjectsAtIndexes:indexes];
}

#pragma mark - item access

- (NSIndexPath *)indexPathForItem:(id)item {
    NSUInteger row = [self.items indexOfObjectIdenticalTo:item];
  
    if (row == NSNotFound) {
        return nil;
    }
  
    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

- (NSIndexPath *)indexPathForItemWithId:(NSManagedObjectID *)itemId {
    NSUInteger row = [self.items indexOfObjectPassingTest:^BOOL(NSManagedObject *object,
                                                                NSUInteger index,
                                                                BOOL *stop) {
      return [[object objectID] isEqual:itemId];
    }];
  
    if (row == NSNotFound) {
        return nil;
    }
  
    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id item = [self itemAtIndexPath:sourceIndexPath];
    [self unregisterKVO];
    [self.items removeObject:item];
    [self.items insertObject:item
                     atIndex:(NSUInteger)destinationIndexPath.row];
    [self registerKVO];
}

#pragma mark Key-value observing

- (void)registerKVO {
    [self.target addObserver:self
                  forKeyPath:self.keyPath
                     options:NSKeyValueObservingOptionInitial
                     context:&SSArrayKeyPathDataSourceContext];
}

- (void)unregisterKVO {
    [self.target removeObserver:self
                     forKeyPath:self.keyPath
                        context:&SSArrayKeyPathDataSourceContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == SSArrayKeyPathDataSourceContext && [keyPath isEqualToString:self.keyPath]) {
        NSKeyValueChange changeKind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        NSArray *indexPaths = [self.class indexPathArrayWithIndexSet:change[NSKeyValueChangeIndexesKey]
                                                           inSection:0];
        switch (changeKind) {
            case NSKeyValueChangeInsertion:
                [self insertCellsAtIndexPaths:indexPaths];
                break;
            case NSKeyValueChangeRemoval:
                [self deleteCellsAtIndexPaths:indexPaths];
                break;
            case NSKeyValueChangeReplacement:
                [self reloadCellsAtIndexPaths:indexPaths];
                break;
            case NSKeyValueChangeSetting:
                break;
            default:
                break;
        }
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
