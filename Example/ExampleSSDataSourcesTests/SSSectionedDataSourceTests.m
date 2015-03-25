#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSSectionedDataSourceTests : XCTestCase
@end

@implementation SSSectionedDataSourceTests
{
    SSSectionedDataSource *ds; // system-under-test
    OCMockObject *mockTable;
}

- (void)setUp
{
    mockTable = [OCMockObject niceMockForClass:[UITableView class]];
    ds = [[SSSectionedDataSource alloc] initWithItems:nil];
    ds.tableView = (UITableView *)mockTable;
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

    ds = [[SSSectionedDataSource alloc] initWithSections:@[ [SSSection sectionWithItems:@[ @"foo", @"bar", @"baz" ]] ]];
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
    ds.shouldRemoveEmptySections = YES;
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
    expect([ds sectionAtIndex:0].items.firstObject).to.equal(@"foo");
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

- (void) test_removing_section_with_identifier
{
    ds = [[SSSectionedDataSource alloc] initWithSection:[SSSection sectionWithNumberOfItems:3
                                                                                     header:nil
                                                                                     footer:nil
                                                                                 identifier:@0]];
    
    [ds appendSection:[SSSection sectionWithNumberOfItems:4
                                                   header:nil
                                                   footer:nil
                                               identifier:@1]];
    
    expect([ds numberOfSections]).to.equal(2);
    [ds removeSectionWithIdentifier:@3];
    expect([ds numberOfSections]).to.equal(2);
    [ds removeSectionWithIdentifier:@0];
    expect([ds numberOfSections]).to.equal(1);
    expect([ds indexOfSectionWithIdentifier:@1]).to.equal(0);
}

- (void) test_adjust_section_row_count
{
    ds = [[SSSectionedDataSource alloc] initWithSection:[SSSection sectionWithNumberOfItems:3
                                                                                     header:nil
                                                                                     footer:nil
                                                                                 identifier:@0]];

    // test that the return value indicates there was an adjustment made (decrement)
    expect([ds adjustSectionAtIndex:0 toNumberOfItems:1]).to.beTruthy();
    expect([ds numberOfItemsInSection:0]).to.equal(1);

    // test that the return value indicates there was an adjustment made (increment)
    expect([ds adjustSectionAtIndex:0 toNumberOfItems:5]).to.beTruthy();
    expect([ds numberOfItemsInSection:0]).to.equal(5);

    // test that the return value indicates there was not an adjustment made
    expect([ds adjustSectionAtIndex:0 toNumberOfItems:5]).to.beFalsy();
}

- (void) test_adjusting_section_removes_from_end
{
    ds = [[SSSectionedDataSource alloc] initWithItems:@[ @1, @2, @3, @4, @5 ]];
    
    [ds adjustSectionAtIndex:0 toNumberOfItems:3];
    
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    expect([ds sectionAtIndex:0].items).to.equal(@[ @1, @2, @3 ]);
}

- (void) test_adjusting_section_reloads_section
{
    ds = [[SSSectionedDataSource alloc] initWithSection:[SSSection sectionWithNumberOfItems:6]];
    
    ds.tableView = (UITableView *)mockTable;
    
    [[mockTable expect] reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:ds.rowAnimation];
    
    [ds adjustSectionAtIndex:0 toNumberOfItems:5];
    
    [mockTable verify];
}

- (void) test_adjusting_to_empty_deletes_section
{
    ds = [[SSSectionedDataSource alloc] initWithSection:[SSSection sectionWithNumberOfItems:5]];
    ds.shouldRemoveEmptySections = YES;
    ds.tableView = (UITableView *)mockTable;
    
    [[mockTable expect] deleteSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:ds.rowAnimation];
    
    [ds adjustSectionAtIndex:0 toNumberOfItems:0];
    
    [mockTable verify];
    expect([ds numberOfSections]).to.equal(0);
}

- (void) test_adjusting_to_empty_without_deletion
{
    ds = [[SSSectionedDataSource alloc] initWithSection:[SSSection sectionWithNumberOfItems:5]];
    ds.shouldRemoveEmptySections = NO;
    ds.tableView = (UITableView *)mockTable;
    
    [[mockTable expect] reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:ds.rowAnimation];
    
    [ds adjustSectionAtIndex:0 toNumberOfItems:0];
    
    [mockTable verify];
    expect([ds numberOfSections]).to.equal(1);
    expect([ds numberOfItemsInSection:0]).to.equal(0);
}

- (void) test_nonadjustment_does_not_reload_section
{
    ds = [[SSSectionedDataSource alloc] initWithSection:[SSSection sectionWithNumberOfItems:6]];
    
    ds.tableView = (UITableView *)mockTable;
    
    [[mockTable reject] reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:ds.rowAnimation];
    
    [ds adjustSectionAtIndex:0 toNumberOfItems:6];
    
    [mockTable verify];
}

- (void)testSectionAccess
{
    expect([ds sectionWithIdentifier:@3]).to.beNil();
    [ds appendSection:[SSSection sectionWithNumberOfItems:3 header:@"H" footer:@"F" identifier:@3]];
    expect([ds sectionWithIdentifier:@3]).toNot.beNil();
    expect([ds tableView:ds.tableView titleForHeaderInSection:0]).to.equal(@"H");
    expect([ds tableView:ds.tableView titleForFooterInSection:0]).to.equal(@"F");
}

- (void)testMovingItems
{
    [ds appendSection:[SSSection sectionWithNumberOfItems:1]];
    [ds appendItems:@[ @2, @3 ] toSection:0];
    expect([ds numberOfItems]).to.equal(3);
    [ds tableView:ds.tableView
moveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
      toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    expect([ds itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).to.equal(@0);
}

- (void)testInsertingSections
{
    [ds insertSections:@[
               @[ @1, @2 ],
               [SSSection sectionWithNumberOfItems:4]
            ]
             atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]];
    
    expect(ds.numberOfSections).to.equal(2);
    expect(ds.numberOfItems).to.equal(6);
    
    [ds insertItem:@3
       atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    expect([ds numberOfItemsInSection:0]).to.equal(3);
    
    [ds insertItems:@[ @3, @4 ]
          atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)]
          inSection:0];
    
    expect([ds numberOfItemsInSection:0]).to.equal(5);
    
    [ds appendItems:@[ @5, @6 ] toSection:1];
    
    expect([ds numberOfItemsInSection:1]).to.equal(6);
}

- (void)testClearingSections
{
    [ds appendSection:[SSSection sectionWithNumberOfItems:1]];
    expect(ds.numberOfSections).to.equal(1);
    [ds clearSections];
    expect(ds.numberOfSections).to.equal(0);
    [ds appendSection:[SSSection sectionWithNumberOfItems:1]];
    expect(ds.numberOfSections).to.equal(1);
    [ds removeAllSections];
    expect(ds.numberOfSections).to.equal(0);
    [ds appendSection:[SSSection sectionWithNumberOfItems:1]];
    expect(ds.numberOfSections).to.equal(1);
    [ds removeSectionsInRange:NSMakeRange(0, 1)];
    expect(ds.numberOfSections).to.equal(0);
}

- (void)testSectionCopy
{
    SSSection *section = [SSSection sectionWithNumberOfItems:3 header:@"H" footer:@"F" identifier:@3];
    SSSection *copySection = [section copy];
    
    expect(copySection.numberOfItems).to.equal(section.numberOfItems);
    expect(copySection.header).to.equal(section.header);
    expect(copySection.footer).to.equal(section.footer);
    expect(copySection.sectionIdentifier).to.equal(section.sectionIdentifier);
}

#pragma mark - Header/Footer

- (void)testHeaderFooterView
{
    SSBaseHeaderFooterView *headerFooter;
    
    expect([SSBaseHeaderFooterView identifier]).to.equal(NSStringFromClass([SSBaseHeaderFooterView class]));
    
    headerFooter = [SSBaseHeaderFooterView new];
    
    expect(headerFooter.reuseIdentifier).to.equal([SSBaseHeaderFooterView identifier]);
}

#pragma mark - UITableViewDelegate helpers

- (void)testHeaderFooterViewDelegate
{
    SSSection *section = [SSSection sectionWithNumberOfItems:1];
    section.headerClass = [SSBaseHeaderFooterView class];
    section.footerClass = [SSBaseHeaderFooterView class];
    [ds appendSection:section];
    
    SSBaseHeaderFooterView *header = [ds viewForHeaderInSection:0];
    expect(header).toNot.beNil();
    
    SSBaseHeaderFooterView *footer = [ds viewForFooterInSection:0];
    expect(footer).toNot.beNil();
    
    section.headerHeight = 10;
    section.footerHeight = 20;
    expect([ds heightForHeaderInSection:0]).to.equal(10);
    expect([ds heightForFooterInSection:0]).to.equal(20);
    
    section.header = @"H";
    section.footer = @"F";
    expect([ds titleForHeaderInSection:0]).to.equal(@"H");
    expect([ds titleForFooterInSection:0]).to.equal(@"F");
}

@end
