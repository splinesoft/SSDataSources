SSDataSources
=============

Simple data sources for your `UITableView`, because proper developers don't repeat themselves. :)

No doubt you've done the `tableView:cellForRowAtIndexPath:` and `tableView:numberOfRowsInSection:` dance many times before. You may also have updated your data and neglected to update the table. Whoops -- crash! Is there a better way?

`SSDataSources` is a collection of objects that conform to `UITableViewDataSource`. This is my own implementation of ideas featured in [objc.io's wonderful first issue](http://www.objc.io/issue-1/table-views.html).

`SSDataSources` powers various tables in my app [MUDRammer - a modern MUD client for iPhone and iPad](https://itunes.apple.com/us/app/mudrammer-a-modern-mud-client/id597157072?mt=8). Let me know if you use it in your app!

## Install

Install with [Cocoapods](http://cocoapods.org). Add to your podfile:

```
pod 'SSDataSources', :git => 'https://github.com/splinesoft/SSDataSources.git'
```

## Array Data Source

Check out `ExampleTable` for a sample table that uses the array data source.

Useful when your data is a simple array. See `SSTableArrayDataSource.h` for more details.

```objc
@interface SSTableViewController : UITableViewController
@end

@implementation SSTableViewController {
    SSTableArrayDataSource *tableDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    tableDataSource = [[SSTableArrayDataSource alloc] initWithItems:@[ @1337, @1242, @1389 ]];

	// The configure block is called for each cell with the object being presented in that cell.
    tableDataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSNumber *number) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", number];
    };
    
    // Set the table's data source.
    self.tableView.dataSource = dataSource;
}
@end
```

That's it - you're done! 

Perhaps your data changes:

```objc
// Optional - row animation for table updates.
tableDataSource.rowAnimation = UITableViewRowAnimationFade;

// Optional - if you set the tableView property, the data source will perform
// insert/reload/delete calls as its data changes.
tableDataSource.tableView = self.tableView;
	
// Automatically inserts two new cells at the end of the table
[tableDataSource appendItems:@[ @6, @7 ]];

// Update the fourth item. Reloads the fourth row.
[tableDatasource replaceItemAtIndex:3 withItem:@11];
	
// Remove the second and third cells.
[tableDataSource removeItemsInRange:NSMakeRange( 1, 2 )];
```

Your view controller should continue to implement `UITableViewDelegate`. `SSDataSources` makes that easier too:

```objc
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id item = [dataSource itemAtIndexPath:indexPath];
	
	// do something with `item`
}
```

## Core Data

You're a scholar, a man-/woman-about-internet, and sometimes you want to present a `UITableView` backed by a core data fetch request or fetched results controller. `SSDataSources` has got you covered with `SSTableFRCDataSource`, featured here with a cameo by [MagicalRecord](https://github.com/magicalpanda/MagicalRecord).

```objc
@interface SSCoreDataTableViewController : UITableViewController
@end

@implementation SSCoreDataTableViewController {
    SSTableFRCDataSource *dataSource;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	NSFetchRequest *triggerFetch = [Trigger MR_requestAllSortedBy:[Trigger defaultSortField]
                                                        ascending:[Trigger defaultSortAscending]];
   
    dataSource = [[SSTableFRCDataSource alloc] initWithFetchRequest:worldFetch
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
    
    // Optional - setting the fallbackDataSource will call 
    // tableView:canEditRowAtIndexPath: and
    // tableView:commitEditingStyle:forRowAtIndexPath 
    // on your fallback delegate, so you can implement editing if necessary.
    dataSource.fallbackDataSource = self;
}
@end
```

## Thanks!

Coming soon: data sources for `UICollectionView`.