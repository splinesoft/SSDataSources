//
//  SSBaseDataSource.m
//  SSDataSources
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"

@implementation SSBaseDataSource

#pragma mark - init

- (instancetype)init {
    if ((self = [super init])) {
        self.cellClass = [SSBaseTableCell class];
        self.collectionViewSupplementaryElementClass = [SSBaseCollectionReusableView class];
        self.rowAnimation = UITableViewRowAnimationAutomatic;
    }
    
    return self;
}

- (void)dealloc {
    self.cellConfigureBlock = nil;
    self.cellCreationBlock = nil;
    self.collectionSupplementaryConfigureBlock = nil;
    self.collectionSupplementaryCreationBlock = nil;
    self.tableActionBlock = nil;
    self.tableDeletionBlock = nil;
}

#pragma mark - item access

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    // override me!
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:
                                           @"Did you forget to override %@?",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSUInteger)numberOfItems {
    // override me!
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:
                                           @"Did you forget to override %@?",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSUInteger)numberOfSections {
    // override me!
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:
                                          @"Did you forget to override %@?",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section {
    // override me!
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:
                                           @"Did you forget to override %@?",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark - UITableViewDataSource

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    if (tableView)
        tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    id item = [self itemAtIndexPath:indexPath];
    id cell;
    
    if (self.cellCreationBlock)
        cell = self.cellCreationBlock( item, tv, indexPath );
    else
        cell = [self.cellClass cellForTableView:tv];

    if (self.cellConfigureBlock)
        self.cellConfigureBlock( cell, item, tv, indexPath );
    
    return cell;    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableActionBlock) {
        return self.tableActionBlock(tv,
                                     indexPath,
                                     SSCellActionTypeMove);
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableActionBlock) {
        return self.tableActionBlock(tv,
                                     indexPath,
                                     SSCellActionTypeEdit);
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tv
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.tableDeletionBlock) {
        self.tableDeletionBlock(tv,
                                indexPath,
                                self);
    }
}

#pragma mark - UICollectionViewDataSource

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    
    if (collectionView)
        collectionView.dataSource = self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = [self itemAtIndexPath:indexPath];
    id cell;
    
    if (self.cellCreationBlock)
        cell = self.cellCreationBlock( item, cv, indexPath );
    else
        cell = [self.cellClass cellForCollectionView:cv
                                           indexPath:indexPath];
    
    if (self.cellConfigureBlock)
        self.cellConfigureBlock( cell, item, cv, indexPath );
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  
    return [self numberOfItemsInSection:section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)cv
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *supplementaryView;
    
    if (self.collectionSupplementaryCreationBlock)
        supplementaryView = self.collectionSupplementaryCreationBlock( cv, kind, indexPath );
    else
        supplementaryView = [self.collectionViewSupplementaryElementClass
                             supplementaryViewForCollectionView:cv
                             kind:kind
                             indexPath:indexPath];
            
    if (self.collectionSupplementaryConfigureBlock)
        self.collectionSupplementaryConfigureBlock( supplementaryView, cv, kind, indexPath );

    return supplementaryView;
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
    
    for (NSUInteger i = range.location; i < NSMaxRange(range); i++)
        [ret addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    
    return ret;
}

@end
