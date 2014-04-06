//
//  SSArrayDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/7/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"
#import <CoreData/CoreData.h>

/**
 * An internal container to hold the raw items that are handed to SSArrayDataSource
 * that can then be KVO'd for changes and manipulation.
 *
 * See https://github.com/splinesoft/SSDataSources/pull/29 & -[SSArrayDataSource initWithItems:]
 */
@interface SSArrayDataSourceItemsContainer : NSObject

@property (nonatomic, copy) NSArray *items;

- (instancetype)initWithItems:(NSArray *)items;

@end

@implementation SSArrayDataSourceItemsContainer

- (instancetype)initWithItems:(NSArray *)items {
    if ((self = [self init])) {
        self.items = items;
    }
    
    return self;
}

@end

#pragma mark -

static void *SSArrayKeyPathDataSourceContext = &SSArrayKeyPathDataSourceContext;

@interface SSArrayDataSource ()

/**
 * The object that the receiver is observing at the given key path when initialized
 * via -initwithitems:.
 */
@property (nonatomic, strong) id target;

/**
 * The key path for an NSArray off of target the receiver is initialized via
 * -initwithitems:.
 */
@property (nonatomic, copy) NSString *keyPath;

@end

@implementation SSArrayDataSource

- (instancetype)initWithItems:(NSArray *)anItems {
    return [self initWithTarget:[[SSArrayDataSourceItemsContainer alloc] initWithItems:anItems]
                        keyPath:NSStringFromSelector(@selector(items))];
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

#pragma mark - Item access

- (NSUInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return [self numberOfItems];
}

- (NSUInteger)numberOfItems {
    return (self.currentFilter
            ? [self.currentFilter numberOfItems]
            : [self.items count]);
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    if (self.currentFilter) {
        return [self.currentFilter itemAtIndexPath:indexPath];
    }
  
    if (indexPath.row < (NSInteger)[self.items count]) {
        return self.items[(NSUInteger)indexPath.row];
    }
  
    return nil;
}

#pragma mark - Updating items

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

#pragma mark - Adding Items

- (void)appendItem:(id)item {
    [self appendItems:@[ item ]];
}

- (void)appendItems:(NSArray *)newItems {
    [self insertItems:newItems
            atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self numberOfItems],
                                                                         [newItems count])]];
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

#pragma mark - Moving Items

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

#pragma mark - Removing Items

- (void)removeItemsInRange:(NSRange)range {
    [self removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    [self removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes {
    [self.items removeObjectsAtIndexes:indexes];
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
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
