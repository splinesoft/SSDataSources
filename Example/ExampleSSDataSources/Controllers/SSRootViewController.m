//
//  SSRootViewController.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 7/20/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <SSDataSources.h>
#import "SSRootViewController.h"
#import "SSCollectionViewController.h"
#import "SSTableViewController.h"
#import "SSSectionedViewController.h"
#import "SSExpandingViewController.h"

typedef NS_ENUM( NSUInteger, SSDataSourcesExample ) {
    SSDataSourcesExampleTable,
    SSDataSourcesExampleSectionedTable,
    SSDataSourcesExampleCollectionView,
    SSDataSourcesExampleExpandingTable,
};

@interface SSRootViewController ()

@property (nonatomic, strong) SSArrayDataSource *dataSource;

@end

@implementation SSRootViewController

- (instancetype)init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = NSLocalizedString(@"SSDataSources", nil);
        
        _dataSource = [[SSArrayDataSource alloc] initWithItems:@[
                                                     @(SSDataSourcesExampleTable),
                                                     @(SSDataSourcesExampleSectionedTable),
                                                     @(SSDataSourcesExampleCollectionView),
                                                     @(SSDataSourcesExampleExpandingTable),
                                                 ]];
        
        self.dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell,
                                               NSNumber *exampleType,
                                               UITableView *tableView,
                                               NSIndexPath *indexPath) {
            NSString *title;
            
            switch( [exampleType unsignedIntegerValue] ) {
                case SSDataSourcesExampleTable:
                    title =  NSLocalizedString(@"Table View", nil);
                    break;
                case SSDataSourcesExampleCollectionView:
                    title = NSLocalizedString(@"Collection View", nil);
                    break;
                case SSDataSourcesExampleSectionedTable:
                    title = NSLocalizedString(@"Sectioned Table", nil);
                    break;
                case SSDataSourcesExampleExpandingTable:
                    title = NSLocalizedString(@"Expanding Table", nil);
                    break;
                default:
                    break;
            }
            
            cell.textLabel.text = title;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        };
        
        self.dataSource.tableActionBlock = ^BOOL(SSCellActionType action,
                                                 UITableView *tableView,
                                                 NSIndexPath *indexPath) {
            // Disallow both moving and editing.
            // You could instead do something like disallow move but allow editing:
            // return action == SSCellActionTypeEdit;
            return NO;
        };
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource.tableView = self.tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    SSDataSourcesExample example = [[self.dataSource itemAtIndexPath:indexPath] unsignedIntegerValue];
    
    switch (example) {
        case SSDataSourcesExampleTable:
            viewController = [SSTableViewController new];
            break;
        case SSDataSourcesExampleCollectionView:
            viewController = [SSCollectionViewController new];
            break;
        case SSDataSourcesExampleSectionedTable:
            viewController = [SSSectionedViewController new];
            break;
        case SSDataSourcesExampleExpandingTable:
            viewController = [SSExpandingViewController new];
            break;
        default:
            break;
    }
    
    if (viewController) {
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
}

@end
