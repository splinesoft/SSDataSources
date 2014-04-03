//
//  SSArrayKeyPathDataSource.h
//  SSDataSources
//
//  Created by Andrew Sardone on 4/3/14.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSBaseDataSource.h"

/**
 * TODO Write documentation
 */
@interface SSArrayKeyPathDataSource : SSBaseDataSource

/**
 * TODO Write documentation
 */
- (instancetype)initWithSource:(id)source keyPath:(NSString *)keyPath;

@end
