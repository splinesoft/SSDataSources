//
//  SSArrayKeyPathDataSource.m
//  SSDataSources
//
//  Created by Andrew Sardone on 4/3/14.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSArrayKeyPathDataSource.h"

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
    }
    return self;
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

@end
