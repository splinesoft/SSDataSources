//
//  SSBaseTableCell.h
//  Mudrammer
//
//  Created by Jonathan Hersh on 1/5/13.
//  Copyright (c) 2013 Jonathan Hersh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSBaseTableCell : UITableViewCell

+ (NSString *) identifier;

+ (UITableViewCellStyle) cellStyle;

+ (id) cellForTableView:(UITableView *)tableView;

// Called after init.
- (void) configureCell;

@end
