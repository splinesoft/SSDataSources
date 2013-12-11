//
//  SSSection.h
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 8/29/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * SSSection models a single section in a multi-sectioned table or collection view
 * powered by `SSSectionedDataSource`.
 * It maintains an array of items appearing within its section,
 * plus a header and footer string.
 */

@interface SSSection : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableArray *items;

/**
 * I find it helpful to assign an identifier to each section
 * particularly when constructing tables that have dynamic numbers and types of sections.
 * This identifier is used in the `SSSectionedDataSource` helper method
 * indexOfSectionWithIdentifier:.
 */
@property (nonatomic, strong) id sectionIdentifier;

/**
 * Simple strings to use for headers and footers.
 * Alternatively, you can use an `SSBaseHeaderFooterView`.
 * See the headerClass and footerClass properties.
 */
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;

/**
 * Optional custom classes to use for header and footer views.
 * Defaults to SSBaseHeaderFooterView.
 */
@property (nonatomic, weak) Class headerClass;
@property (nonatomic, weak) Class footerClass;

/**
 * Optional header and footer height.
 * Given that `tableView:heightForHeaderInSection:` is part of 
 * UITableViewDelegate, NOT UITableViewDataSource, 
 * SSDataSources does not provide an implementation. These properties
 * are merely helpers so that you can write simpler delegate code similar to this:
 *
   - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return [mySectionedDataSource heightForHeaderInSection:section];
   }
 *
 */
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

/**
 * Create a section with an array of items.
 */
+ (instancetype) sectionWithItems:(NSArray *)items;
+ (instancetype) sectionWithItems:(NSArray *)items
                           header:(NSString *)header
                           footer:(NSString *)footer
                       identifier:(id)identifier;

/**
 * Sometimes I just need a section with a given number of cells,
 * and all the cell creation and configuration is handled with values stored elsewhere.
 * This method creates a section with the specified number of placeholder objects.
 */
+ (instancetype) sectionWithNumberOfItems:(NSUInteger)numberOfItems;
+ (instancetype) sectionWithNumberOfItems:(NSUInteger)numberOfItems
                                   header:(NSString *)header
                                   footer:(NSString *)footer
                               identifier:(id)identifier;

/**
 * Return the number of items in this section.
 */
- (NSUInteger) numberOfItems;

/**
 * Return the item at a particular index.
 */
- (id) itemAtIndex:(NSUInteger)index;

@end
