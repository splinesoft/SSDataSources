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

@property (nonatomic, strong) SSArrayDataSource *dataSource;

- (void) addItem;
- (void) removeItem;

@end

@implementation SSCollectionViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.sectionInset = UIEdgeInsetsMake( 5, 5, 5, 5 );
    layout.itemSize = kColoredCollectionCellSize;
    layout.headerReferenceSize = CGSizeMake( 320, 40 );
    layout.footerReferenceSize = CGSizeMake( 320, 40 );
    
    if ((self = [super initWithCollectionViewLayout:layout])) {
        NSMutableArray *items = [NSMutableArray array];
        
        for( NSUInteger i = 0; i < 15; i++ )
            [items addObject:@( arc4random_uniform( 10000 ) )];
        
        _dataSource = [[SSArrayDataSource alloc] initWithItems:items];
        self.dataSource.cellClass = [SSSolidColorCollectionCell class];
        self.dataSource.collectionViewSupplementaryElementClass = [SSCollectionViewSectionHeader class];
        self.dataSource.cellConfigureBlock = ^(SSSolidColorCollectionCell *cell,
                                               NSNumber *number,
                                               UICollectionView *collectionView,
                                               NSIndexPath *ip ) {
            cell.label.text = [number stringValue];
        };
        self.dataSource.collectionSupplementaryConfigureBlock = ^(SSCollectionViewSectionHeader *header,
                                                                  NSString *kind,
                                                                  UICollectionView *collectionView,
                                                                  NSIndexPath *indexPath) {
            header.label.text = ( [kind isEqualToString:UICollectionElementKindSectionHeader]
                                 ? @"A section header"
                                 : @"A section footer" );
        };

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
    
    self.dataSource.collectionView = self.collectionView;
    
    UILabel *noItemsLabel = [UILabel new];
    noItemsLabel.text = @"No Items";
    noItemsLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    noItemsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dataSource.emptyView = noItemsLabel;
}

- (void)addItem {
    [self.dataSource appendItem:@( arc4random_uniform( 10000 ))];
}

- (void)removeItem {
    if( [self.dataSource numberOfItems] > 0 )
        [self.dataSource removeItemAtIndex:(arc4random_uniform((unsigned int)[self.dataSource numberOfItems]))];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *item = [self.dataSource itemAtIndexPath:indexPath];
    
    NSLog(@"selected item %@", item );
}

@end
