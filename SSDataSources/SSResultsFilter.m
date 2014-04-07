//
//  SSResultsFilter.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 4/2/14.
//
//

#import "SSResultsFilter.h"

@implementation SSResultsFilter

- (id)init {
    if ((self = [super init])) {
        _sections = [NSMutableArray new];
    }
    
    return self;
}

+ (instancetype)filterWithPredicate:(SSFilterPredicate)predicate {
    SSResultsFilter *filter = [SSResultsFilter new];
    
    filter.filterPredicate = predicate;
    
    return filter;
}

#pragma mark - Item access

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }
    
    return [self.sections[indexPath.section] objectAtIndex:indexPath.row];
}

- (NSIndexPath *)indexPathForItem:(id)item {
    __block NSIndexPath *indexPath = nil;
    
    [self enumerateItemsWithBlock:^(NSIndexPath *ip,
                                    id anItem,
                                    BOOL *stop) {
        if ([item isEqual:anItem]) {
            indexPath = [ip copy];
            *stop = YES;
        }
    }];
    
    return indexPath;
}

- (NSUInteger)numberOfSections {
    return [self.sections count];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return [self.sections[section] count];
}

- (NSUInteger)numberOfItems {
    NSUInteger count = 0;
    
    for (NSUInteger i = 0; i < [self numberOfSections]; i++) {
        count += [self numberOfItemsInSection:i];
    }
    
    return count;
}

- (void)enumerateItemsWithBlock:(SSDataSourceEnumerator)itemBlock {
    if (!itemBlock) {
        return;
    }
    
    BOOL stop = NO;
    
    for (NSInteger i = 0; i < [self numberOfSections]; i++) {
        for (NSInteger j = 0; j < [self numberOfItemsInSection:i]; j++) {
            
            id item = [self.sections[i] objectAtIndex:j];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            itemBlock(indexPath, item, &stop);
            
            if (stop) {
                return;
            }
        }
    }
}

@end
