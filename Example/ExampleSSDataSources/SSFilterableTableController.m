//
//  SSFilterableTableController.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 4/2/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import "SSFilterableTableController.h"
#import <SSDataSources.h>

@interface SSFilterableTableController () <UISearchBarDelegate>

@property (nonatomic, strong) SSArrayDataSource *dataSource;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SSFilterableTableController

- (id)init {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        self.title = @"Filterable Table";
        
        _dataSource = [[SSArrayDataSource alloc] initWithItems:@[
                        @"Merlyn",
                        @"Gandalf",
                        @"Melisandre",
                        @"Saruman",
                        @"Rudess",
                        @"Novum",
                        @"Alatar",
                        @"Pallando",
                      ]];
        self.dataSource.rowAnimation = UITableViewRowAnimationFade;
        self.dataSource.tableActionBlock = ^BOOL(SSCellActionType action,
                                                 UITableView *tableView,
                                                 NSIndexPath *indexPath) {
            
            // we allow both moving and deleting.
            // You could instead do something like
            // return (action == SSCellActionTypeMove);
            // to only allow moving and disallow deleting.
            
            return YES;
        };
        self.dataSource.tableDeletionBlock = ^(SSArrayDataSource *aDataSource,
                                               UITableView *tableView,
                                               NSIndexPath *indexPath) {
            
            [aDataSource removeItemAtIndex:(NSUInteger)indexPath.row];
        };
        self.dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell,
                                               NSString *wizard,
                                               UITableView *tableView,
                                               NSIndexPath *ip ) {
            cell.textLabel.text = wizard;
        };
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44)];
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    
    self.dataSource.tableView = self.tableView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *item = [self.dataSource itemAtIndexPath:indexPath];
    
    NSLog(@"selected item %@", item);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        [self.dataSource clearFilterPredicate];
    } else {
        [self.dataSource setFilterPredicate:^BOOL(NSString *wizard) {
            return [wizard rangeOfString:searchText
                                 options:NSCaseInsensitiveSearch].location != NSNotFound;
        }];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    [self.searchBar setText:nil];
    [self.dataSource clearFilterPredicate];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

@end
