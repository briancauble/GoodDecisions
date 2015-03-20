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
                    if([localObjects count] != [objects count]){ //refresh the pinned objects
                        [PFObject unpinAllInBackground:localObjects block:^(BOOL succeeded, NSError *error) {
                            if(succeeded){
                                [PFObject pinAllInBackground:objects];
                                success = YES;
                                result?result(success, blockError):nil;
                            }else{
                                DDLogWarn(@"%@", [error userInfo][@"error"]);
                                blockError = error;
                                result?result(success, blockError):nil;
                            }
                        }];
                    }else{
                        [PFObject pinAllInBackground:objects];
                        success = YES;
                        result?result(success, blockError):nil;
                    }
                    
                }else{
                    DDLogWarn(@"%@", [error userInfo][@"error"]);
                    blockError = error;
                    result?result(success, blockError):nil;
                }
            }];
        }else{
            DDLogWarn(@"%@", [error userInfo][@"error"]);
            blockError = error;
            result?result(success, blockError):nil;
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

@end
