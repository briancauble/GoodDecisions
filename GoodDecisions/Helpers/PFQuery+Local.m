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
    __block NSError *blockError = nil;
    [queryCopy findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //if data is removed from the backend the local pin doens't seem to be removed, so we're attempting to fix that here.
            [queryCopy findObjectsFromLocalDatastoreInBackgroundWithBlock:^(NSArray *localObjects, NSError *error) {
                if(!error){
                    if([localObjects count] != [objects count]) //refresh the pinned objects
                        [PFObject unpinAllInBackground:localObjects block:^(BOOL succeeded, NSError *error) {
                            if(succeeded){
                                [PFObject pinAllInBackground:objects];
                                success = YES;
                            }else{
                                DDLogWarn(@"%@", [error userInfo][@"error"]);
                                blockError = error;
                            }
                        }];
                    
                }else{
                    DDLogWarn(@"%@", [error userInfo][@"error"]);
                    blockError = error;
                }
            }];
        }else{
            DDLogWarn(@"%@", [error userInfo][@"error"]);
            blockError = error;
        }
    }];
    
    result?result(success, blockError):nil;
}

-(BFTask *)findObjectsFromLocalDatastoreInBackground{
    [self fromLocalDatastore];
    return [self findObjectsInBackground];
}

-(void)findObjectsFromLocalDatastoreInBackgroundWithBlock:(PFArrayResultBlock)block{
    [self fromLocalDatastore];
    [self findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block?block(objects, error):nil;
    }];
}

@end
