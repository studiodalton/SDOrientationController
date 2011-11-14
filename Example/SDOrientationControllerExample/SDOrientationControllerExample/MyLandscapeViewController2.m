//
//  MyLandscapeViewController2.m
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import "MyLandscapeViewController2.h"

#import "SDOrientationController.h"

#import "MyLandscapeViewController.h"

@implementation MyLandscapeViewController2
@synthesize portraitUpsideDownButton;

- (id)init {
    return (self = [super initWithNibName:@"MyLandscapeViewController2" bundle:nil]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.orientationController.landscapeViewController) {
        [self.portraitUpsideDownButton setTitle:@"allowsPortraitUpsideDownOrientation = NO" forState:UIControlStateNormal];
    }
    else {
        [self.portraitUpsideDownButton setTitle:@"allowsPortraitUpsideDownOrientation = YES" forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self setPortraitUpsideDownButton:nil];
}

- (IBAction)showOtherLandscape {
    MyLandscapeViewController *landscapeViewController = [[MyLandscapeViewController alloc] init];
    [self.orientationController setLandscapeViewController:landscapeViewController animated:YES];
}

- (IBAction)switchPortraitUpsideDown:(id)sender {    
    if (self.orientationController.allowsPortraitUpsideDownOrientation) {
        self.orientationController.allowsPortraitUpsideDownOrientation = NO;
        
        [self.portraitUpsideDownButton setTitle:@"allowsPortraitUpsideDownOrientation = YES" forState:UIControlStateNormal];
    }
    else {
        self.orientationController.allowsPortraitUpsideDownOrientation = YES;
        
        [self.portraitUpsideDownButton setTitle:@"allowsPortraitUpsideDownOrientation = NO" forState:UIControlStateNormal];
    }
}

@end
