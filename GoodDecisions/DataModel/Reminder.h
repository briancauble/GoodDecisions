//
//  Reminder.h
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//


@interface Reminder : PFObject<PFSubclassing>

@property (nonatomic, strong) NSArray *times;

+ (NSString *)parseClassName;

@end
