//
//  Wizard.h
//  ExampleSSDataSources
//
//  Created by Jonathan Hersh on 5/31/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData+MagicalRecord.h>

@interface Wizard : NSManagedObject

+ (instancetype) wizardWithName:(NSString *)name realm:(NSString *)realm;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * realm;

- (BOOL) isEqualToWizard:(Wizard *)w2;

@end
