//
//  Decision.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "Decision.h"
#import "PFQuery+Local.h"


@implementation Decision

@dynamic type, score, user, outcome, influence, location;


+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"Decision";
}

+(void)findAllDecisionsWithResult:(PFArrayResultBlock)result{
    PFQuery *query = [Decision query];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    query.limit = 200;
    [query includeKey:@"influence"];
    [query includeKey:@"outcome"];
    [query findAndPinObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            result?result(objects, error):nil;
        }
    }];
    
}
@end
