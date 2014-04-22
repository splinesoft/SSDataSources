//
//  SSResultsFilter.h
//  SSDataSources
//
//  Created by Jonathan Hersh on 4/2/14.
//
//

#import <Foundation/Foundation.h>
#import "SSBaseDataSource.h"
#import "SSDataSourceItemAccess.h"

@interface SSResultsFilter : NSObject <SSDataSourceItemAccess>

/**
 *  Start here - create a data source filter with the specified predicate.
 *
 *  @param predicate predicate
 *
 *  @return an initialized filter
 */
+ (instancetype) filterWithPredicate:(NSPredicate *)predicate;

/**
 *  Convenience method to create a filter that evaluates objects using the specified block.
 *
 *  @param filterBlock filter block to use
 *
 *  @return an initialized filter
 */
+ (instancetype) filterWithBlock:(BOOL (^)(id item))filterBlock;

@property (nonatomic, strong) NSPredicate *filterPredicate;
@property (nonatomic, strong) NSMutableArray *sections;

@end
