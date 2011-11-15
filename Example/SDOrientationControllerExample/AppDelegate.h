//
//  AppDelegate.h
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDOrientationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SDOrientationController *orientationController;

@end
