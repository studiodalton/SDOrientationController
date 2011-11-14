//
//  SDOrientationController.h
//  Clocks
//
//  Created by Douwe Maan on 10/29/11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString * const SDOrientationControllerNilViewControllerException;

@interface SDOrientationController : UIViewController

@property (strong, nonatomic) UIViewController *portraitViewController;
@property (strong, nonatomic) UIViewController *landscapeViewController;
@property (weak, nonatomic, readonly) UIViewController *visibleViewController;

@property (nonatomic) BOOL allowsPortraitUpsideDownOrientation;

- (id)initWithPortraitViewController:(UIViewController *)portraitViewController
             landscapeViewController:(UIViewController *)landscapeViewController;

- (void)setPortraitViewController:(UIViewController *)portraitViewController animated:(BOOL)animated;
- (void)setLandscapeViewController:(UIViewController *)landscapeViewController animated:(BOOL)animated;

@end


@interface UIViewController (SDOrientationController)

@property (strong, nonatomic, readonly) SDOrientationController *orientationController;

@end
