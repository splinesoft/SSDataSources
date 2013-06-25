//
//  SSBaseTableCell.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 1/5/13.
//  Copyright (c) 2013 Jonathan Hersh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A simple base table cell. Subclass me and override configureCell
 * to add custom one-time logic (e.g. creating subviews).
 * You probably don't need to override cellStyle and identifier.
 */

@interface SSBaseTableCell : UITableViewCell

+ (NSString *) identifier;

+ (UITableViewCellStyle) cellStyle;

+ (id) cellForTableView:(UITableView *)tableView;

// Called once for each cell after initial init.
- (void) configureCell;

@end
