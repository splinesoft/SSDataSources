//
//  SSAppDelegate.m
//  ExampleCollectionView
//
//  Created by Jonathan Hersh on 6/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSAppDelegate.h"

@interface SSRootViewController : UIViewController
@end

@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[SSRootViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

#pragma mark -

#import "SSCollectionViewController.h"
#import "SSTableViewController.h"

@interface SSRootViewController ()
@property (nonatomic, strong) UIButton *tableButton;
@property (nonatomic, strong) UIButton *collectionButton;
@end

@implementation SSRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"SSDataSources Examples", nil);
    self.view.backgroundColor = UIColor.lightGrayColor;

    [self.view addSubview:self.tableButton];
    [self.view addSubview:self.collectionButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGFloat buttonWidth = 302.0;
    CGFloat buttonXOffset = floorf((self.view.bounds.size.width - buttonWidth) / 2.0);
    CGFloat buttonVerticalPadding = 44.0;
    CGSize buttonSize = { .width = buttonWidth, .height = 44.0 };
    self.tableButton.frame = (CGRect) {
        .origin.x = buttonXOffset,
        .origin.y = floorf(self.view.bounds.size.height / 2.0) - buttonVerticalPadding*2,
        .size = buttonSize
    };
    self.collectionButton.frame = (CGRect) {
        .origin.x = buttonXOffset,
        .origin.y = floorf(self.view.bounds.size.height / 2.0),
        .size = buttonSize
    };
}

- (void)tableButtonTouched:(id)sender
{
    SSTableViewController *tv = [[SSTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:tv animated:YES];
}

- (void)collectionButtonTouched:(id)sender
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 4.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.sectionInset = UIEdgeInsetsMake( 10, 5, 10, 5 );
    layout.itemSize = CGSizeMake(65, 50);

    SSCollectionViewController *cv = [[SSCollectionViewController alloc] initWithCollectionViewLayout:layout];

    [self.navigationController pushViewController:cv animated:YES];
}

- (UIButton *)tableButton
{
    if (_tableButton == nil) {
        _tableButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_tableButton setTitle:NSLocalizedString(@"Table View Example", nil) forState:UIControlStateNormal];
        [_tableButton addTarget:self action:@selector(tableButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableButton;
}

- (UIButton *)collectionButton
{
    if (_collectionButton == nil) {
        _collectionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_collectionButton setTitle:NSLocalizedString(@"Collection View Example", nil) forState:UIControlStateNormal];
        [_collectionButton addTarget:self action:@selector(collectionButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionButton;
}

@end
