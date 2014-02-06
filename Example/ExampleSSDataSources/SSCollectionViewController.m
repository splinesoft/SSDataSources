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
#import "SSCollectionViewSectionHeader.h"

@interface SSCollectionViewController ()
- (void) addItem;
- (void) removeItem;
@end

@implementation SSCollectionViewController {
    SSArrayDataSource *dataSource;
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.sectionInset = UIEdgeInsetsMake( 5, 5, 5, 5 );
    layout.itemSize = CGSizeMake(70, 50);
    layout.headerReferenceSize = CGSizeMake( 320, 40 );
    layout.footerReferenceSize = CGSizeMake( 320, 40 );
    
    if( ( self = [self initWithCollectionViewLayout:layout] ) ) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = @[
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
    [self.collectionView registerClass:[SSCollectionViewSectionHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[SSCollectionViewSectionHeader identifier]];
    [self.collectionView registerClass:[SSCollectionViewSectionHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:[SSCollectionViewSectionHeader identifier]];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for( NSUInteger i = 0; i < 15; i++ )
        [items addObject:@( arc4random_uniform( 10000 ) )];
    
    dataSource = [[SSArrayDataSource alloc] initWithItems:items];
    dataSource.cellClass = [SSSolidColorCollectionCell class];
    dataSource.collectionViewSupplementaryElementClass = [SSCollectionViewSectionHeader class];
    dataSource.cellConfigureBlock = ^(SSSolidColorCollectionCell *cell, 
                                      NSNumber *number, 
                                      UICollectionView *collectionView,
                                      NSIndexPath *ip ) {
        cell.label.text = [number stringValue];
    };
    dataSource.collectionSupplementaryConfigureBlock = ^(SSCollectionViewSectionHeader *header,
                                                         NSString *kind,
                                                         UICollectionView *collectionView,
                                                         NSIndexPath *indexPath) {
        header.label.text = ( [kind isEqualToString:UICollectionElementKindSectionHeader]
                              ? @"A section header"
                              : @"A section footer" );
    };
    
    dataSource.collectionView = self.collectionView;
    
    UILabel *noItemsLabel = [UILabel new];
    noItemsLabel.text = @"No Items";
    noItemsLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    noItemsLabel.textAlignment = NSTextAlignmentCenter;
    
    dataSource.emptyView = noItemsLabel;
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
