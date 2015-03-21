//
//  Decision.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionType.h"
#import "DecisionOutcome.h"
#import "DecisionInfluence.h"


@interface Decision : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) DecisionType *type;
@property (nonatomic, strong) DecisionInfluence *influence;
@property (nonatomic, strong) DecisionOutcome *outcome;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSArray *influences;
@property (nonatomic, strong) NSArray *outcomes;


+ (NSString *)parseClassName;

+ (void) findAllDecisionsWithResult:(PFArrayResultBlock)result;


@end
