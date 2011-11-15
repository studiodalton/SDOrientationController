//
//  MyPortraitViewController.h
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPortraitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

- (IBAction)switchLandscapeViewController:(id)sender;

@end
