//
//  SSSectionedDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 8/26/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"

@interface SSSectionedDataSource ()

// Header/footer view helper
- (SSBaseHeaderFooterView *) headerFooterViewWithClass:(Class)class;

@end

@implementation SSSectionedDataSource

- (instancetype)init {
    if( ( self = [super init] ) ) {
        self.sections = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    if( ( self = [self init] ) ) {
        if( [items count] > 0 )
            [self appendSection:[SSSection sectionWithItems:items]];
    }
    
    return self;
}

- (instancetype)initWithSection:(SSSection *)section {
    if( ( self = [self init] ) ) {
        if( section )
            [self appendSection:section];
    }
  
    return self;
}

- (instancetype)initWithSections:(NSArray *)newSections {
    if( ( self = [self init] ) ) {
        if( [newSections count] > 0 )
            [self insertSections:newSections
                       atIndexes:[NSIndexSet indexSetWithIndexesInRange:
                                  NSMakeRange(0, [newSections count])]];
    }
    
    return self;
}

#pragma mark - Item access

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionAtIndex:indexPath.section] itemAtIndex:indexPath.row];
}

#pragma mark - Base data source

- (NSUInteger)numberOfSections {
  return [self.sections count];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
  return [[self sectionAtIndex:section] numberOfItems];
}

- (NSUInteger)numberOfItems {
  NSUInteger count = 0;
  
  for( SSSection *section in self.sections )
    count += [section numberOfItems];
  
  return count;
}

#pragma mark - Section access

- (SSSection *)sectionAtIndex:(NSUInteger)index {
    return (SSSection *)[self.sections objectAtIndex:index];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self titleForFooterInSection:section];
}

- (void)tableView:(UITableView *)tableView 
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
  
    id item = [self itemAtIndexPath:sourceIndexPath];
    [[self sectionAtIndex:sourceIndexPath.section].items removeObjectAtIndex:sourceIndexPath.row];
    [[self sectionAtIndex:destinationIndexPath.section].items insertObject:item
                                                                   atIndex:destinationIndexPath.row];
  
}

#pragma mark - Moving

- (void)moveSectionAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    SSSection *section = [self sectionAtIndex:fromIndex];
    
    [self.sections removeObjectAtIndex:fromIndex];
    [self.sections insertObject:section
                        atIndex:toIndex];
    
    [self.tableView moveSection:fromIndex
                      toSection:toIndex];
    [self.collectionView moveSection:fromIndex
                           toSection:toIndex];
}

#pragma mark - Adding

- (void) appendSection:(SSSection *)newSection {
    [self insertSection:newSection 
                atIndex:[self numberOfSections]];
}

- (void) insertSection:(SSSection *)newSection atIndex:(NSUInteger)index {
    [self.sections insertObject:newSection
                        atIndex:index];
    
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index]
                  withRowAnimation:self.rowAnimation];
    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:index]];
}

- (void) insertSections:(NSArray *)newSections atIndexes:(NSIndexSet *)indexes {
    NSMutableArray *mutableSections = [NSMutableArray array];
    
    [newSections enumerateObjectsUsingBlock:^(id sectionObject,
                                              NSUInteger sectionIndex,
                                              BOOL *stop) {
        if( [sectionObject isKindOfClass:[SSSection class]] )
            [mutableSections addObject:sectionObject];
        else if( [sectionObject isKindOfClass:[NSArray class]] )
            [mutableSections addObject:[SSSection sectionWithItems:sectionObject]];
        else
            NSLog(@"Invalid SSSectionedDataSource section object: %@", sectionObject);
    }];
      
    [self.sections insertObjects:mutableSections
                       atIndexes:indexes];
    
    [self.tableView insertSections:indexes
                  withRowAnimation:self.rowAnimation];
    [self.collectionView insertSections:indexes];
}

- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    [[self sectionAtIndex:indexPath.section].items insertObject:item
                                                        atIndex:indexPath.row];
    
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:self.rowAnimation];
    [self.collectionView insertItemsAtIndexPaths:@[ indexPath ]];
}

