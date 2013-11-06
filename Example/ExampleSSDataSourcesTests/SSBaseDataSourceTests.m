#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSBaseDataSourceTests : SenTestCase
@end

@implementation SSBaseDataSourceTests
{
    SSBaseDataSource *ds; // sut

    UITableView *tableView;
    UICollectionView *collectionView;
}

- (void)setUp
{
    [super setUp];
    ds = [[SSBaseDataSource alloc] init];
    tableView = [OCMockObject niceMockForClass:UITableView.class];
    collectionView = [OCMockObject niceMockForClass:UICollectionView.class];
}

- (void)testInitializable
{
    expect(ds).toNot.beNil();
}

#pragma mark Abstract methods

- (void)testRequiresSubclassesToImplementItemRetrieval
{
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    expect(^{
        [ds itemAtIndexPath:ip];
    }).to.raiseAny();
}

- (void)testRequiresSubclassesToImplementCollectionViewSectionCounting
{
    expect(^{
        [ds collectionView:collectionView numberOfItemsInSection:0];
    }).to.raiseAny();

}

#pragma mark Defaults

- (void)testDefaultCellType
{
    expect(ds.cellClass).to.equal(SSBaseTableCell.class);
}

- (void)testDefaultRowAnimation
{
    expect(ds.rowAnimation).to.equal(UITableViewRowAnimationAutomatic);
}

#pragma mark UITableViewDataSource defaults

- (void)testRequiresSubclassesToImplementRowCount
{
    expect(^{
        [ds tableView:tableView numberOfRowsInSection:0];
    }).to.raiseAny();
}

- (void)testCanNotMoveRowByDefault
{
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];
    expect([ds tableView:tableView canMoveRowAtIndexPath:ip]).to.equal(NO);
}

- (void)testCanEditRowByDefault
{
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];
    expect([ds tableView:tableView canEditRowAtIndexPath:ip]).to.equal(YES);
}

#pragma mark fallbackTableDataSource

- (void)testForwardMovingRowToFallbackTableDataSource
{
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];

    id mockFallback = [OCMockObject niceMockForProtocol:@protocol(UITableViewDataSource)];
    [[mockFallback expect] tableView:tableView canMoveRowAtIndexPath:ip];

    ds.fallbackTableDataSource = mockFallback;
    [ds tableView:tableView canMoveRowAtIndexPath:ip];

    [mockFallback verify];
}

- (void)testForwardEditingRowToFallbackTableDataSource
{
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];

    id mockFallback = [OCMockObject niceMockForProtocol:@protocol(UITableViewDataSource)];
    [[mockFallback expect] tableView:tableView canEditRowAtIndexPath:ip];

    ds.fallbackTableDataSource = mockFallback;
    [ds tableView:tableView canEditRowAtIndexPath:ip];

    [mockFallback verify];
}

- (void)testForwardCommitEditingStyleToFallbackTableDataSource
{
    UITableViewCellEditingStyle es = UITableViewCellEditingStyleDelete;
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];

    id mockFallback = [OCMockObject niceMockForProtocol:@protocol(UITableViewDataSource)];
    [[mockFallback expect] tableView:tableView commitEditingStyle:es forRowAtIndexPath:ip];

    ds.fallbackTableDataSource = mockFallback;
    [ds tableView:tableView commitEditingStyle:es forRowAtIndexPath:ip];

    [mockFallback verify];
}

#pragma mark UICollectionViewDataSource

- (void)testDefaultNilViewForSupplementaryElement
{
    id kind = UICollectionElementKindSectionHeader;
    id ip = [NSIndexPath indexPathForItem:0 inSection:0];

    expect([ds collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:ip]).to.beNil();
}

#pragma mark UICollectionView reusable views

- (void) testReusableCollectionViewNotNil {
    
    // setup environment
    NSString *kind = UICollectionElementKindSectionHeader;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(20, 20);
    
    collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){}
                                        collectionViewLayout:layout];
    
    [collectionView registerClass:[SSBaseCollectionReusableView class]
       forSupplementaryViewOfKind:kind
              withReuseIdentifier:[SSBaseCollectionReusableView identifier]];
    
    ds = [[SSArrayDataSource alloc] initWithItems:@[ @"item" ]];
    ds.collectionView = collectionView;
    
    collectionView.dataSource = ds;
    
    // Force a simulation of a view that's preparing for presentation.
    // Production code should never send the -layoutSubviews message explicitly,
    // but for the purposes of this test we need to immediately simulate the use
    // of a UICollectionView (within the current run loop of this test) within a
    // layout hierarchy.
    [collectionView layoutSubviews];
    
    expect([ds collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath]).toNot.beNil();
}

#pragma mark Helpers

- (void)testBuildingArrayOfIndexPathsWithRange
{
    id indexPaths = [ds.class indexPathArrayWithRange:NSMakeRange(0, 0)];
    expect(indexPaths).to.beEmpty();

    indexPaths = [ds.class indexPathArrayWithRange:NSMakeRange(1, 3)];
    expect(indexPaths).to.equal((@[
        [NSIndexPath indexPathForRow:1 inSection:0],
        [NSIndexPath indexPathForRow:2 inSection:0],
        [NSIndexPath indexPathForRow:3 inSection:0]
    ]));
}

- (void)testBuildingArrayOfIndexPathsWithIndexSet
{
    id indexPaths = [ds.class indexPathArrayWithIndexSet:[NSIndexSet indexSet]];
    expect(indexPaths).to.beEmpty();

    indexPaths = [ds.class indexPathArrayWithIndexSet:[NSIndexSet indexSetWithIndex:1]];
    expect(indexPaths).to.equal(@[[NSIndexPath indexPathForRow:1 inSection:0]]);
}

@end
