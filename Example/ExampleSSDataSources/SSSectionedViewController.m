//
//  SSSectionedViewController.m
//  Example
//
//  Created by Jonathan Hersh on 8/26/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSSectionedViewController.h"
#import <SSDataSources.h>

@interface SSSectionedViewController ()
- (void) addRow;
- (void) toggleEditing;

- (void) updateBarButtonItems;
@end

@implementation SSSectionedViewController {
    SSSectionedDataSource *dataSource;
}

- (instancetype)init {
    if( ( self = [self initWithStyle:UITableViewStyleGrouped] ) ) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBarButtonItems];

    
    dataSource = [[SSSectionedDataSource alloc] initWithSection:
                  [SSSection sectionWithItems:@[ @(arc4random_uniform(10000)) ]]];
    dataSource.tableView = self.tableView;
    dataSource.rowAnimation = UITableViewRowAnimationRight;
    dataSource.fallbackTableDataSource = self;
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell,
                                      NSNumber *number,
                                      UITableView *tableView,
                                      NSIndexPath *ip ) {
        cell.textLabel.text = [number stringValue];
    };
}

#pragma mark - actions

- (void)addRow {
    NSNumber *newItem = @( arc4random_uniform( 10000 ) );
    
    if( arc4random_uniform(3) == 0 ) {
        // new section
        [dataSource appendSection:[SSSection sectionWithItems:@[ newItem ]]];
    } else {
        // new row
        NSUInteger section = arc4random_uniform([dataSource numberOfSections]);
        NSUInteger row = arc4random_uniform([dataSource numberOfItemsInSection:section]);
        [dataSource insertItem:newItem
                   atIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
}

- (void)toggleEditing {
    [self.tableView setEditing:![self.tableView isEditing]
                      animated:YES];
    
    [self updateBarButtonItems];
}

- (void)updateBarButtonItems {
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                 target:self
                                                 action:@selector(addRow)],
                                                [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:( [self.tableView isEditing]
                                                                              ? UIBarButtonSystemItemDone
                                                                              : UIBarButtonSystemItemEdit )
                                                 target:self
                                                 action:@selector(toggleEditing)]
                                                ];
}

#pragma mark - fallback UITableViewDataSource (for edit/move)

// We don't have to implement tableView:moveRowAtIndexPath:toIndexPath: - SSArrayDataSource
// does the actual move for us
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if( editingStyle == UITableViewCellEditingStyleDelete )
        [dataSource removeItemAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *item = [dataSource itemAtIndexPath:indexPath];
    
    NSLog(@"selected item %@", item);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
