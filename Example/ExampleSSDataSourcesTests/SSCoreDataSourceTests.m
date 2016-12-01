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
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard MR_truncateAllInContext:context];
    }];
    
    tableView = [OCMockObject niceMockForClass:UITableView.class];
    collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                        collectionViewLayout:[UICollectionViewFlowLayout new]];
    
    [collectionView registerClass:[SSBaseCollectionCell class]
       forCellWithReuseIdentifier:[SSBaseCollectionCell identifier]];
    
    dataSource = [[SSCoreDataSource alloc] initWithFetchRequest:[Wizard MR_requestAllSortedBy:@"name" ascending:YES]
                                                      inContext:[NSManagedObjectContext MR_defaultContext]
                                             sectionNameKeyPath:nil];
    dataSource.tableView = tableView;
}

- (void)tearDown
{
    [super tearDown];
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard MR_truncateAllInContext:context];
    }];
    
    dataSource = nil;
}

- (void)testRetrievesItems
{
    __block Wizard *w;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        w = [Wizard wizardWithName:@"Merlyn" realm:@"Arthurian" inContext:context];
    }];
  
    expect(dataSource.numberOfItems).to.equal(1);
}

- (void)testCountsItems
{
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectZero];
    
    dataSource.tableView = tv;
    
    [Wizard wizardWithName:@"Merlyn" realm:@"Arthurian" inContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    expect(dataSource.numberOfItems).to.equal(1);
    
    expect([tv numberOfRowsInSection:0]).to.equal(1);
    
    [Wizard MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
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
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:context];
    }];
    
    [mockTable verifyWithDelay:1];
}

- (void)testUpdatingItemMovesRow
{
    id mockTable = tableView;
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    dataSource.rowAnimation = animation;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:context];
        [Wizard wizardWithName:@"Pallando" realm:@"Middle-Earth" inContext:context];
    }];
    
    expect([dataSource numberOfItems]).will.equal(2);
    
    [[mockTable expect] deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                              withRowAnimation:animation];
    [[mockTable expect] insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:1 inSection:0] ]
                              withRowAnimation:animation];
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        Wizard *w = [Wizard MR_findFirstByAttribute:@"name" withValue:@"Gandalf" inContext:context];
        w.name = @"ZGandalf";
    }];
    
    [mockTable verifyWithDelay:1];
}

- (void)testInsertingItemInsertsRowInCollectionView
{
    dataSource.cellClass = [SSBaseCollectionCell class];
    dataSource.collectionView = collectionView;
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:context];
    }];
    
    expect([dataSource numberOfItemsInSection:0]).will.equal(1);
    expect([collectionView numberOfItemsInSection:0]).will.equal(1);
}

- (void)testInsertingAndDeletingCollectionViewSections
{
    dataSource = [[SSCoreDataSource alloc] initWithFetchRequest:[Wizard MR_requestAllSortedBy:@"name" ascending:YES]
                                                      inContext:[NSManagedObjectContext MR_defaultContext]
                                             sectionNameKeyPath:@"realm"];
    dataSource.cellClass = [SSBaseCollectionCell class];
    dataSource.collectionView = collectionView;
    
    expect([dataSource numberOfItems]).to.equal(0);
    expect([dataSource numberOfSections]).to.equal(0);
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:context];
        [Wizard wizardWithName:@"Pallando" realm:@"Middle-Earth" inContext:context];
    }];
    
    expect([dataSource numberOfSections]).will.equal(1);
    expect([dataSource numberOfItems]).will.equal(2);
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard wizardWithName:@"Merlyn" realm:@"Arthurian" inContext:context];
    }];
    
    expect([dataSource numberOfSections]).will.equal(2);
    expect([dataSource numberOfItems]).will.equal(3);
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        Wizard *w = [Wizard MR_findFirstByAttribute:@"name" withValue:@"Merlyn" inContext:context];
        [w MR_deleteInContext:context];
    }];
    
    expect([dataSource numberOfSections]).will.equal(1);
    expect([dataSource numberOfItems]).will.equal(2);
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

- (void)testDeletingItemDeletesRowInCollectionView
{
    dataSource.cellClass = [SSBaseCollectionCell class];
    dataSource.collectionView = collectionView;

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:context];
    }];

    expect([dataSource numberOfItems]).will.equal(1);
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *context) {
        [Wizard MR_truncateAllInContext:context];
    }];

    expect([dataSource numberOfItems]).will.equal(0);
}

- (void)testDeletingItemDeletesRow
{
    id mockTable = tableView;
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    dataSource.rowAnimation = animation;
    
    [[mockTable expect] deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                              withRowAnimation:animation];
    
    Wizard *w = [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [w MR_deleteInContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [mockTable verify];
}

- (void)_testUpdatingItemReloadsRow
{
    id mockTable = tableView;
    
    UITableViewRowAnimation animation = UITableViewRowAnimationLeft;
    
    dataSource.rowAnimation = animation;
    
    [[mockTable expect] reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ]
                              withRowAnimation:animation];
    
    Wizard *w = [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    w.name = @"Pallando";
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
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
    
    [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:[NSManagedObjectContext MR_defaultContext]];
    [Wizard wizardWithName:@"Melisandre" realm:@"Westeros" inContext:[NSManagedObjectContext MR_defaultContext]];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
    [dataSource tableView:dataSource.tableView
       moveRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
              toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    expect(didMove).to.beTruthy();
}

- (void)testFindingManagedObjects
{
    Wizard *aWizard = [Wizard wizardWithName:@"Gandalf" realm:@"Middle-Earth" inContext:[NSManagedObjectContext MR_defaultContext]];
    
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
