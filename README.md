SSDataSources
=============

Simple data sources for your `UITableView`, because lazy developers don't repeat themselves. :)

No doubt you've done the `tableView:cellForRowAtIndexPath:` and `tableView:numberOfRowsInSection:` dance many times before. You may also have updated your data  and neglected to update the table. Whoops -- crash! Is there a better way?

Here comes `SSDataSources`, a collection of objects that serve as `UITableView` data sources. This is my own implementation of ideas featured in [objc.io's wonderful first issue](http://www.objc.io/issue-1/table-views.html).

`SSDataSources` are used in production in my app [MUDRammer - a modern MUD client for iPhone and iPad](https://itunes.apple.com/us/app/mudrammer-a-modern-mud-client/id597157072?mt=8). Let me know if you use them in your app!

## Install

Install with cocoapods. Add to your podfile:

```
pod 'SSDataSources', :git => 'git@github.com:splinesoft/SSDataSources.git'
```

## Array Data Source

Useful when your data is a simple array. See `SSTableArrayDataSource.h` for more details.

```
// MyTableViewController.m

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.dataSource = [[SSTableArrayDataSource alloc] initWithItems:@[ @1, @2, @3, @4, @5 ]];
	
	// The configure block is called for each cell with the object being presented in that cell.
	dataSource.cellConfigureBlock = ^(SSBaseTableCell *cell, NSNumber *number) {
		cell.textView.text = [NSString stringWithFormat:@"Cell #%@", number];
	};
	
	// Set the table's data source.
	self.tableView.dataSource = dataSource;
	
	// Optional - row animation for table updates.
	dataSource.rowAnimation = UITableViewRowAnimationFade;
}
```

That's it - you're done! 

Perhaps, though, your data changes. No problem!

```
// Optional - if you set the tableView property, the data source will perform
// insert/reload/delete calls as its data changes.
dataSource.tableView = self.tableView;
	
// Automatically inserts two new cells at the end of the table!
[self.dataSource appendItems:@[ @6, @7 ]];
	
// Remove the second and third cells.
[self.dataSource removeItemsInRange:NSMakeRange( 1, 2 )];
```

Your view controller should continue to implement `UITableViewDelegate`. `SSDataSources` makes that easier too:

```
- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id item = [dataSource itemAtIndexPath:indexPath];
	
	// do something with `item`
}
```

## Core Data

You're a scholar, a man- (or woman)-about-the-world, and sometimes you want to present a `UITableView` backed by a core data fetch request or fetched results controller. `SSDataSources` has got you covered with `SSTableFRCDataSource`, featured here with a cameo by [MagicalRecord](https://github.com/magicalpanda/MagicalRecord).

```
// MyCoreDataTableViewController.m

- (void) viewDidLoad {
	[super viewDidLoad];
	
	NSFetchRequest *triggerFetch = [Trigger MR_requestAllSortedBy:[Trigger defaultSortField]
                                                        ascending:[Trigger defaultSortAscending]];
        
    SSTableViewCellConfigureBlock trigConfig = ^(SSBaseTableCell *cell, Trigger *trigger) {
        cell.textLabel.text = trigger.name;
    };
    
    dataSource = [[SSTableFRCDataSource alloc] initWithFetchRequest:worldFetch
                                                          inContext:[NSManagedObjectContext MR_defaultContext]
                                                 sectionNameKeyPath:nil];
                                                 
    dataSource.cellConfigureBlock = trigConfig;
    
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

```

## Thanks!

Please do let me know if you find `SSDataSources` useful. Pull requests welcome!

Coming soon: data sources for `UICollectionView`.