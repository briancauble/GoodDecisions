//
//  PFQuery+Local.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/9/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFQuery (Local)

-(void)updateLocalDataStore;
-(void)updateLocalDataStoreWithResult:(PFBooleanResultBlock)result;
-(BFTask *)findObjectsFromLocalDatastoreInBackground;
-(void)findObjectsFromLocalDatastoreInBackgroundWithBlock:(PFArrayResultBlock)block;

-(void)findAndPinObjectsInBackgroundWithBlock:(PFArrayResultBlock)block;

@end
