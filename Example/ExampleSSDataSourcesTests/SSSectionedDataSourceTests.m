#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSSectionedDataSourceTests : SenTestCase
@end

@implementation SSSectionedDataSourceTests
{
    SSSectionedDataSource *ds; // system-under-test
}

- (void)test_removing_all_items_in_section_removes_the_section
{
    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo" ]];
    expect(ds.numberOfSections).to.equal(1);
    [ds removeItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    expect(ds.numberOfSections).to.equal(0);

    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo", @"bar" ]];
    expect(ds.numberOfSections).to.equal(1);
    [ds removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] inSection:0];
    expect(ds.numberOfSections).to.equal(0);

    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo", @"bar", @"baz" ]];
    expect(ds.numberOfSections).to.equal(1);
    [ds removeItemsInRange:NSMakeRange(0, 3) inSection:0];
    expect(ds.numberOfSections).to.equal(0);
}

- (void)test_removing_all_items_in_section
{
    SSSection *section;

    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo" ]];
    section = [ds sectionAtIndex:0];
    expect(section.items).to.haveCountOf(1);
    [ds removeItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    expect(section.items).to.haveCountOf(0);
    expect(ds.numberOfSections).to.equal(0);

    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo", @"bar" ]];
    section = [ds sectionAtIndex:0];
    expect(section.items).to.haveCountOf(2);
    [ds removeItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] inSection:0];
    expect(section.items).to.haveCountOf(0);
    expect(ds.numberOfSections).to.equal(0);

    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo", @"bar", @"baz" ]];
    section = [ds sectionAtIndex:0];
    expect(section.items).to.haveCountOf(3);
    [ds removeItemsInRange:NSMakeRange(0, 3) inSection:0];
    expect(section.items).to.haveCountOf(0);
    expect(ds.numberOfSections).to.equal(0);
}

@end
