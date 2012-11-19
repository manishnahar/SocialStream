//
//  AppDelegate.h
//  SocialStreams
//
//  Created by ManishNaharMac on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MergedSocialStreamAdapter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
//    MergedSocialStreamAdapter *mergedSocialStreamAdapter;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
