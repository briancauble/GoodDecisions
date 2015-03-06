//
//  Habit.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionType.h"
#import "Reminder.h"


@interface Habit : PFObject<PFSubclassing>

@property (nonatomic, strong) Reminder *reminderPattern;
@property (nonatomic, strong) DecisionType *type;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL isSelected;

+ (NSString *)parseClassName;


@end
