//
//  SSAppDelegate.m
//  ExampleCollectionView
//
//  Created by Jonathan Hersh on 6/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSAppDelegate.h"

@interface SSRootViewController : UITableViewController
@end

@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    id vc = [[SSRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

#pragma mark -

#import "SSCollectionViewController.h"
#import <SSDataSources/SSArrayDataSource.h>
#import <SSDataSources/SSBaseTableCell.h>
#import "SSTableViewController.h"

@interface SSRootViewController ()
@property (nonatomic, strong) SSBaseDataSource *dataSource;
@end

@implementation SSRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"SSDataSources Examples", nil);

    self.dataSource = [[SSArrayDataSource alloc] initWithItems:@[
        NSLocalizedString(@"Table View Example", nil),
        NSLocalizedString(@"Collection View Example", nil)
    ]];
    self.dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSString *title) {
        cell.textLabel.text = title;
    };
    self.tableView.dataSource = self.dataSource;
}

- (void)tableButtonTouched:(id)sender
{
    SSTableViewController *tv = [[SSTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:tv animated:YES];
}

- (void)collectionButtonTouched:(id)sender
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.sectionInset = UIEdgeInsetsMake( 10, 5, 10, 5 );
    layout.itemSize = CGSizeMake(65, 50);

    SSCollectionViewController *cv = [[SSCollectionViewController alloc] initWithCollectionViewLayout:layout];

    [self.navigationController pushViewController:cv animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) [self tableButtonTouched:nil];
    else if (indexPath.row == 1) [self collectionButtonTouched:nil];
}

@end
