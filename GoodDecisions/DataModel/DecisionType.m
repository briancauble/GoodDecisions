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
    //check local first
    PFQuery *networkQuery = [query copy];
    [query updateLocalDataStore];


    [query findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            DDLogError(@"%@", [error userInfo][@"error"]);
        }
        result?result(objects, error):nil;
    }];
    
    
    [networkQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            DDLogError(@"%@", [error userInfo][@"error"]);
        }
        result?result(objects, error):nil;
    }];
    
//    //check remote and also return
//    [query updateLocalDataStoreWithResult:^(BOOL succeeded, NSError *error) {
//        
//        [query findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (error) {
//                DDLogError(@"%@", [error userInfo][@"error"]);
//            }
//            result?result(objects, error):nil;
//        }];
//
//        if (error) {
//            DDLogError(@"%@", [error userInfo][@"error"]);
//        }
//     }];
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
