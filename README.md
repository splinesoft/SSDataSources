SSDataSources
=============

![](http://cocoapod-badges.herokuapp.com/v/SSDataSources/badge.png) &nbsp; ![](http://cocoapod-badges.herokuapp.com/p/SSDataSources/badge.png) &nbsp; [![Build Status](https://travis-ci.org/splinesoft/SSDataSources.png?branch=master)](https://travis-ci.org/splinesoft/SSDataSources)

Simple data sources for your `UITableView` and `UICollectionView` because proper developers don't repeat themselves. :)

No doubt you've done the `tableView:cellForRowAtIndexPath:` and `tableView:numberOfRowsInSection:` (and `collectionView:cellForItemAtIndexPath:` and `collectionView:numberOfItemsInSection:`) dance many times before. You may also have updated your data and neglected to update the table or collection view. Whoops -- crash! Is there a better way?

`SSDataSources` is a collection of objects that conform to `UITableViewDataSource` and `UICollectionViewDataSource`. This is my own implementation of ideas featured in [objc.io's wonderful first issue](http://www.objc.io/issue-1/table-views.html).

`SSDataSources` powers various tables in my app [MUDRammer - a modern MUD client for iPhone and iPad](https://itunes.apple.com/us/app/mudrammer-a-modern-mud-client/id597157072?mt=8). Let me know if you use it in your app!

## Install

Install with [Cocoapods](http://cocoapods.org). Add to your podfile:

```
pod 'SSDataSources', :head # YOLO
```

## Samples

```
git clone https://github.com/splinesoft/SSDataSources.git
cd SSDataSources/Example
pod install
open ExampleSSDataSources.xcworkspace
```

## Array Data Source

`SSArrayDataSource` powers a table or collection view with a single section. See `SSArrayDataSource.h` for more details.

Check out the example project for sample table and collection views that use the array data source.


```objc
@interface WizardicTableViewController : UITableViewController
@end

@implementation WizardicTableViewController {
    SSArrayDataSource *wizardDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    wizardDataSource = [[SSArrayDataSource alloc] initWithItems:
                        @[ @"Merlyn", @"Gandalf", @"Melisandre" ]];

	// SSDataSources creates your cell and calls
	// this configure block for each cell with 
	// the object being presented in that cell,
	// the parent table or collection view,
	// and the index path at which the cell appears.
    wizardDataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, 
                                            NSString *wizard,
                                            UITableView *tableView,
                                            NSIndexPath *indexPath) {
        cell.textLabel.text = wizard;
    };
    
    // Set the tableView property and the data source will perform
    // insert/reload/delete calls on the table as its data changes.
    // This also assigns the table's `dataSource` property.
    wizardDataSource.tableView = self.tableView;
}
@end
```

That's it - you're done! 

Perhaps your data changes:

```objc
// Optional - row animation for table updates.
wizardDataSource.rowAnimation = UITableViewRowAnimationFade;
	
// Automatically inserts two new cells at the end of the table.
[wizardDataSource appendItems:@[ @"Saruman", @"Alatar" ]];

// Update the fourth item; reloads the fourth row.
[wizardDataSource replaceItemAtIndex:3 withItem:@"Pallando"];

// Sorry Merlyn :(
[wizardDataSource moveItemAtIndex:0 toIndex:1];
	
// Remove the second and third cells.
[wizardDataSource removeItemsInRange:NSMakeRange( 1, 2 )];
```

Perhaps you have custom table cell classes or multiple classes in the same table:

```objc
wizardDataSource.cellCreationBlock = ^id(NSString *wizard, 
                                         UITableView *tableView, 
                                         NSIndexPath *indexPath) {
	if( [wizard isEqualToString:@"Gandalf"] )
		return [MiddleEarthWizardCell cellForTableView:tableView];
	else if( [wizard isEqualToString:@"Merlyn"] )
		return [ArthurianWizardCell cellForTableView:tableView];
};

```

Your view controller should continue to implement `UITableViewDelegate`. `SSDataSources` can help there too:

```objc
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *wizard = [wizardDataSource itemAtIndexPath:indexPath];
	
	// do something with `wizard`
}
```

## Sectioned Data Source

`SSSectionedDataSource` powers a table or collection view with multiple sections. Each section is modeled with an `SSSection` object, which stores the section's items and a few other configurable bits. See `SSSectionedDataSource.h` and `SSSection.h` for more details.

Check out the example project for a sample table that uses the sectioned data source.

```objc
@interface ElementalTableViewController : UITableViewController
@end

@implementation ElementalTableViewController {
    SSSectionedDataSource *elementDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Let's start with one section
    elementDataSource = [[SSSectionedDataSource alloc] initWithItems:@[ @"Earth" ]];

    elementDataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, 
                                             NSString *element,
                                             UITableView *tableView,
                                             NSIndexPath *indexPath) {
        cell.textLabel.text = element;
    };
    
    // Setting the tableView property automatically updates 
    // the table in response to data changes.
    // This also sets the table's `dataSource` property.
    elementDataSource.tableView = self.tableView;
}
@end
```

`SSSectionedDataSource` has you covered if your data changes:
 
```objc
// Animation for table updates
elementDataSource.rowAnimation = UITableViewRowAnimationFade;

// Add some new sections
[elementDataSource appendSection:[SSSection sectionWithItems:@[ @"Fire" ]]];
[elementDataSource appendSection:[SSSection sectionWithItems:@[ @"Wind" ]]];
[elementDataSource appendSection:[SSSection sectionWithItems:@[ @"Water" ]]];
[elementDataSource appendSection:[SSSection sectionWithItems:@[ @"Heart", @"GOOOO PLANET!" ]]];

// Are you 4 srs, heart?
[elementDataSource removeSectionAtIndex:( [elementDataSource numberOfSections] - 1 )];
```

## Core Data

You're a modern wo/man-about-Internet and sometimes you want to present a `UITableView` or `UICollectionView` backed by a core data fetch request or fetched results controller. `SSDataSources` has you covered with `SSCoreDataSource`, featured here with a cameo by [MagicalRecord](https://github.com/magicalpanda/MagicalRecord).

```objc
@interface SSCoreDataTableViewController : UITableViewController
@end

@implementation SSCoreDataTableViewController {
    SSCoreDataSource *dataSource;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	NSFetchRequest *triggerFetch = [Trigger MR_requestAllSortedBy:[Trigger defaultSortField]
                                                        ascending:[Trigger defaultSortAscending]];
   
    dataSource = [[SSCoreDataSource alloc] initWithFetchRequest:worldFetch
                                                      inContext:[NSManagedObjectContext 
                                                                 MR_defaultContext]
                                             sectionNameKeyPath:nil];
                                                 
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, 
                                      Trigger *trigger, 
                                      UITableView *tableView,
                                      NSIndexPath *indexPath ) {
        cell.textLabel.text = trigger.name;
    };
    
    // SSCoreDataSource conforms to NSFetchedResultsControllerDelegate.
    // Set the `tableView` property to automatically update the table 
    // after changes in the data source's managed object context.
    // This also sets the tableview's `dataSource`.
    dataSource.tableView = self.tableView;
    
    // Optional - row animation to use for update events.
    dataSource.rowAnimation = UITableViewRowAnimationFade;
    
    // Optional - setting the fallbackTableDataSource will call 
    // tableView:canEditRowAtIndexPath:
    // tableView:canMoveRowAtIndexPath:
    // tableView:commitEditingStyle:forRowAtIndexPath 
    // on your fallback delegate if you need to implement editing and moving
    dataSource.fallbackTableDataSource = self;
}
@end
```

## Thanks!

`SSDataSources` is a [@jhersh](https://github.com/jhersh) production -- ([electronic mail](mailto:jon@her.sh) | [@jhersh](https://twitter.com/jhersh))
