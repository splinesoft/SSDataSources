//
//  SSSectionedDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 8/26/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"

@interface SSSectionedDataSource ()

- (instancetype)init;

// Header/footer view helper
- (SSBaseHeaderFooterView *)headerFooterViewWithClass:(Class)class;

@end

@implementation SSSectionedDataSource

- (instancetype)init {
    if ((self = [super init])) {
        _sections = [NSMutableArray array];
        _shouldRemoveEmptySections = YES;
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    if ((self = [self init])) {
        if ([items count] > 0) {
            [self appendSection:[SSSection sectionWithItems:items]];
        }
    }
    
    return self;
}

- (instancetype)initWithSection:(SSSection *)section {
    if ((self = [self init])) {
        if (section) {
            [self appendSection:section];
        }
    }
  
    return self;
}

- (instancetype)initWithSections:(NSArray *)newSections {
    if ((self = [self init])) {
        if ([newSections count] > 0) {
            [self insertSections:newSections
                       atIndexes:[NSIndexSet indexSetWithIndexesInRange:
                                  NSMakeRange(0, [newSections count])]];
        }
    }
    
    return self;
}

#pragma mark - SSDataSourceItemAccess

- (NSUInteger)numberOfSections {
    return (self.currentFilter
            ? [self.currentFilter numberOfSections]
            :  [self.sections count]);
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return (self.currentFilter
            ? [self.currentFilter numberOfItemsInSection:section]
            : [[self sectionAtIndex:section] numberOfItems]);
}

- (NSUInteger)numberOfItems {
    if (self.currentFilter) {
        return [self.currentFilter numberOfItems];
    }
    
    NSUInteger count = 0;
  
    for (SSSection *section in self.sections) {
        count += [section numberOfItems];
    }
  
    return count;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return (self.currentFilter
            ? [self.currentFilter itemAtIndexPath:indexPath]
            : [[self sectionAtIndex:indexPath.section] itemAtIndex:indexPath.row]);
}

#pragma mark - Section access

- (SSSection *)sectionAtIndex:(NSUInteger)index {
    return (SSSection *)[self.sections objectAtIndex:index];
}

- (SSSection *)sectionWithIdentifier:(id)identifier {
    NSUInteger index = [self indexOfSectionWithIdentifier:identifier];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    return [self sectionAtIndex:index];
}

- (NSUInteger)indexOfSectionWithIdentifier:(id)identifier {
    return [self.sections indexOfObjectPassingTest:^BOOL(SSSection *section,
                                                         NSUInteger index,
                                                         BOOL *stop) {
        return [(id)section.sectionIdentifier isEqual:identifier];
    }];
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
    
    [self moveSectionAtIndex:fromIndex toIndex:toIndex];
}

#pragma mark - Adding

- (void) appendSection:(SSSection *)newSection {
    [self insertSection:newSection 
                atIndex:[self numberOfSections]];
}

- (void) insertSection:(SSSection *)newSection atIndex:(NSUInteger)index {
    [self.sections insertObject:newSection
                        atIndex:index];
    
    [self insertSectionsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void) insertSections:(NSArray *)newSections atIndexes:(NSIndexSet *)indexes {
    NSMutableArray *mutableSections = [NSMutableArray array];
    
    [newSections enumerateObjectsUsingBlock:^(id sectionObject,
                                              NSUInteger sectionIndex,
                                              BOOL *stop) {
        if ([sectionObject isKindOfClass:[SSSection class]])
            [mutableSections addObject:sectionObject];
        else if ([sectionObject isKindOfClass:[NSArray class]])
            [mutableSections addObject:[SSSection sectionWithItems:sectionObject]];
        else
            NSLog(@"Invalid SSSectionedDataSource section object: %@", sectionObject);
    }];
      
    [self.sections insertObjects:mutableSections
                       atIndexes:indexes];
    
    [self insertSectionsAtIndexes:indexes];
}

- (void)insertItem:(id)item atIndexPath:(NSIndexPath *)indexPath {
    [[self sectionAtIndex:indexPath.section].items insertObject:item
                                                        atIndex:indexPath.row];
    
    [self insertCellsAtIndexPaths:@[ indexPath ]];
}

- (void)insertItems:(NSArray *)items
          atIndexes:(NSIndexSet *)indexes
          inSection:(NSUInteger)section {
    
    [[self sectionAtIndex:section].items insertObjects:items
                                             atIndexes:indexes];
    
    [self insertCellsAtIndexPaths:[self.class indexPathArrayWithIndexSet:indexes
                                                               inSection:section]];
}

- (void)appendItems:(NSArray *)items toSection:(NSUInteger)section {
    NSUInteger sectionCount = [self numberOfItemsInSection:section];
    
    [[self sectionAtIndex:section].items addObjectsFromArray:items];
    
    [self insertCellsAtIndexPaths:[self.class indexPathArrayWithRange:NSMakeRange(sectionCount,
                                                                                  [items count])
                                                            inSection:section]];
}

#pragma mark - Replacing

- (void)replaceItemAtIndexPath:(NSIndexPath *)indexPath withItem:(id)item {
    
    [[self sectionAtIndex:indexPath.section].items removeObjectAtIndex:indexPath.row];
    [[self sectionAtIndex:indexPath.section].items insertObject:item
                                                        atIndex:indexPath.row];
    
    [self reloadCellsAtIndexPaths:@[ indexPath ]];
}

#pragma mark - Removing

- (void)clearSections {
    [self.sections removeAllObjects];
    [self reloadData];
}

- (void)removeAllSections {
    [self clearSections];
}

- (void)removeSectionAtIndex:(NSUInteger)index {
    [self removeSectionsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)removeSectionsInRange:(NSRange)range {
    [self removeSectionsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
}

- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes {
    [self.sections removeObjectsAtIndexes:indexes];
    [self deleteSectionsAtIndexes:indexes];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    [self removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:indexPath.row]
                     inSection:indexPath.section];
}

- (void)removeItemsInRange:(NSRange)range inSection:(NSUInteger)section {
    [self removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]
                     inSection:section];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section {
    [[self sectionAtIndex:section].items removeObjectsAtIndexes:indexes];
    
    if (self.shouldRemoveEmptySections && [self numberOfItemsInSection:section] == 0) {
        [self removeSectionAtIndex:section];
    } else {
        [self deleteCellsAtIndexPaths:[self.class indexPathArrayWithIndexSet:indexes
                                                                   inSection:section]];
    }
}

#pragma mark - UITableViewDelegate helpers

- (SSBaseHeaderFooterView *)headerFooterViewWithClass:(Class)class {
    SSBaseHeaderFooterView *headerFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:
                                                [class identifier]];
    
    if (!headerFooterView)
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

@end
