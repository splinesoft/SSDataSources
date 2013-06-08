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
    SSTableArrayDataSource *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Row"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(addRow)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove Row"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(removeRow)];
    
    dataSource = [[SSTableArrayDataSource alloc] initWithItems:@[ @1337, @1242, @1389 ]];
    dataSource.tableView = self.tableView;
    dataSource.rowAnimation = UITableViewRowAnimationFade;
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSNumber *number) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", number];
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
