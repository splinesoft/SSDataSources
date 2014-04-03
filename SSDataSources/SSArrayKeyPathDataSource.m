//
//  SSArrayKeyPathDataSource.m
//  SSDataSources
//
//  Created by Andrew Sardone on 4/3/14.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSArrayKeyPathDataSource.h"

static void *SSArrayKeyPathDataSourceContext = &SSArrayKeyPathDataSourceContext;

@interface SSArrayKeyPathDataSource ()

@property (nonatomic, weak) id source;
@property (nonatomic, copy) NSString *keyPath;

@property (nonatomic, readonly) NSArray *itemsAtKeyPath;

@end

@implementation SSArrayKeyPathDataSource

- (instancetype)initWithSource:(id)source keyPath:(NSString *)keyPath {
    if ((self = [self init])) {
        self.source = source;
        self.keyPath = keyPath;

        [self.source addObserver:self
                      forKeyPath:self.keyPath
                         options:NSKeyValueObservingOptionInitial
                         context:&SSArrayKeyPathDataSourceContext];
    }
    return self;
}

- (void)dealloc {
    [self.source removeObserver:self
                     forKeyPath:self.keyPath
                        context:&SSArrayKeyPathDataSourceContext];
}

#pragma mark - Base Data source

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return nil;
    }

    if (indexPath.row < (NSInteger)[self.itemsAtKeyPath count]) {
        return self.itemsAtKeyPath[(NSUInteger)indexPath.row];
    }

    return nil;
}

- (NSUInteger)numberOfItems {
    return [self.itemsAtKeyPath count];
}

- (NSUInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    return [self numberOfItems];
}

#pragma mark SSArrayItemAccess

- (NSIndexPath *)indexPathForItem:(id)item {
    NSUInteger row = [self.itemsAtKeyPath indexOfObjectIdenticalTo:item];

    if (row == NSNotFound) {
        return nil;
    }

    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

- (NSIndexPath *)indexPathForItemWithId:(NSManagedObjectID *)itemId {
    NSUInteger row = [self.itemsAtKeyPath indexOfObjectPassingTest:^BOOL(NSManagedObject *object,
                                                                NSUInteger index,
                                                                BOOL *stop) {
      return [[object objectID] isEqual:itemId];
    }];

    if (row == NSNotFound) {
        return nil;
    }

    return [NSIndexPath indexPathForRow:(NSInteger)row inSection:0];
}

#pragma mark - Private

- (NSArray *)itemsAtKeyPath {
    return [self.source valueForKeyPath:self.keyPath];
}

#pragma mark Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == SSArrayKeyPathDataSourceContext && [keyPath isEqualToString:self.keyPath]) {
        NSKeyValueChange changeKind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
        NSMutableArray *indexPaths = ({
            NSMutableArray *indexPaths = [NSMutableArray array];
            NSIndexSet *indexes = change[NSKeyValueChangeIndexesKey];
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }];
            indexPaths;
        });
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
            default:
                break;
        }
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
