//
//  SSSection.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 8/29/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSDataSources.h"

@implementation SSSection

+ (instancetype)sectionWithItems:(NSArray *)items {
    SSSection *section = [SSSection new];
    section.items = [NSMutableArray arrayWithArray:items];
    section.headerClass = [SSBaseHeaderFooterView class];
    section.footerClass = [SSBaseHeaderFooterView class];
  
    return section;
}

+ (instancetype)sectionWithNumberOfItems:(NSUInteger)numberOfItems {
    NSMutableArray *array = [NSMutableArray new];
    
    for( NSUInteger i = 0; i < numberOfItems; i++ )
        [array addObject:@(i)];
    
    return [self sectionWithItems:array];
}

- (NSUInteger)numberOfItems {
    return [self.items count];
}

- (id)itemAtIndex:(NSUInteger)index {
    return self.items[index];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    SSSection *newSection = [SSSection sectionWithItems:self.items];
    newSection.header = self.header;
    newSection.footer = self.footer;
    newSection.headerClass = self.headerClass;
    newSection.footerClass = self.footerClass;
    newSection.headerHeight = self.headerHeight;
    newSection.footerHeight = self.footerHeight;
  
    return newSection;
}

@end
