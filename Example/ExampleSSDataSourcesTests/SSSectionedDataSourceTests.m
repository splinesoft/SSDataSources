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

- (void) test_replacing_item
{
    SSSection *section;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo" ]];
    section = [ds sectionAtIndex:indexPath.section];
    expect(section.items).to.haveCountOf(1);
    [ds replaceItemAtIndexPath:indexPath withItem:@"bar"];
    expect(section.items).to.haveCountOf(1);
    expect([ds itemAtIndexPath:indexPath]).to.equal(@"bar");
}

- (void) testSectionedDataSourceCopy
{
    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo" ]];
    
    SSSectionedDataSource *ds2 = [ds copy];
    
    expect(ds2).toNot.equal(ds);
    expect(ds2.numberOfSections).to.equal(ds.numberOfSections);
    expect(ds2.numberOfItems).to.equal(ds.numberOfItems);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    expect([ds2 itemAtIndexPath:indexPath]).to.equal([ds itemAtIndexPath:indexPath]);
}

@end
