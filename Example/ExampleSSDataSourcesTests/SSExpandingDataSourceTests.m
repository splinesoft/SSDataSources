#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSExpandingDataSourceTests : XCTestCase

@end

@implementation SSExpandingDataSourceTests
{
    SSExpandingDataSource *ds;
    UITableView *tableView;
}

- (void)setUp {
    [super setUp];
    
    tableView = [OCMockObject niceMockForClass:[UITableView class]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializable {
    ds = [[SSExpandingDataSource alloc] initWithItems:nil];
    
    expect(ds).notTo.beNil();
}

- (void)testExpandedSectionIndexes {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1 ]];
    [ds appendSection:[SSSection sectionWithItems:@[ @2 ]]];
    
    expect([ds expandedSectionIndexes]).to.equal([NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]);
    
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds expandedSectionIndexes]).to.equal([NSIndexSet indexSetWithIndex:1]);
}

- (void)testExpandedSectionsNotLimited {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1, @2, @3 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 1;
    };
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    
    id mockTable = tableView;
    ds.tableView = mockTable;
    
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:3 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:4 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    
    [ds appendItems:@[ @4, @5 ] toSection:0];
    
    [mockTable verify];
}

- (void)testSectionItemVisibility {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1, @2, @3 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 1;
    };
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    expect([ds isItemVisibleAtIndexPath:indexPath]).to.beTruthy();
    
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds isItemVisibleAtIndexPath:indexPath]).to.beFalsy();
}

- (void)testCollapsingSection {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1, @2, @3 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 1;
    };
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    
    id mockTable = tableView;
    ds.tableView = mockTable;
    
    [[mockTable expect] deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds numberOfItemsInSection:0]).to.equal(1);
    
    [mockTable verify];
}

- (void)testInsertingRowsInCollapsedSection {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 3;
    };
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds numberOfItemsInSection:0]).to.equal(1);
    
    id mockTable = tableView;
    ds.tableView = mockTable;
    
    SSSection *section = [ds sectionAtIndex:0];
    
    expect(section.numberOfItems).to.equal(1);
    
    // We allow additional insertions up to our collapsed row count
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:2 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    
    [ds appendItems:@[ @2, @3 ] toSection:0];
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    expect(section.numberOfItems).to.equal(3);
    
    [mockTable verify];
    
    // Further item additions beyond the collapsed maximum should NOT be inserted
    [[mockTable reject] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:3 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    [[mockTable reject] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:4 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    [[mockTable reject] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:5 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    
    [ds appendItems:@[ @4, @5, @6 ] toSection:0];
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    
    // ...but they should be added to the section object
    expect(section.numberOfItems).to.equal(6);
    
    [mockTable verify];
}

- (void)testRemovingItemsFromCollapsedSection {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1, @2, @3, @4, @5 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 2;
    };
    
    expect([ds numberOfItemsInSection:0]).to.equal(5);
    
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds numberOfItemsInSection:0]).to.equal(2);
    
    id mockTable = tableView;
    ds.tableView = mockTable;
    
    // Deleting rows that are not currently visible should not affect the table
    [[mockTable reject] deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:3 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    [[mockTable reject] deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:4 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    
    SSSection *section = [ds sectionAtIndex:0];
    
    expect(section.numberOfItems).to.equal(5);
    
    [ds removeItemsInRange:NSMakeRange(3, 2) inSection:0];
    
    expect([ds numberOfItemsInSection:0]).to.equal(2);
    
    [mockTable verify];
    
    // ...but they should have been deleted from the underlying section
    expect(section.numberOfItems).to.equal(3);
}

- (void)testExpandingSection {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1, @2, @3 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 1;
    };
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds numberOfItemsInSection:0]).to.equal(1);
    
    id mockTable = tableView;
    ds.tableView = mockTable;
    
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0] ]
                              withRowAnimation:ds.rowAnimation];
    
    [ds setSectionAtIndex:0 expanded:YES];
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    
    [mockTable verify];
}

- (void)testMovingSection {
    ds = [[SSExpandingDataSource alloc] initWithItems:@[ @1, @2, @3 ]];
    ds.collapsedSectionCountBlock = ^NSInteger(SSSection *sec, NSInteger sectionIndex) {
        return 1;
    };
    [ds appendSection:[SSSection sectionWithItems:@[ @1, @2, @3 ]]];
    
    [ds setSectionAtIndex:0 expanded:NO];
    
    expect([ds numberOfItemsInSection:0]).to.equal(1);
    expect([ds numberOfItemsInSection:1]).to.equal(3);
    expect([ds expandedSectionIndexes]).to.equal([NSIndexSet indexSetWithIndex:1]);
    
    id mockTable = tableView;
    ds.tableView = mockTable;
    
    [[mockTable expect] moveSection:0 toSection:1];
    
    [ds moveSectionAtIndex:0 toIndex:1];
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    expect([ds numberOfItemsInSection:1]).to.equal(1);
    expect([ds expandedSectionIndexes]).to.equal([NSIndexSet indexSetWithIndex:0]);
    
    [mockTable verify];
}

@end
