//
//  AppDelegate.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 09/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "GBoxFinderViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSDate *AlarmTime = [[NSDate date] dateByAddingTimeInterval:3600];
    UIApplication *app = [UIApplication sharedApplication];
    UILocalNotification *AlarmNotify = [[UILocalNotification alloc] init];
    
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    
    if ([oldNotifications count] > 0) {
        [app cancelAllLocalNotifications];

    }
   
    else if (AlarmNotify) {
        AlarmNotify.fireDate = AlarmTime;
        AlarmNotify.timeZone = [NSTimeZone defaultTimeZone];
        AlarmNotify.repeatInterval = 0;
        AlarmNotify.soundName = @"gboxnote.mp3";
        AlarmNotify.alertBody = @"Hey!! You haven't Visited GBox Today!";
        [app scheduleLocalNotification:AlarmNotify];
        
        NSLog(@"Notification Sent");
    
}
    



}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if ([oldNotifications count] > 1) {
        [app cancelAllLocalNotifications];
    }

    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"This was fired off");
}



@end
