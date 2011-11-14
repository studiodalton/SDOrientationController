//
//  SDOrientationController.m
//  Clocks
//
//  Created by Douwe Maan on 10/29/11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import "SDOrientationController.h"

NSString * const SDOrientationControllerNilViewControllerException = @"SDOrientationControllerNilViewControllerException";

static inline BOOL UIInterfaceOrientationsAreAlike(UIInterfaceOrientation orientation1, UIInterfaceOrientation orientation2) {
    if (UIInterfaceOrientationIsPortrait(orientation1)) {
        return UIInterfaceOrientationIsPortrait(orientation2);
    }
    if (UIInterfaceOrientationIsLandscape(orientation1)) {
        return UIInterfaceOrientationIsLandscape(orientation2);
    }
    return NO;
}

@interface SDOrientationController () {
    BOOL _initializing;
    
    UIInterfaceOrientation rotatingFromInterfaceOrientation;
    UIViewController *rotatingFromVisibleViewController;
    
    BOOL _portraitViewControllerCanBeLandscape;
    BOOL _landscapeViewControllerCanBePortrait;
}

- (UIViewController *)viewControllerForOrientation:(UIInterfaceOrientation)orientation;
- (UIInterfaceOrientation)orientationForViewController:(UIViewController *)viewController;
- (void)setViewController:(UIViewController *)newViewController forInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

- (void)transitionToViewController:(UIViewController *)toViewController 
                          duration:(NSTimeInterval)duration 
                        completion:(void (^)(BOOL finished))completion;

@property (weak, nonatomic) UIViewController *visibleViewController;

@end

@implementation SDOrientationController

@synthesize portraitViewController;
@synthesize landscapeViewController;
@synthesize visibleViewController;

@synthesize allowsPortraitUpsideDownOrientation;

#pragma mark -
#pragma mark Custom Methods

- (UIViewController *)viewControllerForOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return self.portraitViewController;
    }
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return self.landscapeViewController;
    }
    return nil;
}

- (UIInterfaceOrientation)orientationForViewController:(UIViewController *)viewController {
    if (viewController == self.portraitViewController) {
        return UIInterfaceOrientationPortrait;
    }
    if (viewController == self.landscapeViewController) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    return UIInterfaceOrientationPortraitUpsideDown;
}

