//
//  SSCoreDataSourceTests.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 5/31/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SSTestHelper.h"
#import <SSDataSources.h>
#import "Wizard.h"

@interface SSCoreDataSourceTests : XCTestCase

@end

@implementation SSCoreDataSourceTests
{
    SSCoreDataSource *dataSource;
    UITableView *tableView;
    UICollectionView *collectionView;
}

- (void)setUp
{
    [super setUp];
    
    // No-op if stack already setup
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    tableView = [OCMockObject niceMockForClass:UITableView.class];
    collectionView = [OCMockObject niceMockForClass:UICollectionView.class];
    
    dataSource = [[SSCoreDataSource alloc] initWithFetchRequest:[Wizard MR_requestAllSortedBy:@"name" ascending:YES]
                                                      inContext:[NSManagedObjectContext MR_defaultContext]
                                             sectionNameKeyPath:nil];
    dataSource.tableView = tableView;
}

- (void)tearDown
{
    [super tearDown];
    
    [Wizard MR_truncateAll];
    
    dataSource = nil;
}

- (void)testRetrievesItems
{
    Wizard *w = [Wizard wizardWithName:@"Merlyn" realm:@"Arthurian"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    expect([dataSource itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).to.equal(w);
}

- (void)testCountsItems
{
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero];
    
    dataSource.tableView = tv;
    
    [Wizard wizardWithName:@"Merlyn" realm:@"Arthurian"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    expect(dataSource.numberOfItems).to.equal(1);
    
    expect([tv numberOfRowsInSection:0]).to.equal(1);
    
    [Wizard MR_truncateAll];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    expect(dataSource.numberOfItems).to.equal(0);
    
    expect([tv numberOfRowsInSection:0]).to.equal(0);
}

- (void)testInsertingItemInsertsRow
{
    id mockTable = tableView;
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    dataSource.rowAnimation = animation;
    
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                              withRowAnimation:animation];
    
    [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    [mockTable verify];
}

- (void)testInsertingSectionInsertsSection
{
    id mockTable = tableView;
    dataSource = [[SSCoreDataSource alloc] initWithFetchRequest:[Wizard MR_requestAllSortedBy:@"name" ascending:YES]
                                                      inContext:[NSManagedObjectContext MR_defaultContext]
                                             sectionNameKeyPath:@"name"];
    dataSource.tableView = tableView;
    dataSource.rowAnimation = UITableViewRowAnimationLeft;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard MR_truncateAllInContext:context];
    }];
    
    expect([dataSource numberOfSections]).to.equal(0);
    
    [[mockTable expect] insertSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:dataSource.rowAnimation];
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        Wizard *w = [Wizard MR_createInContext:context];
        w.name = @"Name";
        w.realm = @"Realm";
    }];

    [mockTable verify];
    
    expect([dataSource tableView:dataSource.tableView sectionForSectionIndexTitle:@"Name" atIndex:0]).to.equal(0);
}

- (void)testDeletingItemDeletesRow
{
    id mockTable = tableView;
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    dataSource.rowAnimation = animation;
    
    [[mockTable expect] deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                              withRowAnimation:animation];
    
    Wizard *w = [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    [w MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    [mockTable verify];
}

- (void)testUpdatingItemReloadsRow
{
    id mockTable = tableView;
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    dataSource.rowAnimation = animation;
    
    [[mockTable expect] reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                              withRowAnimation:animation];
    
    Wizard *w = [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    w.name = @"Pallando";
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    [mockTable verify];
}

- (void)testForwardsMovesToMoveBlock
{
    __block BOOL didMove = NO;
    
    dataSource.coreDataMoveRowBlock = ^(Wizard *wizard,
                                        NSIndexPath *fromPath,
                                        NSIndexPath *toPath) {
        // This is very silly
        didMove = YES;
    };
    
    [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth"];
    [Wizard wizardWithName:@"Melisandre" realm:@"Westeros"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    [dataSource tableView:dataSource.tableView
       moveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
              toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    expect(didMove).to.beTruthy();
}

- (void)testFindingManagedObjects
{
    Wizard *aWizard = [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth"];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    expect([dataSource indexPathForItem:aWizard]).to.equal([NSIndexPath indexPathForRow:0 inSection:0]);
    
    expect([dataSource indexPathForItemWithId:[aWizard objectID]]).to.equal([NSIndexPath indexPathForRow:0 inSection:0]);

    expect([dataSource indexPathForItemWithId:[NSManagedObjectID new]]).to.beNil();
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)testSectionIndexTitles
{
    expect([dataSource controller:dataSource.controller sectionIndexTitleForSectionName:@"Section"]).to.equal(@"Section");
}

@end
