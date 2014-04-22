#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSArrayDataSourceTests : XCTestCase
@end

@implementation SSArrayDataSourceTests
{
    UITableView *tableView;
    UICollectionView *collectionView;
}

- (void)setUp
{
    [super setUp];

    tableView = [OCMockObject niceMockForClass:UITableView.class];
    collectionView = [OCMockObject niceMockForClass:UICollectionView.class];
}

- (void)testInitializable
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:nil];
    expect(ds).toNot.beNil();
}

#pragma mark SSBaseDataSource overrides

- (void)testImplementsItemRetrieval
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];
    expect(^{
        [ds itemAtIndexPath:ip];
    }).toNot.raiseAny();
}

- (void)testImplementsCollectionViewSectionCounting
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    expect(^{
        [ds collectionView:collectionView numberOfItemsInSection:0];
    }).toNot.raiseAny();
}

#pragma mark UITableViewDataSource

- (void)testSingleTableSectionForItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar"]];
    expect([ds numberOfSectionsInTableView:nil]).to.equal(1);
}

- (void)testMapsTableRowPerItem
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar", @"baz"]];
    expect([ds tableView:tableView numberOfRowsInSection:0]).to.equal(3);
}

- (void)testMovingRowsMapsChangesToItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[ @0, @1, @3 ]];
    id initialIP = [NSIndexPath indexPathForRow:0 inSection:0];
    id destinationIP = [NSIndexPath indexPathForRow:2 inSection:0];

    expect([ds itemAtIndexPath:initialIP]).to.equal(@0);
    [ds tableView:tableView moveRowAtIndexPath:initialIP
                                   toIndexPath:destinationIP];
    expect([ds itemAtIndexPath:destinationIP]).to.equal(@0);
}

- (void)testReturnsCellForTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar", @"baz"]];
    id indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    id cell = [ds tableView:tableView cellForRowAtIndexPath:indexPath];
    expect(cell).toNot.beNil();
}

#pragma mark UICollectionViewDataSource

- (void)testSingleCollectionSectionForItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar"]];
    expect([ds numberOfSectionsInTableView:nil]).to.equal(1);
}

- (void)testMapsCollectionItemPerItem
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar", @"baz"]];
    expect([ds collectionView:collectionView numberOfItemsInSection:0]).to.equal(3);
}

#pragma mark Simple item mapping

- (void)testNumberOfItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar", @"baz"]];
    expect(ds.numberOfItems).to.equal(3);
}

- (void)testIndexPathForItem
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar", @"baz"]];
    expect([ds indexPathForItem:@"foo"]).to.equal([NSIndexPath indexPathForRow:0 inSection:0]);
    expect([ds indexPathForItem:@"bar"]).to.equal([NSIndexPath indexPathForRow:1 inSection:0]);
    expect([ds indexPathForItem:@"baz"]).to.equal([NSIndexPath indexPathForRow:2 inSection:0]);
}

#pragma mark Clearing items

- (void)testClearingTableItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] reloadData];

    [ds clearItems];
    expect(ds.numberOfItems).to.equal(0);

    [mockTableView verify];
}

- (void)testClearingCollectionItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] reloadData];

    [ds clearItems];
    expect(ds.numberOfItems).to.equal(0);

    [mockCollectionView verify];
}

#pragma mark All item retrieval and updating

- (void)testRetrievingAllItems
{
    id items = @[ @"iphone", @"ipad", @"apple" ];
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:items];
    expect(ds.allItems).to.equal(items);
}

- (void)testUpdatingAllItemsInTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@1, @2]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] reloadData];

    id newItems = @[ @"iphone", @"ipad", @"apple" ];
    [ds updateItems:newItems];

    expect(ds.allItems).to.equal(newItems);
    [mockTableView verify];
}

- (void)testUpdatingAllItemsInCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@1, @2]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] reloadData];

    id newItems = @[ @"iphone", @"ipad", @"apple" ];
    [ds updateItems:newItems];

    expect(ds.allItems).to.equal(newItems);
    [mockCollectionView verify];
}

#pragma mark Appending items

- (void)testAppendSingleItem
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar"]];
    expect(ds.numberOfItems).to.equal(2);
    [ds appendItem:@"baz"];
    expect(ds.numberOfItems).to.equal(3);
}

- (void)testAppendingMultipleItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar"]];
    expect(ds.numberOfItems).to.equal(2);
    [ds appendItems:@[@"baz", @"biz"]];
    expect(ds.numberOfItems).to.equal(4);
}

- (void)testAppendingItemsInsertsRowsIntoDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                                  withRowAnimation:ds.rowAnimation];
    [ds appendItem:@"baz"];

    [mockTableView verify];
}

- (void)testAppendingItemsInsertsRowsIntoDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"bar"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]];
    [ds appendItem:@"baz"];

    [mockCollectionView verify];
}

#pragma mark Inserting items

- (void)testInsertingItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    [ds insertItems:@[@"baz"] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    expect(ds.allItems).to.equal((@[@"baz", @"foo"]));
}

- (void)testInsertingItemsInsertsRowsIntoDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                  withRowAnimation:ds.rowAnimation];

    [ds insertItems:@[@"baz"] atIndexes:[NSIndexSet indexSetWithIndex:0]];

    [mockTableView verify];
}

