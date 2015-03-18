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

+(void)findAllDecisionTypesWithResult:(PFArrayResultBlock)result{
    
    PFQuery *query = [DecisionType query];
    [query orderByAscending:@"sortIndex"];
    //check network first (10 second timeout)
    [query updateLocalDataStoreWithResult:^(BOOL succeeded, NSError *error) {
        //whether it succeeds or fails, grab data from local
            [query findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    DDLogError(@"%@", [error userInfo][@"error"]);
                }
                result?result(objects, error):nil;
            }];
     }];
}

-(void)findAllInfluencesWithResult:(PFArrayResultBlock)result{
    PFQuery *whyQuery = [PFQuery queryWithClassName:@"DecisionInfluence"];
    [whyQuery orderByAscending:@"sortIndex"];
    [whyQuery whereKey:@"type" equalTo:self];
    [whyQuery updateLocalDataStore];
    [whyQuery findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            DDLogError(@"%@", [error userInfo][@"error"]);
        }
        
        result?result(objects, error):nil;
        
    }];
}

-(void)findAllOutcomesWithResult:(PFArrayResultBlock)result{
    PFQuery *whatQuery = [PFQuery queryWithClassName:@"DecisionOutcome"];
    [whatQuery orderByAscending:@"sortIndex"];
    [whatQuery whereKey:@"type" equalTo:self];
    [whatQuery updateLocalDataStore];
    [whatQuery findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            DDLogError(@"%@", [error userInfo][@"error"]);
        }
        result?result(objects, error):nil;
    }];
}
@end
