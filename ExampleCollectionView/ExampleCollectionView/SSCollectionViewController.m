//
//  SSViewController.m
//  ExampleCollectionView
//
//  Created by Jonathan Hersh on 6/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSCollectionViewController.h"
#import <SSDataSources.h>
#import "SSSolidColorCollectionCell.h"

@interface SSCollectionViewController ()
- (void) addItem;
- (void) removeItem;
@end

@implementation SSCollectionViewController {
    SSArrayDataSource *dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addItem)],
        
        [[UIBarButtonItem alloc] initWithTitle:@"Remove Cell"
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(removeItem)],
                                               
    ];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[SSSolidColorCollectionCell class]
            forCellWithReuseIdentifier:[SSSolidColorCollectionCell identifier]];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for( NSUInteger i = 0; i < 15; i++ )
        [items addObject:@( arc4random_uniform( 10000 ) )];
    
    dataSource = [[SSArrayDataSource alloc] initWithItems:items];
    dataSource.cellClass = [SSSolidColorCollectionCell class];
    dataSource.cellConfigureBlock = ^(SSSolidColorCollectionCell *cell, NSNumber *number ) {
        cell.label.text = [number stringValue];
    };
    dataSource.collectionView = self.collectionView;
    
    self.collectionView.dataSource = dataSource;
}

- (void)addItem {
    [dataSource appendItem:@( arc4random_uniform( 10000 ))];
}

- (void)removeItem {
    if( [dataSource numberOfItems] > 0 )
        [dataSource removeItemAtIndex:(arc4random_uniform([dataSource numberOfItems]))];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *item = [dataSource itemAtIndexPath:indexPath];
    
    NSLog(@"selected item %@", item );
}

@end
