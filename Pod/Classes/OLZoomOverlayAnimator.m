//
//  OLZoomOverlayAnimator.m
//  OLOverlay
//
//  Created by halmakey on 2014/06/06.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import "OLZoomOverlayAnimator.h"

@implementation OLZoomOverlayAnimator
+ (instancetype)animator
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.15;
        _backgorundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _scale = 0.7;
    }
    return self;
}

- (void)overlayAnimateShowViewController:(UIViewController *)presentViewController completion:(void (^)(void))completion
{
    UIView *rootView = presentViewController.view;
    [rootView setBackgroundColor:[UIColor clearColor]];

    CATransform3D firstTransform = CATransform3DMakeScale(_scale, _scale, 1);
    for (UIView *view in rootView.subviews) {
        view.alpha = 0;
        view.layer.transform = firstTransform;
    }

    [UIView animateWithDuration:_duration  delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CATransform3D lastTransform = CATransform3DMakeScale(1, 1, 1);
        for (UIView *view in rootView.subviews) {
            view.alpha = 1;
            view.layer.transform = lastTransform;
        }

        [rootView setBackgroundColor:_backgorundColor];
    } completion:^(BOOL finished) {
        completion();
    }];

}

- (void)overlayAnimateDismissViewController:(UIViewController *)dismissViewController completion:(void (^)(void))completion
{
    UIView *rootView = dismissViewController.view;

    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CATransform3D lastTransform = CATransform3DMakeScale(_scale, _scale, 1);
        for (UIView *view in rootView.subviews) {
            view.alpha = 0;
            view.layer.transform = lastTransform;
        }
        [rootView setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        completion();
    }];
}
@end