- (void)insertItems:(NSArray *)items
          atIndexes:(NSIndexSet *)indexes
          inSection:(NSUInteger)section {
    
    NSArray *indexPaths = [[self class] indexPathArrayWithIndexSet:indexes
                                                         inSection:section];
    
    [[self sectionAtIndex:section].items insertObjects:items
                                             atIndexes:indexes];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:self.rowAnimation];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)appendItems:(NSArray *)items toSection:(NSUInteger)section {
    NSUInteger sectionCount = [self numberOfItemsInSection:section];
    
    NSArray *indexPaths = [[self class] indexPathArrayWithRange:NSMakeRange(sectionCount,
                                                                            [items count])
                                                      inSection:section];
    
    [[self sectionAtIndex:section].items addObjectsFromArray:items];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:self.rowAnimation];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

#pragma mark - Removing

- (void)removeSectionAtIndex:(NSUInteger)index {
    [self.sections removeObjectAtIndex:index];
    
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                  withRowAnimation:self.rowAnimation];
    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:index]];
}

- (void)removeSectionsInRange:(NSRange)range {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [self.sections removeObjectsAtIndexes:indexes];
    
    [self.tableView deleteSections:indexes
                  withRowAnimation:self.rowAnimation];
    [self.collectionView deleteSections:indexes];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes {
    [self.sections removeObjectsAtIndexes:indexes];
    
    [self.tableView deleteSections:indexes
                  withRowAnimation:self.rowAnimation];
    [self.collectionView deleteSections:indexes];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    if( [self numberOfItemsInSection:indexPath.section] == 1 ) {
        [self removeSectionAtIndex:indexPath.section];
        return;
    }
    
    [[self sectionAtIndex:indexPath.section].items removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:self.rowAnimation];
    [self.collectionView deleteItemsAtIndexPaths:@[ indexPath ]];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section {
    if( [self numberOfItemsInSection:section] == [indexes count] ) {
        [self removeSectionAtIndex:section];
        return;
    }
    
    NSArray *indexPaths = [[self class] indexPathArrayWithIndexSet:indexes
                                                         inSection:section];
    
    [[self sectionAtIndex:section].items removeObjectsAtIndexes:indexes];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:self.rowAnimation];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

- (void)removeItemsInRange:(NSRange)range inSection:(NSUInteger)section {
    if( [self numberOfItemsInSection:section] == range.length ) {
        [self removeSectionAtIndex:section];
        return;
    }
    
    NSArray *indexPaths = [[self class] indexPathArrayWithRange:range
                                                      inSection:section];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:self.rowAnimation];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

#pragma mark - UITableViewDelegate helpers

- (SSBaseHeaderFooterView *)headerFooterViewWithClass:(Class)class {
    SSBaseHeaderFooterView *headerFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:
                                                [class identifier]];
    
    if( !headerFooterView )
        headerFooterView = [class new];
    
    return headerFooterView;
}

- (SSBaseHeaderFooterView *)viewForHeaderInSection:(NSUInteger)section {
    return [self headerFooterViewWithClass:[self sectionAtIndex:section].headerClass];
}

- (SSBaseHeaderFooterView *)viewForFooterInSection:(NSUInteger)section {
    return [self headerFooterViewWithClass:[self sectionAtIndex:section].footerClass];
}

- (CGFloat)heightForHeaderInSection:(NSUInteger)section {
    return [self sectionAtIndex:section].headerHeight;
}

- (CGFloat)heightForFooterInSection:(NSUInteger)section {
    return [self sectionAtIndex:section].footerHeight;
}

- (NSString *)titleForHeaderInSection:(NSUInteger)section {
    return [self sectionAtIndex:section].header;
}

- (NSString *)titleForFooterInSection:(NSUInteger)section {
    return [self sectionAtIndex:section].footer;
}

#pragma mark - NSIndexPath helpers

+ (NSArray *)indexPathArrayWithIndexSet:(NSIndexSet *)indexes
                              inSection:(NSUInteger)section {
    
    NSMutableArray *ret = [NSMutableArray array];
    
    [indexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [ret addObject:[NSIndexPath indexPathForRow:index inSection:section]];
    }];
    
    return ret;
}

+ (NSArray *)indexPathArrayWithRange:(NSRange)range
                           inSection:(NSUInteger)section {
    
    NSMutableArray *ret = [NSMutableArray array];
    
    for( NSUInteger i = range.location; i < NSMaxRange(range); i++ )
        [ret addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    
    return ret;
}

@end
