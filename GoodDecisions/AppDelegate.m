//
//  AppDelegate.m
//  GoodDecisions
//
//  Created by Brian Cauble on 2/15/15.
//  Copyright (c) 2015 Brian Cauble. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "MinimalDecisionViewController.h"
#import "UIView+Constraints.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"cJOeBpOQkZVFFiDrtbtjmsgIt5CrVgfINqBPyBkh"
                  clientKey:@"Gut2htWGgdZRT5NTiwqkqVGynw8WmIETfgbGfKvk"];
    [DataManager sharedManager];
    UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        DDLogDebug(@"did launch with notification");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    if ([identifier isEqualToString:@"Update"]) {
        DDLogDebug(@"handle action: Update");
        MinimalDecisionViewController *minimalVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MinimalDecisionViewController"];
        minimalVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        NSString *typeId =notification.userInfo[@"typeId"];
        if ([typeId length]) {
            minimalVC.type = [DecisionType objectWithoutDataWithObjectId:typeId];
//            [self.window setRootViewController:minimalVC];
            [self.window.rootViewController presentViewController:minimalVC animated:NO completion:nil];
        }
        

    }
    completionHandler?completionHandler():nil;
    
    
}
@end
