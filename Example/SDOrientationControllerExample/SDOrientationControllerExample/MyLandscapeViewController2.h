//
//  MyLandscapeViewController2.h
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLandscapeViewController2 : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *portraitUpsideDownButton;

- (IBAction)showOtherLandscape;

- (IBAction)switchPortraitUpsideDown:(id)sender;

@end
