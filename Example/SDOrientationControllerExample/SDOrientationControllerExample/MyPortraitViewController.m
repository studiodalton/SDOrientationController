//
//  MyPortraitViewController.m
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import "MyPortraitViewController.h"

#import "SDOrientationController.h"

#import "MyLandscapeViewController.h"

@implementation MyPortraitViewController

@synthesize switchButton;

- (id)init {
    return (self = [super initWithNibName:@"MyPortraitViewController" bundle:nil]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.orientationController.landscapeViewController) {
        [self.switchButton setTitle:@"landscapeViewController = nil" forState:UIControlStateNormal];
    }
    else {
        [self.switchButton setTitle:@"landscapeViewController = [...]" forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self setSwitchButton:nil];
}

- (IBAction)switchLandscapeViewController:(id)sender {    
    if (self.orientationController.landscapeViewController) {
        [self.orientationController setLandscapeViewController:nil animated:YES];
        
        [self.switchButton setTitle:@"landscapeViewController = [...]" forState:UIControlStateNormal];
    }
    else {
        MyLandscapeViewController *landscapeViewController = [[MyLandscapeViewController alloc] init];
        [self.orientationController setLandscapeViewController:landscapeViewController animated:YES];
        
        [self.switchButton setTitle:@"landscapeViewController = nil" forState:UIControlStateNormal];
    }
}

@end
