//
//  PFQuery+Local.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/9/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "PFQuery+Local.h"

@implementation PFQuery (Local)

-(void)updateLocalDataStore{
    [self updateLocalDataStoreWithResult:nil];
}

-(void)updateLocalDataStoreWithResult:(PFBooleanResultBlock)result{
    PFQuery *queryCopy = [self copy]; //use a copy to avoid conflicts
    
    __block BOOL success = NO;
    [queryCopy findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //if data is removed from the backend the local pin doens't seem to be removed, so we're attempting to fix that here.
            [PFObject pinAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [queryCopy findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *localObjects, NSError *error) {
                        if(!error){
                            NSMutableSet *localSet = [NSMutableSet setWithArray:localObjects];
                            NSSet *remoteSet = [NSSet setWithArray:objects];
                            [localSet minusSet:remoteSet];

                            if([localSet count]){
                                DDLogDebug(@"extra local object !");
                                [localSet enumerateObjectsUsingBlock:^(PFObject *obj, BOOL *stop) {
                                    if ([obj.objectId isEqualToString:@"new"]) {
                                        DDLogDebug(@"extra local object has not saved yet - not deleting");
                                    }else{
                                        DDLogDebug(@"unpinning object %@", obj);
                                        //unpinning seems broken.
                                        [obj unpinInBackground];
                                    }
                                }];
                            }
                            result?result(YES, error):nil;

                        }else{
                            DDLogWarn(@"%@", [error userInfo][@"error"]);
                            result?result(success, error):nil;
                        }
                    }];
                }else{
                    DDLogWarn(@"%@", [error userInfo][@"error"]);
                    result?result(success, error):nil;
                }
            }];
        }else{
            DDLogWarn(@"%@", [error userInfo][@"error"]);
            result?result(success, error):nil;
        }
    }];
    
}

-(BFTask *)findObjectsFromLocalDatastoreInBackground{
    PFQuery *queryCopy = [self copy]; //use a copy to avoid conflicts

    [queryCopy fromLocalDatastore];
    return [queryCopy findObjectsInBackground];
}

-(void)findObjectsFromLocalDatastoreInBackgroundWithBlock:(PFArrayResultBlock)block{
    PFQuery *queryCopy = [self copy]; //use a copy to avoid conflicts

    [queryCopy fromLocalDatastore];
    [queryCopy findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block?block(objects, error):nil;
    }];
}

-(void)findAndPinObjectsInBackgroundWithBlock:(PFArrayResultBlock)block{
    PFQuery *queryCopy = [self copy]; //use a copy to avoid conflicts

    [queryCopy findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            block?block(objects, error):nil;
        }else{
            DDLogWarn(@"%@", [error userInfo][@"error"]);
        }
    }];
    
    [queryCopy findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            block?block(objects, error):nil;

            //if data is removed from the backend the local pin doens't seem to be removed, so we're attempting to fix that here.
            [PFObject pinAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [queryCopy findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *localObjects, NSError *error) {
                        if(!error){
                            NSMutableSet *localSet = [NSMutableSet setWithArray:localObjects];
                            NSSet *remoteSet = [NSSet setWithArray:objects];
                            [localSet minusSet:remoteSet];
                            
                            if([localSet count]){
                                DDLogDebug(@"extra local object !");
                                [localSet enumerateObjectsUsingBlock:^(PFObject *obj, BOOL *stop) {
                                    if ([obj.objectId isEqualToString:@"new"]) {
                                        DDLogDebug(@"extra local object has not saved yet - not deleting");
                                    }else{
                                        [obj unpinInBackground];
                                    }
                                }];
                            }
                        }else{
                            DDLogWarn(@"%@", [error userInfo][@"error"]);
                        }
                    }];
                }else{
                    DDLogWarn(@"%@", [error userInfo][@"error"]);
                }
            }];
            
        }else{
            DDLogWarn(@"%@", [error userInfo][@"error"]);
        }
    }];
}
@end
