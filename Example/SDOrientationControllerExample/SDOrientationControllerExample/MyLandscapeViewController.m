//
//  MyLandscapeViewController.m
//  SDOrientationControllerExample
//
//  Created by Douwe Maan on 14-11-11.
//  Copyright (c) 2011 StudioDalton. All rights reserved.
//

#import "MyLandscapeViewController.h"

#import "SDOrientationController.h"

#import "MyLandscapeViewController2.h"

@implementation MyLandscapeViewController

- (id)init {
    return (self = [super initWithNibName:@"MyLandscapeViewController" bundle:nil]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)showOtherLandscape {
    MyLandscapeViewController2 *landscapeViewController = [[MyLandscapeViewController2 alloc] init];
    [self.orientationController setLandscapeViewController:landscapeViewController animated:YES];
}

- (IBAction)unsetLandscape:(id)sender {
    [self.orientationController setLandscapeViewController:nil animated:YES];
}

@end
