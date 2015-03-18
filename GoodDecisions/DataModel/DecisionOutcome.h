//
//  DecisionOutcome.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/18/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import <Parse/Parse.h>

@interface DecisionOutcome : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;

+ (NSString *)parseClassName;


@end
