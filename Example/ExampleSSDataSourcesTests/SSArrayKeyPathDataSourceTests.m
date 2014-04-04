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

@interface SSArrayKeyPathDataSourceTests : SenTestCase
@end

@implementation SSArrayKeyPathDataSourceTests
{
    SSArrayKeyPathDataSource *dataSource; // system-under-test
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
    dataSource = [[SSArrayKeyPathDataSource alloc] initWithTarget:department keyPath:@"employees"];
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

@end
