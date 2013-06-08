//
//  SSBaseTableCell.h
//  Splinesoft
//
//  Created by Jonathan Hersh on 1/5/13.
//  Copyright (c) 2013 Jonathan Hersh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A simple base table cell. Subclass me and override configureCell.
 * Override cellStyle and identifier only if necessary.
 */

@interface SSBaseTableCell : UITableViewCell

+ (NSString *) identifier;

+ (UITableViewCellStyle) cellStyle;

+ (id) cellForTableView:(UITableView *)tableView;

// Called after init.
- (void) configureCell;

@end