- (void)setViewController:(UIViewController *)newViewController forInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    NSTimeInterval animationDuration = (animated ? 0.4 : 0.0);
    
    BOOL                newViewControllerCanBeOtherOrientation  = NO;
    UIViewController    *otherViewController                    = nil;
    BOOL                otherViewControllerCanBeThisOrientation = NO;
    UIViewController    *oldViewController                      = nil;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        newViewControllerCanBeOtherOrientation = [newViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];

        otherViewController = self.landscapeViewController;
        otherViewControllerCanBeThisOrientation = _landscapeViewControllerCanBePortrait;
        
        oldViewController = self.portraitViewController;
    }
    else {
        newViewControllerCanBeOtherOrientation = [newViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];

        otherViewController = self.portraitViewController;
        otherViewControllerCanBeThisOrientation = _portraitViewControllerCanBeLandscape;
        
        oldViewController = self.landscapeViewController;
    }
    

    if (!newViewController && !otherViewController) {
        [[NSException exceptionWithName:SDOrientationControllerNilViewControllerException
                                 reason:@"You need to have at least one view controller."
                               userInfo:nil] raise];   
        return;
    }
    if (!_initializing && !newViewController && !otherViewControllerCanBeThisOrientation) {
        NSString *orientationString = (UIInterfaceOrientationIsLandscape(orientation) ? @"landscape" : @"portrait");
        [[NSException exceptionWithName:SDOrientationControllerNilViewControllerException
                                 reason:[NSString stringWithFormat:@"You need to have a view controller for %@ orientation.", orientationString]
                               userInfo:nil] raise];   
        return;
    }
    if (!_initializing && !otherViewController && !newViewControllerCanBeOtherOrientation) {
        NSString *orientationString = (UIInterfaceOrientationIsLandscape(orientation) ? @"portrait" : @"landscape");
        [[NSException exceptionWithName:SDOrientationControllerNilViewControllerException
                                 reason:[NSString stringWithFormat:@"You need to have a view controller for %@ orientation.", orientationString]
                               userInfo:nil] raise];   
        return;
    }
    if (oldViewController == newViewController) {
        return;
    }
    
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        portraitViewController = newViewController;
        _portraitViewControllerCanBeLandscape = newViewControllerCanBeOtherOrientation;
    }
    else {
        landscapeViewController = newViewController;
        _landscapeViewControllerCanBePortrait = newViewControllerCanBeOtherOrientation;
    }
    newViewController.definesPresentationContext = YES;
    
    
    [oldViewController willMoveToParentViewController:nil];
    if (newViewController) {
        [self addChildViewController:newViewController];
    }
    
    void (^hierarchyCompletionBlock)(BOOL finished) = ^ (BOOL finished) {
        [newViewController didMoveToParentViewController:self];
        [oldViewController removeFromParentViewController];
    };
    
    
    if (UIInterfaceOrientationsAreAlike(orientation, self.interfaceOrientation)) { // Something should be done, as this affects what currently shown
        UIViewController *toViewController = nil;
        
        // Rotate the otherViewController to the current orientation if there is no newViewController
        if (!newViewController) {
            toViewController = otherViewController;
            
            [otherViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.0];
            [otherViewController willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0];
            // otherViewController.interfaceOrientation = self.interfaceOrientation;
            UIInterfaceOrientation fromInterfaceOrientation = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 
                                                               UIInterfaceOrientationLandscapeLeft : 
                                                               UIInterfaceOrientationPortrait);
            [otherViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        }
        else {
            toViewController = newViewController;
        }
        
        void (^completionBlock)(BOOL finished) = hierarchyCompletionBlock;
        
         // Rotate the otherViewController back to its original orientation if it was shown in the current orientation because there was no oldViewController
        if (!oldViewController) {
            completionBlock = ^ (BOOL finished) {
                hierarchyCompletionBlock(finished);
                
                UIInterfaceOrientation originalInterfaceOrientation = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 
                                                                       UIInterfaceOrientationLandscapeLeft : 
                                                                       UIInterfaceOrientationPortrait);
                [otherViewController willRotateToInterfaceOrientation:originalInterfaceOrientation duration:0.0];
                [otherViewController willAnimateRotationToInterfaceOrientation:originalInterfaceOrientation duration:0.0];
                // otherViewController.interfaceOrientation = originalInterfaceOrientation;
                [otherViewController didRotateFromInterfaceOrientation:self.interfaceOrientation];
            };
        }
        
        [self transitionToViewController:toViewController
                                duration:animationDuration
                              completion:completionBlock];
    }
    else if (!otherViewController) {
        // Rotate the newViewController to the current orientation because there is no otherViewController that should be shown.
        [newViewController willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.0];
        [newViewController willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.0];
        // newViewController.interfaceOrientation = self.interfaceOrientation;
        UIInterfaceOrientation fromInterfaceOrientation = (UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 
                                                           UIInterfaceOrientationLandscapeLeft : 
                                                           UIInterfaceOrientationPortrait);
        [newViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        
        [self transitionToViewController:newViewController
                                duration:animationDuration
                              completion:hierarchyCompletionBlock];
    }
    else {
        hierarchyCompletionBlock(YES);
    }
}

- (void)transitionToViewController:(UIViewController *)toViewController 
                          duration:(NSTimeInterval)duration 
                        completion:(void (^)(BOOL finished))completion {
    
    UIViewController *fromViewController = self.visibleViewController;
        
    if (fromViewController == toViewController) {
        return;
    }
    
    // For whatever reason this is needed.
    CGRect toViewFrame = toViewController.view.frame;
    toViewFrame.size = self.view.bounds.size;
    toViewController.view.frame = toViewFrame;
    
    
    BOOL animated = (duration > 0.0);
    
    [fromViewController viewWillDisappear:animated];
    [toViewController viewWillAppear:animated];
    
    void (^completionBlock)(BOOL finished) = ^ (BOOL finished) {
        self.visibleViewController = toViewController;
        
        [toViewController viewDidAppear:animated];
        [fromViewController viewDidDisappear:animated];
        
        if (completion) {
            completion(finished);
        }
    };
    
    if (animated && fromViewController) {
        [UIView transitionFromView:fromViewController.view
                            toView:toViewController.view
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:completionBlock];
    }
    else {
        [fromViewController.view removeFromSuperview];
        [self.view addSubview:toViewController.view];
        
        completionBlock(YES);
    }
}

#pragma mark -
#pragma mark Getters/Setters

