SDOrientationController
=======================

SDOrientationController enables you to use different view controllers for portrait and landscape orientations.
It will automatically handle all rotations and transition between the portrait and landscape view controllers as appropriate.
This way you can easily build an app where one view controller is shown when the device is held in portrait orientation, and another when held in landscape orientation.

Both the iPhone and iPad are supported, but as we make use of iOS 5's View Controller Containment, your users have to be on iOS 5+. 

SDOrientationController was made to be used with Automatic Reference Counting, but if you follow the steps under *No ARC?*, it should work with your non-ARC projects just fine.

Features
--------

- Enables you to use one view controller for portrait and another for landscape orientations.
- You can change the view controllers for either orientation at any time.
- You can set whether the Portrait Upside Down orientation should be supported at all. (property `allowsPortraitUpsideDownOrientation`)
- You can have one view controller which supports both orientations that's always set, and another that only supports one orientation that's only set when appropriate.
  When rotating, this first view controller will be used for both orientations if no view controller was found for the orientation we're rotating to.
  
  This means we can have a `portraitViewController` that supports both orientations, and no `landscapeViewController` at all, and it'll just work.
  In this situation, the app will behave exactly as it would if `SDOrientationController` wasn't used, and the orientation-agnostic `portraitViewController` was set as the app's `rootViewController`.
  
  This feature can be useful when you only want to have a different view controller for one of the orientations under certain conditions, like when a "landscape screensaver" is enabled.
  
All of these features can be seen in action in the [Example](https://github.com/StudioDalton/SDOrientationController/tree/master/Example).
 
Getting Started
---------------

Be aware that SDOrientationController is only intended to be used as your app's root view controller. 
How it behaves in any other situation is undefined.

SDOrientationController is very easy to set up:
When your application launches, you'll initialize the view controllers for the portrait and landscape orientations, 
pass them to `SDOrientationController` and set the result as your app's `rootViewController`:
  
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        MyPortraitViewController *portraitViewController = [[MyPortraitViewController alloc] init];
        MyLandscapeViewController *landscapeViewController = [[MyLandscapeViewController alloc] init];

        self.orientationController = [[SDOrientationController alloc] initWithPortraitViewController:portraitViewController 
                                                                             landscapeViewController:landscapeViewController];

        self.window.rootViewController = self.orientationController;
        
        [self.window makeKeyAndVisible];
        return YES;
    }

That's it, from now on SDOrientationController will handle everything rotation related! Your view controllers for landscape and portrait orientations will continue to receive callbacks such as `viewWillAppear:` and `viewDidDisappear:` as you're used to, 
they'll just never have to worry about rotation again.

### No ARC?

If you really want to, you can use this class without having Automatic Reference Counting enabled for your application. 

To do so, you can go to Build Phases for your Xcode project, open the "Compile Sources" phase, and explicitly enable ARC by adding the `-fobjc-arc` flag to the record for `SDOrientationController.m`.
License
-------

All of the code is licensed under the [MIT license](http://www.opensource.org/licenses/MIT). 

You can use it in whatever app you want, be it commercial, closed-source, open-source or free, as long as proper attribution is included in an About or Credits box of sorts.

Contributing
------------

At the moment I, [Douwe Maan](http://github.com/DouweM), developer at [StudioDalton](http://www.studiodalton.com), am the only contributor,
but of course I'm happy to accept pull requests from anyone who improves on the class in some way.

As a reward, I'll add your name down here along with mine.