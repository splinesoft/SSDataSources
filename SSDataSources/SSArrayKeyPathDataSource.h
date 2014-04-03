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
 * TODO Write documentation
 */
@interface SSArrayKeyPathDataSource : SSBaseDataSource <SSArrayItemAccess>

/**
 * TODO Write documentation
 */
- (instancetype)initWithSource:(id)source keyPath:(NSString *)keyPath;

@end
