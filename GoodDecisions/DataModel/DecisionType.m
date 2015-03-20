//
//  DecisionType.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionType.h"
#import "PFQuery+Local.h"

@implementation DecisionType
@dynamic defaultReminderPrompt, name;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"DecisionType";
}


+(UILocalNotification *)notification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.category = @"Reminder";
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    return localNotification;
}

+(PFQuery *)query{
    return [[PFQuery queryWithClassName:@"DecisionType"] orderByAscending:@"sortIndex"];
}

+(void)findAllDecisionTypesWithResult:(PFArrayResultBlock)result{
    
    PFQuery *query = [DecisionType query];
    [query findAndPinObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            result?result(objects, error):nil;
        }
    }];
    
}

-(void)findAllInfluencesWithResult:(PFArrayResultBlock)result{
    PFQuery *query = [PFQuery queryWithClassName:@"DecisionInfluence"];
    [query orderByAscending:@"sortIndex"];
    [query whereKey:@"type" equalTo:self];
    [query updateLocalDataStore];
    [query findAndPinObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            result?result(objects, error):nil;
        }
    }];}

-(void)findAllOutcomesWithResult:(PFArrayResultBlock)result{
    PFQuery *query = [PFQuery queryWithClassName:@"DecisionOutcome"];
    [query orderByAscending:@"sortIndex"];
    [query whereKey:@"type" equalTo:self];
    [query updateLocalDataStore];
    [query findAndPinObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            result?result(objects, error):nil;
        }
    }];
}
@end
