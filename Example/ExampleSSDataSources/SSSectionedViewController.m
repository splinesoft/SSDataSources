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
    dataSource.fallbackTableDataSource = self;
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell,
                                      NSNumber *number,
                                      UITableView *tableView,
                                      NSIndexPath *ip ) {
        cell.textLabel.text = [number stringValue];
    };
    dataSource.tableView = self.tableView;
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

@end
