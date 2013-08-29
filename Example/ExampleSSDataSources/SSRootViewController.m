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

typedef NS_ENUM( NSUInteger, SSDataSourcesExample ) {
    SSDataSourcesExampleTable,
    SSDataSourcesExampleSectionedTable,
    SSDataSourcesExampleCollectionView,
};

@implementation SSRootViewController {
    SSArrayDataSource *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SSDataSources", nil);
    
    dataSource = [[SSArrayDataSource alloc] initWithItems:@[
                    @(SSDataSourcesExampleTable),
                    @(SSDataSourcesExampleSectionedTable),
                    @(SSDataSourcesExampleCollectionView)
                 ]];
    
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, 
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
            default:
                break;
        }
        
        cell.textLabel.text = title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    
    self.tableView.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    SSDataSourcesExample example = [[dataSource itemAtIndexPath:indexPath] unsignedIntegerValue];
    
    switch( example ) {
        case SSDataSourcesExampleTable:
            viewController = [SSTableViewController new];
            break;
        case SSDataSourcesExampleCollectionView:
            viewController = [SSCollectionViewController new];
            break;
        case SSDataSourcesExampleSectionedTable:
            viewController = [SSSectionedViewController new];
            break;
        default:
            break;
    }
    
    if( viewController )
        [self.navigationController pushViewController:viewController
                                             animated:YES];
}

@end
