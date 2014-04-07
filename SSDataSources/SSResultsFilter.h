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
 *  Start here - create a data source filter with the specified filter predicate block.
 *
 *  @param predicate predicate block to use
 *
 *  @return an initialized filter
 */
+ (instancetype) filterWithPredicate:(SSFilterPredicate)predicate;

@property (nonatomic, copy) SSFilterPredicate filterPredicate;
@property (nonatomic, strong) NSMutableArray *sections;

@end
