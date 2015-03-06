//
//  DecisionType.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DecisionType.h"

@implementation DecisionType
@dynamic defaultReminderPrompt;

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


@end
