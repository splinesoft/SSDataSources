SSDataSources
=============

Simple data sources for your `UITableView` and `UICollectionView` because proper developers don't repeat themselves. :)

No doubt you've done the `tableView:cellForRowAtIndexPath:` and `tableView:numberOfRowsInSection:` (and `collectionView:cellForItemAtIndexPath:` and `collectionView:numberOfItemsInSection:`) dance many times before. You may also have updated your data and neglected to update the table or collection view. Whoops -- crash! Is there a better way?

`SSDataSources` is a collection of objects that conform to `UITableViewDataSource` and `UICollectionViewDataSource`. This is my own implementation of ideas featured in [objc.io's wonderful first issue](http://www.objc.io/issue-1/table-views.html).

`SSDataSources` powers various tables in my app [MUDRammer - a modern MUD client for iPhone and iPad](https://itunes.apple.com/us/app/mudrammer-a-modern-mud-client/id597157072?mt=8). Let me know if you use it in your app!

## Install

Install with [Cocoapods](http://cocoapods.org). Add to your podfile:

```
pod 'SSDataSources', :head
```

## Array Data Source

Useful when your data is a simple array. See `SSArrayDataSource.h` for more details.

Check out `ExampleTable` and `ExampleCollectionView` for sample table and collection views that use the array data source.


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

	// The configure block is called for each cell with the object being presented in that cell.
    wizardDataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSString *wizard) {
        cell.textLabel.text = wizard;
    };
    
    // Set the table's data source.
    self.tableView.dataSource = wizardDataSource;
}
@end
```

That's it - you're done! 

Perhaps your data changes:

```objc
// Optional - row animation for table updates.
wizardDataSource.rowAnimation = UITableViewRowAnimationFade;

// Optional - if you set the tableView property, the data source will perform
// insert/reload/delete calls on the table as its data changes.
wizardDataSource.tableView = self.tableView;
	
// Automatically inserts two new cells at the end of the table.
[wizardDataSource appendItems:@[ @"Saruman", @"Alatar" ]];

// Update the fourth item; reloads the fourth row.
[wizardDataSource replaceItemAtIndex:3 withItem:@"Pallando"];
	
// Remove the second and third cells.
[wizardDataSource removeItemsInRange:NSMakeRange( 1, 2 )];
```

Perhaps you have custom table cell classes or multiple classes in the same table:

```objc
__weak typeof (self.tableView) weakTable = self.tableView;

wizardDataSource.cellCreationBlock = ^id(NSString *wizard) {
	if( [wizard isEqualToString:@"Gandalf"] )
		return [MiddleEarthWizardCell cellForTableView:weakTable];
	else if( [wizard isEqualToString:@"Merlyn"] )
		return [ArthurianWizardCell cellForTableView:weakTable];
};

```

Your view controller should continue to implement `UITableViewDelegate`. `SSDataSources` can help there too:

```objc
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *wizard = [wizardDataSource itemAtIndexPath:indexPath];
	
	// do something with `wizard`
}
```

## Core Data

You're a scholar, a man-/woman-about-internet, and sometimes you want to present a `UITableView` or `UICollectionView` backed by a core data fetch request or fetched results controller. `SSDataSources` has got you covered with `SSCoreDataSource`, featured here with a cameo by [MagicalRecord](https://github.com/magicalpanda/MagicalRecord).

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
                                                      inContext:[NSManagedObjectContext MR_defaultContext]
                                             sectionNameKeyPath:nil];
                                                 
    dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, Trigger *trigger) {
        cell.textLabel.text = trigger.name;
    };
    
    // Set the table data source.
    self.tableView.dataSource = dataSource;
    
    // Optional - setting the `tableView` property will automatically update the table in response to core data
    // insert, update, and delete events.
    dataSource.tableView = self.tableView;
    
    // Optional - row animation to use for update events.
    dataSource.rowAnimation = UITableViewRowAnimationFade;
    
    // Optional - setting the fallbackTableDataSource will call 
    // tableView:canEditRowAtIndexPath: and
    // tableView:commitEditingStyle:forRowAtIndexPath 
    // on your fallback delegate, so you can implement editing if necessary.
    dataSource.fallbackTableDataSource = self;
}
@end
```

## Thanks!

`SSDataSources` is a [@jhersh](https://github.com/jhersh) production -- ([electronic mail](mailto:jon@her.sh) | [@jhersh](https://twitter.com/jhersh))