- (void)testInsertingItemsInsertsItemsIntoDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];

    [ds insertItems:@[@"baz"] atIndexes:[NSIndexSet indexSetWithIndex:0]];

    [mockCollectionView verify];
}

#pragma mark Replacing items

- (void)testReplacingItems
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz"]];
    [ds replaceItemAtIndex:0 withItem:@"iphone"];
    expect(ds.allItems).to.equal((@[@"iphone", @"baz"]));
}

- (void)testReplacingItemsReloadsRowsInDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                  withRowAnimation:ds.rowAnimation];

    [ds replaceItemAtIndex:0 withItem:@"iphone"];

    [mockTableView verify];
}

- (void)testReplacingItemsReloadsItemsInDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];

    [ds replaceItemAtIndex:0 withItem:@"iphone"];

    [mockCollectionView verify];
}

#pragma mark Removing items

- (void)testRemoveItemsInRange
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    [ds removeItemsInRange:NSMakeRange(1, 2)];
    expect(ds.allItems).to.equal((@[@"foo"]));
}

- (void)testRemovingItemsInRangeDeletesRowsInDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],
                                                     [NSIndexPath indexPathForRow:2 inSection:0]]
                                  withRowAnimation:ds.rowAnimation];

    [ds removeItemsInRange:NSMakeRange(1, 2)];

    [mockTableView verify];
}

- (void)testRemovingItemsInRangeDeletesItemsInDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],
                                                           [NSIndexPath indexPathForRow:2 inSection:0]]];

    [ds removeItemsInRange:NSMakeRange(1, 2)];

    [mockCollectionView verify];
}

- (void)testRemoveItemAtIndex
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    [ds removeItemAtIndex:1];
    expect(ds.allItems).to.equal((@[@"foo", @"bar"]));
}

- (void)testRemovingItemsAtIndexDeletesRowInDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
                                  withRowAnimation:ds.rowAnimation];

    [ds removeItemAtIndex:1];

    [mockTableView verify];
}

- (void)testRemovingItemsAtIndexDeletesItemInDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];

    [ds removeItemAtIndex:1];

    [mockCollectionView verify];
}

- (void)testRemoveItemsAtIndexes
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    [ds removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
    expect(ds.allItems).to.equal((@[@"foo"]));
}

- (void)testRemovingItemsAtIndexesDeletesRowsInDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;
    
    [[mockTableView expect] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],
                                                     [NSIndexPath indexPathForRow:2 inSection:0]]
                                  withRowAnimation:ds.rowAnimation];
    
    [ds removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
    
    [mockTableView verify];
}

- (void)testRemovingItemsAtIndexesDeletesItemsInDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;
    
    [[mockCollectionView expect] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],
                                                           [NSIndexPath indexPathForRow:2 inSection:0]]];
    
    [ds removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
    
    [mockCollectionView verify];
}

#pragma mark Item movement

- (void)testMoveItem
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    [ds moveItemAtIndex:0 toIndex:1];
    expect(ds.allItems).to.equal((@[@"baz", @"foo", @"bar"]));

}

- (void)testMovingItemAtIndexMovesRowInDataSourceTableView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockTableView = tableView;
    ds.tableView = mockTableView;

    [[mockTableView expect] moveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                   toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [ds moveItemAtIndex:0 toIndex:1];

    [mockTableView verify];
}

- (void)testMovingItemAtIndexMovesDeletesItemInDataSourceCollectionView
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[@"foo", @"baz", @"bar"]];
    id mockCollectionView = collectionView;
    ds.collectionView = mockCollectionView;

    [[mockCollectionView expect] moveItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                         toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    [ds moveItemAtIndex:0 toIndex:1];

    [mockCollectionView verify];
}

- (void)testForwardCommitEditingStyleToDeletionBlock
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[ @1, @2, @3 ]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    expect(ds.numberOfItems).to.equal(@3);
    
    ds.tableDeletionBlock = ^(SSArrayDataSource *dataSource,
                              UITableView *tableView,
                              NSIndexPath *indexPath) {
        
        [dataSource removeItemAtIndex:(NSUInteger)indexPath.row];
    };
    
    [ds tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    expect(ds.numberOfItems).to.equal(@2);
}

#pragma mark - Filtering

- (void) testFilterableDataSources
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[ @1, @2, @3, @4 ]];
    
    expect(ds.numberOfItems).to.equal(4);
    
    [ds setCurrentFilter:[SSResultsFilter filterWithBlock:^BOOL(NSNumber *number) {
        return [number integerValue] < 3;
    }]];
    
    expect(ds.numberOfItems).to.equal(2);
    
    [ds setCurrentFilter:nil];
    
    expect(ds.numberOfItems).to.equal(4);
}

- (void) testItemEnumeration
{
    SSArrayDataSource *ds = [[SSArrayDataSource alloc] initWithItems:@[ @1, @2, @3, @4 ]];
    
    __block NSUInteger count = 0, sum = 0;
    
    expect(ds.numberOfItems).to.equal(4);
    
    [ds enumerateItemsWithBlock:^(NSIndexPath *indexPath,
                                  NSNumber *item,
                                  BOOL *stop) {
        count++;
        sum += [item integerValue];
    }];
    
    expect(ds.numberOfItems).to.equal(count);
    expect(sum).to.equal(10);
}

@end
