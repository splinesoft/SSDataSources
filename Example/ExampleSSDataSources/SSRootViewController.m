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

typedef NS_ENUM( NSUInteger, SSDataSourcesExample ) {
    SSDataSourcesExampleTable,
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
                    @(SSDataSourcesExampleCollectionView)
                 ]];
    
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSNumber *exampleType) {
        NSString *title;
        
        switch( [exampleType unsignedIntegerValue] ) {
            case SSDataSourcesExampleTable:
                title =  NSLocalizedString(@"Table View Example", nil);
                break;
            case SSDataSourcesExampleCollectionView:
                title = NSLocalizedString(@"Collection View Example", nil);
                break;
            default:
                break;
        }
        
        cell.textLabel.text = title;
    };
    
    self.tableView.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController;
    SSDataSourcesExample example = [[dataSource itemAtIndexPath:indexPath] unsignedIntegerValue];
    
    switch( example ) {
        case SSDataSourcesExampleTable:
            viewController = [[SSTableViewController alloc] initWithStyle:UITableViewStylePlain];
            break;
        case SSDataSourcesExampleCollectionView:
            viewController = [[SSCollectionViewController alloc] init];
            break;
        default:
            break;
    }
    
    if( viewController )
        [self.navigationController pushViewController:viewController
                                             animated:YES];
}

@end
