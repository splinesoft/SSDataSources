//
//  SSBaseDataSource.m
//  SSPods
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"

@implementation SSBaseDataSource

@synthesize cellConfigureBlock, cellClass, fallbackDataSource, tableView, rowAnimation;

#pragma mark - init

- (instancetype)init {
    if( ( self = [super init] ) ) {
        self.cellClass = [SSBaseTableCell class];
        self.rowAnimation = UITableViewRowAnimationNone;
    }
    
    return self;
}

- (void)dealloc {
    self.cellConfigureBlock = nil;
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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SSBaseTableCell *cell = [self.cellClass cellForTableView:tv];
    
    id item = [self itemAtIndexPath:indexPath];
    
    if( self.cellConfigureBlock )
        self.cellConfigureBlock( cell, item );
    
    return cell;    
}

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if( [self.fallbackDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)] )
        return [self.fallbackDataSource tableView:tv canEditRowAtIndexPath:indexPath];
    
    return NO;
}

- (void)tableView:(UITableView *)tv
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( [self.fallbackDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)] )
        [self.fallbackDataSource tableView:tv
                        commitEditingStyle:editingStyle
                         forRowAtIndexPath:indexPath];
    
}

@end
