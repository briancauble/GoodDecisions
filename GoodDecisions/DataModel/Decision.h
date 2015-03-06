//
//  Decision.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionType.h"


@interface Decision : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) DecisionType *type;
@property (nonatomic, strong) PFObject *influence;
@property (nonatomic, strong) PFObject *detail;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) PFGeoPoint *location;

+ (NSString *)parseClassName;

@end
