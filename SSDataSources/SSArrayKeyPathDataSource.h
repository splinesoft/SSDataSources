//
//  SSArrayKeyPathDataSource.h
//  SSDataSources
//
//  Created by Andrew Sardone on 4/3/14.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSBaseDataSource.h"
#import "SSArrayDataSource.h"

/**
 * Data source for single-sectioned table and collection views that's backed by
 * an array (representing a to-many relationship) on some target object. Data
 * updates are channeled via KVO.
 */
@interface SSArrayKeyPathDataSource : SSBaseDataSource <SSArrayItemAccess>

/**
 * Designated initializer.
 *
 * @param target - the object that the given key path is relative to
 * @param keyPath - a key path for that identifiers an NSArray of data for the receiver
 */
- (instancetype)initWithTarget:(id)target keyPath:(NSString *)keyPath;

@end
