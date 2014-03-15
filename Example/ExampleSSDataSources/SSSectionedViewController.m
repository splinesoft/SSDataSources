//
//  SSSectionedViewController.m
//  Example
//
//  Created by Jonathan Hersh on 8/26/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSSectionedViewController.h"
#import <SSDataSources.h>

CGFloat const kHeaderHeight = 30.0f;
CGFloat const kFooterHeight = 30.0f;

@interface SSSectionedViewController ()
- (void) addRow;
- (void) toggleEditing;

- (void) updateBarButtonItems;

+ (SSSection *) sectionWithRandomNumber;
@end

@implementation SSSectionedViewController {
    SSSectionedDataSource *dataSource;
}

- (instancetype)init {
    if( ( self = [self initWithStyle:UITableViewStyleGrouped] ) ) {
        self.title = @"Sectioned Table";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBarButtonItems];

    [self.tableView registerClass:[SSBaseHeaderFooterView class]
forHeaderFooterViewReuseIdentifier:[SSBaseHeaderFooterView identifier]];
    
    dataSource = [[SSSectionedDataSource alloc] initWithSection:
                  [[self class] sectionWithRandomNumber]];
    dataSource.rowAnimation = UITableViewRowAnimationFade;
    dataSource.tableActionBlock = ^BOOL(SSCellActionType actionType,
                                        UITableView *tableView,
                                        NSIndexPath *indexPath) {
        // we allow both moving and deleting.
        // You could instead do something like
        // return (action == SSCellActionTypeMove);
        // to only allow moving and disallow deleting.
        
        return YES;
    };
    dataSource.tableDeletionBlock = ^(SSSectionedDataSource *aDataSource,
                                      UITableView *tableView,
                                      NSIndexPath *indexPath) {
        [aDataSource removeItemAtIndexPath:indexPath];
    };
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell,
                                      NSNumber *number,
                                      UITableView *tableView,
                                      NSIndexPath *ip ) {
        cell.textLabel.text = [number stringValue];
    };
    dataSource.tableView = self.tableView;
    
    UILabel *noItemsLabel = [UILabel new];
    noItemsLabel.text = @"No Items";
    noItemsLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    noItemsLabel.textAlignment = NSTextAlignmentCenter;
    
    dataSource.emptyView = noItemsLabel;
}

+ (SSSection *)sectionWithRandomNumber {
    SSSection *section = [SSSection sectionWithItems:@[ @(arc4random_uniform(10000)) ]];
    section.headerHeight = kHeaderHeight;
    section.footerHeight = kFooterHeight;
    section.header = @"Section Header";
    section.footer = @"Section Footer";
    
    return section;
}

#pragma mark - actions

- (void)addRow {
    NSNumber *newItem = @( arc4random_uniform( 10000 ) );
    
    if( [dataSource numberOfSections] == 0 || arc4random_uniform(2) == 0 ) {
        // new section
        [dataSource appendSection:[[self class] sectionWithRandomNumber]];
    } else {
        // new row
        NSUInteger section = arc4random_uniform((unsigned int)[dataSource numberOfSections]);
        NSUInteger row = arc4random_uniform((unsigned int)[dataSource numberOfItemsInSection:section]);
        [dataSource insertItem:newItem
                   atIndexPath:[NSIndexPath indexPathForRow:(NSInteger)row
                                                  inSection:(NSInteger)section]];
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

@end
