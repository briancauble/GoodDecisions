//
//  Habit.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "Habit.h"

@implementation Habit

@synthesize isSelected = _isSelected;

@dynamic reminderPattern, name, type;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"Habit";
}

+(PFQuery *)query{
    PFQuery *query = [super query];
    [query orderByAscending:@"sortIndex"];
    [query includeKey:@"reminderPattern"];
    [query includeKey:@"type"];
    
    return query;
}



-(BOOL)isSelected{
   BOOL test = [[PFUser currentUser][@"habits"] containsObject:self];
    return test;
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:self.class]) {
        return self.objectId == object[@"objectId"];
    }
    return [super isEqual:object];
}
@end
