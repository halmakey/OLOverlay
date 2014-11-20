//
//  OLOneViewController.m
//  OLOverlay
//
//  Created by Ryo Kikuchi on 2014/11/19.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import "OLOneViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <OLOverlay.h>

@interface OLOneViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation OLOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _contentView.layer.shadowRadius = 10;
    _contentView.layer.shadowOpacity = 0.4;
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.shouldRasterize = YES;
    _contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeAllTapped:(id)sender {
    for (UIViewController *controller in [UIViewController overlayViewControllers]) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)slideupTapped:(id)sender {
    OLOneViewController *one = [[OLOneViewController alloc] init];
    one.overlayAnimator = [OLSlideupOverlayAnimator animator];
    [one showOverlay];
}

- (IBAction)zoomTapped:(id)sender {
    OLOneViewController *one = [[OLOneViewController alloc] init];
    one.overlayAnimator = [OLZoomOverlayAnimator animator];
    [one showOverlay];
}

- (IBAction)alertTapped:(id)sender {
    OLOneViewController *one = [[OLOneViewController alloc] init];
    OLSlideupOverlayAnimator *animator = [OLSlideupOverlayAnimator animator];
    animator.backgorundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    animator.scale = 4;
    animator.duration = 0.5;
    one.overlayAnimator = animator;
    [one showOverlay];
}

@end
