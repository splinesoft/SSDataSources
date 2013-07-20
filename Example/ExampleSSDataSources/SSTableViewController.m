//
//  SSViewController.m
//  ExampleTable
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSTableViewController.h"
#import <SSDataSources.h>

@interface SSTableViewController () <UITableViewDataSource>
- (void) addRow;
- (void) toggleEditing;
@end

@implementation SSTableViewController {
    SSArrayDataSource *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = @[ [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(toggleEditing)],
                                                 [[UIBarButtonItem alloc]
                                                  initWithTitle:@"Add Row"
                                                  style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(addRow)]
                                               ];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for( NSUInteger i = 0; i < 5; i++ )
        [items addObject:@( arc4random_uniform( 10000 ) )];
    
    dataSource = [[SSArrayDataSource alloc] initWithItems:items];
    dataSource.tableView = self.tableView;
    dataSource.rowAnimation = UITableViewRowAnimationRight;
    dataSource.fallbackTableDataSource = self;
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSNumber *number) {
        cell.textLabel.text = [number stringValue];
    };
    
    self.tableView.dataSource = dataSource;
}

#pragma mark - actions

- (void)addRow {
    [dataSource appendItem:@( arc4random_uniform( 10000 ) )];
}

- (void)toggleEditing {
    [self.tableView setEditing:![self.tableView isEditing]
                      animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:( [self.tableView isEditing]
                                                                            ? UIBarButtonSystemItemDone
                                                                            : UIBarButtonSystemItemEdit )
                                              target:self
                                              action:@selector(toggleEditing)];
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
        [dataSource removeItemAtIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *item = [dataSource itemAtIndexPath:indexPath];
    
    NSLog(@"selected item %@", item);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
