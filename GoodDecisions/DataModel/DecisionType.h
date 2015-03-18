//
//  DecisionType.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import <Parse/Parse.h>

@interface DecisionType : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *defaultReminderPrompt;
@property (nonatomic, strong) NSString *name;


+ (NSString *) parseClassName;
+ (UILocalNotification *) notification;

+ (void) findAllDecisionTypesWithResult:(PFArrayResultBlock)result;

- (void) findAllInfluencesWithResult:(PFArrayResultBlock)result;
- (void) findAllOutcomesWithResult:(PFArrayResultBlock)result;

@end
