#import "SSTestHelper.h"
#import <SSDataSources.h>

/**
 * TODO Write documentation
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
    dataSource = [[SSArrayKeyPathDataSource alloc] initWithSource:department keyPath:@"employees"];
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

@end
