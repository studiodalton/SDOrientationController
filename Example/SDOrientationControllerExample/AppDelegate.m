//
//  AppDelegate.m
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import "AppDelegate.h"

#import "SDOrientationController.h"

#import "MyPortraitViewController.h"
#import "MyLandscapeViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize orientationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MyLandscapeViewController *landscapeViewController = [[MyLandscapeViewController alloc] init];
    MyPortraitViewController *portraitViewController = [[MyPortraitViewController alloc] init];
    
    self.orientationController = [[SDOrientationController alloc] initWithPortraitViewController:portraitViewController 
                                                                         landscapeViewController:landscapeViewController];
    
    self.window.rootViewController = self.orientationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
