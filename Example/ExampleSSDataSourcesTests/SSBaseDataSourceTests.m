#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSBaseDataSourceTests : XCTestCase
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
    ds = [SSBaseDataSource new];
    tableView = [OCMockObject niceMockForClass:UITableView.class];
    collectionView = [OCMockObject niceMockForClass:UICollectionView.class];
}

- (void)tearDown
{
    [super tearDown];
    ds = nil;
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

- (void)testRequiresSubclassesToImplementSectionCount
{
    expect(^{
        [ds numberOfSections];
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

#pragma mark - Edit/Move enablement

- (void)testForwardMovingRowToActionBlock
{
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];

    ds.tableActionBlock = ^BOOL(SSCellActionType action,
                                UITableView *tableView,
                                NSIndexPath *indexPath) {
        
        return action == SSCellActionTypeMove;
    };
    
    expect([ds tableView:tableView canMoveRowAtIndexPath:ip]).to.beTruthy;
}

- (void)testForwardEditingRowToActionBlock
{
    id ip = [NSIndexPath indexPathForRow:0 inSection:0];

    ds.tableActionBlock = ^BOOL(SSCellActionType action,
                                UITableView *tableView,
                                NSIndexPath *indexPath) {
        
        
        return action == SSCellActionTypeEdit;
    };
    
    expect([ds tableView:tableView canEditRowAtIndexPath:ip]).to.beTruthy;
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
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)
                                        collectionViewLayout:layout];
    
    [collectionView registerClass:[SSBaseCollectionReusableView class]
       forSupplementaryViewOfKind:kind
              withReuseIdentifier:[SSBaseCollectionReusableView identifier]];
    [collectionView registerClass:[SSBaseCollectionCell class]
       forCellWithReuseIdentifier:[SSBaseCollectionCell identifier]];
    
    ds = [[SSArrayDataSource alloc] initWithItems:@[ @"item" ]];
    ds.cellClass = [SSBaseCollectionCell class];
    ds.collectionView = collectionView;
    
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
    id indexPaths = [ds.class indexPathArrayWithRange:NSMakeRange(0, 0) inSection:0];
    expect(indexPaths).to.beEmpty();

    indexPaths = [ds.class indexPathArrayWithRange:NSMakeRange(1, 3) inSection:0];
    expect(indexPaths).to.equal((@[
        [NSIndexPath indexPathForRow:1 inSection:0],
        [NSIndexPath indexPathForRow:2 inSection:0],
        [NSIndexPath indexPathForRow:3 inSection:0]
    ]));
}

- (void)testBuildingArrayOfIndexPathsWithIndexSet
{
    id indexPaths = [ds.class indexPathArrayWithIndexSet:[NSIndexSet indexSet]
                                               inSection:0];
    expect(indexPaths).to.beEmpty();

    indexPaths = [ds.class indexPathArrayWithIndexSet:[NSIndexSet indexSetWithIndex:1]
                                            inSection:0];
    expect(indexPaths).to.equal(@[[NSIndexPath indexPathForRow:1 inSection:0]]);
}

#pragma mark Empty View

- (void)testBasicEmptyViewVisibility
{
    // hidden empty view
    SSArrayDataSource *arrayDataSource = [[SSArrayDataSource alloc] initWithItems:@[ @"item" ]];
    arrayDataSource.tableView = tableView;
    arrayDataSource.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    expect(arrayDataSource.emptyView.isHidden).to.beTruthy();

    // visible empty view
    [arrayDataSource removeAllItems];
    expect(arrayDataSource.emptyView.isHidden).to.beFalsy();
}

- (void)testEmptyViewSetUpIsNotDependentOnParentViewConfiguration
{
    // The intent is to ensure that you can set up your emptyView *before* you
    // assign the data source’s table or collection view.
    SSArrayDataSource *arrayDataSource;

    arrayDataSource = [[SSArrayDataSource alloc] initWithItems:@[]];
    arrayDataSource.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    arrayDataSource.tableView = tableView;
    expect(arrayDataSource.emptyView.hidden).to.beFalsy();

    arrayDataSource = [[SSArrayDataSource alloc] initWithItems:@[]];
    arrayDataSource.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    arrayDataSource.collectionView = collectionView;
    expect(arrayDataSource.emptyView.hidden).to.beFalsy();
}

@end
