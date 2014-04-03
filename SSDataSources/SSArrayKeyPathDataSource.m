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

#pragma mark - Private

- (NSArray *)itemsAtKeyPath {
    return [self.source valueForKeyPath:self.keyPath];
}

@end
