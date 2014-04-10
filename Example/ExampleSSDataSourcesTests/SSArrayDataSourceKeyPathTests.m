#import "SSTestHelper.h"
#import <SSDataSources.h>

/**
 * A model object within the tests that has a to-many employees relationsihp.
 */
@interface Department : NSObject
@property (nonatomic, copy) NSArray *employees;
@end
@implementation Department
- (NSArray *)employees {
    if (_employees == nil) _employees = @[];
    return _employees;
}
@end

#pragma mark -

@interface SSArrayDataSourceKeyPathTests : XCTestCase
@end

@implementation SSArrayDataSourceKeyPathTests
{
    SSArrayDataSource *dataSource; // system-under-test
    Department *department;
}

- (void)setUp
{
    [super setUp];

    department = ({
        Department *d = [Department new];
        d.employees = @[ @"Josh", @"Shelley", @"Jenn", @"Andrew" ];
        d;
    });
    dataSource = [[SSArrayDataSource alloc] initWithTarget:department keyPath:@"employees"];
}

- (void)test_initializable
{
    expect(dataSource).toNot.beNil();
}

#pragma mark Base item access

- (void)test_implements_item_retrieval
{
    expect(
       [dataSource itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]
    ).to.equal(@"Josh");
}

- (void)test_number_of_items
{
    expect([dataSource numberOfItems]).to.equal(4);
}

- (void)test_number_of_sections
{
    expect([dataSource numberOfSections]).to.equal(1);
}

- (void)test_number_of_items_in_section
{
    expect([dataSource numberOfItemsInSection:0]).to.equal(4);
}

#pragma mark Array item access

- (void)test_indexPath_for_item
{
    expect([dataSource indexPathForItem:@"Josh"])
        .to.equal([NSIndexPath indexPathForRow:0 inSection:0]);
    expect([dataSource indexPathForItem:@"Shelley"])
        .to.equal([NSIndexPath indexPathForRow:1 inSection:0]);
}

#pragma mark Item addition

- (void)test_adding_item_at_keyPath_updates_data_source
{
    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees addObject:@"Samuel"];
    expect([dataSource numberOfItems]).to.equal(5);
}

- (void)test_adding_item_inserts_cell
{
    OCMockObject *mockDataSource = [OCMockObject partialMockForObject:dataSource];
    [[mockDataSource expect] insertCellsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:4 inSection:0]
    ]];

    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees addObject:@"Samuel"];

    [mockDataSource verify];
}

- (void)test_appending_item_via_data_source
{
    __block NSInteger insertCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            insertCellsMessageSendCount++;
        }]
        insertCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource appendItem:@"Fred"];

    expect(insertCellsMessageSendCount).to.equal(1);
}

- (void)test_appending_items_via_data_source
{
    __block NSInteger insertCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            insertCellsMessageSendCount++;
        }]
        insertCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource appendItems:@[ @"Bill", @"Janet"]];

    expect(insertCellsMessageSendCount).to.equal(1);
}

#pragma mark Item insertion

- (void)test_inserting_item_at_keyPath_updates_data_source
{
    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees insertObject:@"Bob" atIndex:0];
    expect([dataSource numberOfItems]).to.equal(5);
    expect([dataSource itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]])
        .to.equal(@"Bob");
}

- (void)test_inserting_item_inserts_cell
{
    OCMockObject *mockDataSource = [OCMockObject partialMockForObject:dataSource];
    [[mockDataSource expect] insertCellsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0]
    ]];

    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees insertObject:@"Bob" atIndex:0];

    [mockDataSource verify];
}

- (void)test_inserting_item_via_data_source
{
    __block NSInteger insertCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            insertCellsMessageSendCount++;
        }]
        insertCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource insertItem:@"Riley" atIndex:0];

    expect(insertCellsMessageSendCount).to.equal(1);
}

- (void)test_inserting_items_via_data_source
{
    __block NSInteger insertCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            insertCellsMessageSendCount++;
        }]
        insertCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource insertItems:@[ @"Bob", @"Janet" ]
                  atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];

    expect(insertCellsMessageSendCount).to.equal(1);
}

#pragma mark Item removal

- (void)test_removing_item_at_keyPath_updates_data_source
{
    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees removeObject:@"Shelley"];
    expect([dataSource numberOfItems]).to.equal(3);
    expect([dataSource indexPathForItem:@"Jenn"])
        .to.equal([NSIndexPath indexPathForRow:1 inSection:0]);
}

- (void)test_removing_item_removes_cell
{
    OCMockObject *mockDataSource = [OCMockObject partialMockForObject:dataSource];
    [[mockDataSource expect] deleteCellsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:0 inSection:0]
    ]];

    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees removeObject:@"Josh"];

    [mockDataSource verify];
}

- (void)test_removing_items_via_data_source
{
    __block NSInteger deleteCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            deleteCellsMessageSendCount++;
        }]
        deleteCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource removeItemAtIndex:0];

    expect(deleteCellsMessageSendCount).to.equal(1);
}

- (void)test_removing_items_in_range_via_data_source
{
    __block NSInteger deleteCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            deleteCellsMessageSendCount++;
        }]
        deleteCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource removeItemsInRange:NSMakeRange(0, 3)];

    expect(deleteCellsMessageSendCount).to.equal(1);
}

- (void)test_removing_items_at_indexes_via_data_source
{
    __block NSInteger deleteCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            deleteCellsMessageSendCount++;
        }]
        deleteCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];

    expect(deleteCellsMessageSendCount).to.equal(1);
}

#pragma mark Item replacement

- (void)test_updating_item_at_keyPath_updates_data_source
{
    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees replaceObjectAtIndex:1 withObject:@"Samuel"];
    expect([dataSource itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]])
            .to.equal(@"Samuel");
}

- (void)test_updating_item_reloads_cell
{
    OCMockObject *mockDataSource = [OCMockObject partialMockForObject:dataSource];
    [[mockDataSource expect] reloadCellsAtIndexPaths:@[
        [NSIndexPath indexPathForRow:1 inSection:0]
    ]];

    NSMutableArray *employees = [department mutableArrayValueForKey:@"employees"];
    [employees replaceObjectAtIndex:1 withObject:@"Samuel"];

    [mockDataSource verify];
}

- (void)test_replacing_item_via_data_source
{
    __block NSInteger reloadCellsMessageSendCount = 0;
    [[[[OCMockObject partialMockForObject:dataSource]
        stub]
        andDo:^(NSInvocation *inv) {
            reloadCellsMessageSendCount++;
        }]
        reloadCellsAtIndexPaths:OCMOCK_ANY];

    [dataSource replaceItemAtIndex:0 withItem:@"Riley"];

    expect(reloadCellsMessageSendCount).to.equal(1);
}

#pragma mark Observed object memory semantics

- (void)test_no_exception_if_target_goes_away
{
    Department *someDepartment = [Department new];
    dataSource = [[SSArrayDataSource alloc] initWithTarget:someDepartment keyPath:@"employees"];
    someDepartment = nil;
    expect(^{
        [dataSource clearItems];
    }).toNot.raiseAny();
}

@end
