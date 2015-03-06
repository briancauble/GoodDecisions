//
//  DataManager.m
//  GoodDecisions
//
//  Created by Abigail Fritz on 3/5/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "DataManager.h"
#import "Habit.h"
#import "DecisionType.h"


@interface DataManager ()
@property (nonatomic, strong) NSArray *decisionTypes;
@end



@implementation DataManager

- (id)init {
    if (self = [super init]) {
//        for now just get the Food type
        [[DecisionType query] getObjectInBackgroundWithId:@"QEUzoJRlNC" block:^(PFObject *object, NSError *error) {
            _decisionTypes = @[object];
        }];
        
        [self configureNotificationCategories];

    }
    return self;
}

+ (instancetype) sharedManager{
    static dispatch_once_t onceToken;
    static DataManager *_sharedManager;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DataManager alloc] init];
    });
    
    return _sharedManager;
}


-(void)clearAllHabits{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [PFUser currentUser][@"habits"] = @[];
    [[PFUser currentUser] saveEventually];
}

- (void)addHabit:(Habit *)habit{
    habit.isSelected = YES;
    NSMutableArray *habits = [@[habit] mutableCopy];
    [habits addObjectsFromArray:[PFUser currentUser][@"habits"]];
    [PFUser currentUser][@"habits"] = habits;
    [[PFUser currentUser] saveEventually];
    [self scheduleRemindersForHabit:habit];
}

- (void)removeHabit:(Habit *)habit{
    NSMutableArray *habits = [PFUser currentUser][@"habits"];
    [habits removeObject:habit];
    [PFUser currentUser][@"habits"] = habits;
    [[PFUser currentUser] saveEventually];
    [self unscheduleRemindersForHabit:habit];
}

-(void)scheduleRemindersForHabit:(Habit *)habit{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarOptions options = NSCalendarMatchNextTime;
    
    [habit.reminderPattern.times enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSArray *time = [obj componentsSeparatedByString:@":"];
        
        NSDate *nextTimeOccurance = [calendar nextDateAfterDate:today
                                                   matchingHour:[time[0] integerValue]
                                                         minute:[time[1] integerValue]
                                                         second:0
                                                        options:options];
        
        UILocalNotification *notification = [DecisionType notification];
        notification.alertBody = habit.type.defaultReminderPrompt;
        notification.fireDate = nextTimeOccurance;
        notification.userInfo = @{@"group":habit.objectId, @"typeId":habit.type.objectId?:@""};
        notification.alertLaunchImage = @"Launchimage";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];

    }];
}

-(void)unscheduleRemindersForHabit:(Habit *)habit{
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([notification.userInfo[@"group"] isEqualToString:habit.objectId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}



-(void)configureNotificationCategories{
    UIMutableUserNotificationAction *notificationActionUpdate = [[UIMutableUserNotificationAction alloc] init];
    notificationActionUpdate.identifier = @"Update";
    notificationActionUpdate.title = @"Rate Now";
    notificationActionUpdate.activationMode = UIUserNotificationActivationModeForeground;
    notificationActionUpdate.destructive = NO;
    notificationActionUpdate.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationActionSnooze = [[UIMutableUserNotificationAction alloc] init];
    notificationActionSnooze.identifier = @"Snooze";
    notificationActionSnooze.title = @"Update Later";
    notificationActionSnooze.activationMode = UIUserNotificationActivationModeBackground;
    notificationActionSnooze.destructive = YES;
    notificationActionSnooze.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *notificationCategoryReminder = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategoryReminder.identifier = @"Reminder";
    [notificationCategoryReminder setActions:@[notificationActionSnooze,notificationActionUpdate] forContext:UIUserNotificationActionContextDefault];
    [notificationCategoryReminder setActions:@[notificationActionSnooze,notificationActionUpdate] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategoryReminder, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}
@end
