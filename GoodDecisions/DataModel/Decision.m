//
//  Decision.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "Decision.h"

@implementation Decision

@dynamic type, score, user, detail, influence, location;


+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"Decision";
}
@end
