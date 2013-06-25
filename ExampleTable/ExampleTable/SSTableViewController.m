//
//  SSViewController.m
//  ExampleTable
//
//  Created by Jonathan Hersh on 6/8/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSTableViewController.h"
#import <SSDataSources.h>

@interface SSTableViewController ()
- (void) addRow;
- (void) removeRow;
@end

@implementation SSTableViewController {
    SSArrayDataSource *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithTitle:@"Add Row"
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(addRow)],
    
        [[UIBarButtonItem alloc] initWithTitle:@"Remove Row"
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(removeRow)],
      ];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for( NSUInteger i = 0; i < 5; i++ )
        [items addObject:@(arc4random() % 10000)];
    
    dataSource = [[SSArrayDataSource alloc] initWithItems:items];
    dataSource.tableView = self.tableView;
    dataSource.rowAnimation = UITableViewRowAnimationFade;
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSNumber *number) {
        cell.textLabel.text = [number stringValue];
    };
    
    self.tableView.dataSource = dataSource;
}

#pragma mark - actions

- (void)addRow {
    [dataSource appendItems:@[ @( arc4random() % 10000 ) ]];
}

- (void)removeRow {
    if( [dataSource numberOfItems] > 0 )
        [dataSource removeItemAtIndex:( arc4random() % [dataSource numberOfItems] )];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected item %@", [dataSource itemAtIndexPath:indexPath]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
