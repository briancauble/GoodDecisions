//
//  DataManager.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Habit.h"

@interface DataManager : NSObject

@property (nonatomic, readonly) NSArray *decisionTypes;


+ (instancetype) sharedManager;
+ (NSDateFormatter *) sharedDateFormatter;

- (void)addHabit:(Habit *)habit;
- (void)removeHabit:(Habit *)habit;
- (void)clearAllHabits;



@end
