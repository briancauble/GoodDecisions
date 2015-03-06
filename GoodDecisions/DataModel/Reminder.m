//
//  Reminder.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "Reminder.h"
#import "DecisionType.h"


@implementation Reminder

@dynamic times;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName {
    return @"ReminderPattern";
}


@end
