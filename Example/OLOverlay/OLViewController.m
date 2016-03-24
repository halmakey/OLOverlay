//
//  OLViewController.m
//  OLOverlay
//
//  Created by halmakey on 11/19/2014.
//  Copyright (c) 2014 halmakey. All rights reserved.
//

#import "OLViewController.h"
#import "OLOneViewController.h"
#import <OLOverlay.h>

@interface OLViewController () <OLOverlayProtocol>

@end

@implementation OLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)overlayTapped:(id)sender {
    [self showOne];
}

- (void)showOne
{
    UIViewController *controller = [[OLOneViewController alloc] init];
    controller.overlayAnimator = [OLZoomOverlayAnimator animator];
    controller.overlayTouchToClose = YES;
    [controller showOverlayAnimated:YES completion:nil];
}

- (void)viewWillCoverOverlay {
    NSLog(@"viewWillCoverOverlay");
}

- (void)viewDidCoverOverlay {
    NSLog(@"viewDidCoverOverlay");
}

- (void)viewWillClearOverlay {
    NSLog(@"viewWillClearOverlay");
}

- (void)viewDidClearOverlay {
    NSLog(@"viewDidClearOverlay");
}
@end
