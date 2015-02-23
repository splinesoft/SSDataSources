//
//  Wizard.m
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 5/31/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import "Wizard.h"

@implementation Wizard

@dynamic name;
@dynamic realm;

+ (instancetype)wizardWithName:(NSString *)name realm:(NSString *)realm {
    return [self wizardWithName:name
                          realm:realm
                      inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (instancetype)wizardWithName:(NSString *)name realm:(NSString *)realm inContext:(NSManagedObjectContext *)context {
    Wizard *wizard = [self MR_createInContext:context];
    
    wizard.name = name;
    wizard.realm = realm;
    
    return wizard;
}

- (BOOL)isEqualToWizard:(Wizard *)w2 {
    return [w2 isKindOfClass:[Wizard class]]
        && [w2.name isEqualToString:self.name]
        && [w2.realm isEqualToString:self.realm];
}

@end
