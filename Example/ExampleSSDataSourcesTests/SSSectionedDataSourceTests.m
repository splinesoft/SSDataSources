#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSSectionedDataSourceTests : XCTestCase
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

- (void) test_automatic_section_removal
{
    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo" ]];
    [ds appendSection:[SSSection sectionWithItems:@[ @"bar" ]]];
    
    expect(ds.numberOfSections).to.equal(2);
    [ds removeItemsInRange:NSMakeRange(0, 1) inSection:1];
    expect(ds.numberOfSections).to.equal(1);
    
    ds.shouldRemoveEmptySections = NO;
    [ds removeItemsInRange:NSMakeRange(0, 1) inSection:0];
    expect(ds.numberOfSections).to.equal(1);
}

- (void) test_item_count
{
    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @"foo" ]];
    [ds appendSection:[SSSection sectionWithItems:@[ @"bar" ]]];
    
    expect(ds.numberOfItems).to.equal(2);
    
    [ds removeSectionAtIndex:1];
    
    expect(ds.numberOfItems).to.equal(1);
}

- (void) test_item_searching
{
    ds = [[SSSectionedDataSource alloc] initWithItems:@[@"foo", @"bar", @"baz"]];
    expect([ds indexPathForItem:@"foo"]).to.equal([NSIndexPath indexPathForRow:0 inSection:0]);
    expect([ds indexPathForItem:@"bar"]).to.equal([NSIndexPath indexPathForRow:1 inSection:0]);
    expect([ds indexPathForItem:@"baz"]).to.equal([NSIndexPath indexPathForRow:2 inSection:0]);
    
    [ds appendSection:[SSSection sectionWithItems:@[@"bilbo", @"frodo"]]];
    expect([ds indexPathForItem:@"frodo"]).to.equal([NSIndexPath indexPathForRow:1 inSection:1]);
}

@end