- (void)setPortraitViewController:(UIViewController *)newPortraitViewController {
    [self setPortraitViewController:newPortraitViewController animated:NO];
}

- (void)setLandscapeViewController:(UIViewController *)newLandscapeViewController {
    [self setLandscapeViewController:newLandscapeViewController animated:NO];
}

- (void)setPortraitViewController:(UIViewController *)newPortraitViewController animated:(BOOL)animated {
    [self setViewController:newPortraitViewController forInterfaceOrientation:UIInterfaceOrientationPortrait animated:animated];
}

- (void)setLandscapeViewController:(UIViewController *)newLandscapeViewController animated:(BOOL)animated {
    [self setViewController:newLandscapeViewController forInterfaceOrientation:UIInterfaceOrientationLandscapeLeft animated:animated];
}

#pragma mark -
#pragma mark Initialization

- (id)init {
    return [self initWithPortraitViewController:nil landscapeViewController:nil];
}

- (id)initWithPortraitViewController:(UIViewController *)initialPortraitViewController 
             landscapeViewController:(UIViewController *)initialLandscapeViewController {
    
    if (self = [super init]) {
        _initializing = YES;
        self.portraitViewController = initialPortraitViewController;
        self.landscapeViewController = initialLandscapeViewController;
        _initializing = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark Lifecycle

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return allowsPortraitUpsideDownOrientation ? YES : (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    rotatingFromInterfaceOrientation = self.interfaceOrientation;
    rotatingFromVisibleViewController = self.visibleViewController;
    
    if (UIInterfaceOrientationsAreAlike(rotatingFromInterfaceOrientation, toInterfaceOrientation)) {
        return;
    }
    
    UIViewController *toViewController = [self viewControllerForOrientation:toInterfaceOrientation];
    
    // If we're already showing the viewController for the orientation we're moving to, just rotate it.
    if (toViewController == rotatingFromVisibleViewController) {
        [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
        return;
    }
    
    BOOL visibleViewControllerCanBeOrientation = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? 
                                                  _portraitViewControllerCanBeLandscape : 
                                                  _landscapeViewControllerCanBePortrait);
    
    // If there is no viewController for the orientation we're moving to, just rotate the current one.
    if (!toViewController) {
        if (visibleViewControllerCanBeOrientation) {
            [self.visibleViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
        }
        else {
            NSString *orientationString = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? @"landscape" : @"portrait");
            [[NSException exceptionWithName:SDOrientationControllerNilViewControllerException
                                     reason:[NSString stringWithFormat:@"You need to have a view controller for %@ orientation.", orientationString]
                                   userInfo:nil] raise];   
        }
        return;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // No notable change? Bummer.
    if (UIInterfaceOrientationsAreAlike(rotatingFromInterfaceOrientation, toInterfaceOrientation)) {
        return;
    }
        
    UIViewController *toViewController = [self viewControllerForOrientation:toInterfaceOrientation];
    
    // If we're already showing the viewController for the orientation we're moving to, just rotate it.
    if (toViewController == rotatingFromVisibleViewController) {
        [self.visibleViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
        return;
    }
    
    // If there is no viewController for the orientation we're moving to, just rotate the current one.
    if (!toViewController) {
        // We're assuming visibleViewControllerCanBeOrientation, because otherwise willRotateToInterfaceOrientation:duration: would've thrown an exception.
        [self.visibleViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
        return;
    }
    
    [self transitionToViewController:toViewController
                            duration:duration
                          completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIViewController *oldVisibleViewController = rotatingFromVisibleViewController;
    
    rotatingFromInterfaceOrientation = self.interfaceOrientation;
    rotatingFromVisibleViewController = nil;
    
    if (UIInterfaceOrientationsAreAlike(fromInterfaceOrientation, self.interfaceOrientation)) {
        return;
    }
    
    // If we're now showing the same viewController as before the orientation change, we rotated and we'll just send the message.
    if (self.visibleViewController == oldVisibleViewController) {
        [self.visibleViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}

#pragma mark Forwarding

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.visibleViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.visibleViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.visibleViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.visibleViewController viewDidDisappear:animated];
}

@end


@implementation UIViewController (SDOrientationController)

@dynamic orientationController;

- (SDOrientationController *)orientationController {
    if ([self.parentViewController isKindOfClass:[SDOrientationController class]]) {
        return (SDOrientationController *)self.parentViewController;
    }
    
    return nil;
}

@end