//
//  SSExpandingViewController.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 11/26/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import "SSExpandingViewController.h"
#import <SSDataSources.h>

@interface SSExpandingViewController ()

@property (nonatomic, strong) SSExpandingDataSource *dataSource;

@end

@implementation SSExpandingViewController

- (instancetype)init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        self.title = @"Expanding Table";
        
        _dataSource = [[SSExpandingDataSource alloc] initWithItems:nil];
        self.dataSource.rowAnimation = UITableViewRowAnimationRight;
        self.dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell,
                                               id item,
                                               UITableView *tableView,
                                               NSIndexPath *indexPath) {
            if ([item isKindOfClass:[NSString class]]) {
                cell.textLabel.text = item;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor darkGrayColor];
            } else {
                cell.textLabel.text = [item stringValue];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor redColor];
            }
        };
        self.dataSource.collapsedSectionCountBlock = ^NSInteger(SSSection *section,
                                                                NSInteger sectionIndex) {
            // Section 0 collapses to 1 item, section 1 to 2 items...
            return 1 + sectionIndex;
        };
        
        for (NSUInteger i = 0; i < 3; i++) {
            [self.dataSource appendSection:
             [SSSection sectionWithItems:@[ [NSString stringWithFormat:@"Tap to Toggle (%@ row%@)",
                                             @(1 + i),
                                             (1 + i != 1 ? @"s" : @"")],
                                            @2, @3, @4 ]]];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource.tableView = self.tableView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self.dataSource toggleSectionAtIndex:indexPath.section];
    }
}

@end
