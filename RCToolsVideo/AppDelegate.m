//
//  AppDelegate.m
//  RCToolsVideo
//
//  Created by Zakk Hoyt on 9/18/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "AppDelegate.h"
#import "UIFont+VWW.h"
#import "VWW.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupDefaults];
    [self setupAppearance];
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
}

-(void)setupDefaults{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *versionString = [NSString stringWithFormat:@"%@.%@", version, build];
    
    if([VWWUserDefaults version] == nil){
        // First time running this app ever
        VWW_LOG_INFO(@"First time running app. Setting up user defaults");
        [VWWUserDefaults setVersion:versionString];
        [VWWUserDefaults setResolution:1];
        [VWWUserDefaults setRenderAccelerometers:YES];
        [VWWUserDefaults setRenderGyroscopes:YES];
        [VWWUserDefaults setRenderAccelerometerLimits:YES];
        [VWWUserDefaults setRenderGyroscopeLimits:YES];
        [VWWUserDefaults setRenderHeading:YES];
        [VWWUserDefaults setRenderAltitude:YES];
        [VWWUserDefaults setRenderDistanceFromHome:YES];
        [VWWUserDefaults setRenderSpeed:YES];
        [VWWUserDefaults setRenderCoordinates:YES];
        [VWWUserDefaults setRenderDropShadow:YES];
        [VWWUserDefaults setRenderCompassIndicator:NO];
        [VWWUserDefaults setRenderAttitudeIndicator:NO];

    } else if([versionString isEqualToString:[VWWUserDefaults version]] == NO){
        // This is the first time a user has run an updated version
        VWW_LOG_INFO(@"First time running verion %@ of this app. Setting up user defaults", versionString);
        [VWWUserDefaults setVersion:versionString];
    } else {
        // Running as normal
    }
}

-(void)setupAppearance{
    UIColor *color = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UIToolbar appearance] setBarTintColor:color];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
    
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor greenColor],
                                 NSFontAttributeName : [UIFont fontForVWWWithSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
}
@end
