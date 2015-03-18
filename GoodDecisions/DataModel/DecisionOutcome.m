//
//  DecisionOutcome.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/18/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionOutcome.h"

@implementation DecisionOutcome

@dynamic name;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"DecisionOutcome";
}

@end
