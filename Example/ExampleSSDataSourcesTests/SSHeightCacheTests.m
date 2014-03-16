#import "SSTestHelper.h"
#import <SSDataSources.h>

@interface SSHeightCacheTests : SenTestCase

@end

@implementation SSHeightCacheTests
{
    SSHeightCache *cache;
}

- (void)setUp
{
    [super setUp];
    
    cache = [SSHeightCache new];
}

- (void)tearDown
{
    [cache removeAllObjects];
    
    [super tearDown];
}

- (void)testHeightCacheStoresHeights
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [cache cacheHeight:100.0f forRowAtIndexPath:index];
    
    expect([cache cachedHeightForRowAtIndexPath:index]).to.equal(100.0f);
}

- (void)testHeightCacheStoresSizes
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    CGSize size = CGSizeMake(100, 300);
    [cache cacheSize:size forRowAtIndexPath:index];
    
    expect([cache cachedSizeForRowAtIndexPath:index]).to.equal(size);
}

- (void)testHeightCacheEmptiesItems
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [cache cacheHeight:100.0f forRowAtIndexPath:index];
    
    [cache removeCachedHeightForRowAtIndexPath:index];
    
    expect([cache cachedHeightForRowAtIndexPath:index]).to.equal(0);
}

- (void)testHeightCacheEmptiesAll
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [cache cacheHeight:100.0f forRowAtIndexPath:index];
    
    [cache removeAllCachedHeights];
    
    expect([cache cachedHeightForRowAtIndexPath:index]).to.equal(0);
}

@end
