//
//  AppDelegate.m
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "SocialStreamBlenderViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

//NSString * const instaGramClientID           = @"35b29f23b8064448a865a764126ff938";
//NSString * const instaGramClientSecretKey    = @"6b7eebc8d6db45e8b8847762d63c509a";

- (void)dealloc
{
//    [mergedSocialStreamAdapter release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    NSDictionary *_instagramCredentials = [NSDictionary dictionaryWithObjectsAndKeys:@"self", @"User_Id", instaGramClientID, @"Client_Id", nil];
//    
//    mergedSocialStreamAdapter = [[MergedSocialStreamAdapter alloc] init];
//    [mergedSocialStreamAdapter addSocialStreamModel:[SocialStreamModel fourSquareSocialModelWithCredentials:nil]];
//    [mergedSocialStreamAdapter addSocialStreamModel:[SocialStreamModel instagramSocialStreamModelWithCredentials:_instagramCredentials]];
//    [mergedSocialStreamAdapter addSocialStreamModel:[SocialStreamModel twitterSocialModelWithCredentials:nil]];
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    
    SocialStreamBlenderViewController *blenderViewController = [[SocialStreamBlenderViewController alloc] initWithNibName:@"SocialStreamBlenderViewController" bundle:nil];
    //[blenderViewController setMergedSocialStreamAdapter:mergedSocialStreamAdapter];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:blenderViewController] autorelease];

    self.window.rootViewController = navigationController;
    [blenderViewController release];

    /*
    FirstViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
    [viewController1 setMergedSocialStreamAdapter:mergedSocialStreamAdapter];
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];

    SecondViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
    [viewController2 setMergedSocialStreamAdapter:mergedSocialStreamAdapter];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    */
    
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
