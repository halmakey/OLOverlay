//
//  OLSlideupOverlayAnimator.m
//  OLOverlay
//
//  Created by halmakey on 2014/06/06.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OLSlideupOverlayAnimator.h"

@implementation OLSlideupOverlayAnimator
+ (instancetype)animator
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.2;
        _backgorundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _scale = 1.0;
    }
    return self;
}

- (void)overlayAnimateShowViewController:(UIViewController *)presentViewController
                                 completion:(void (^)(void))completion
{
    UIView *rootView = presentViewController.view;
    [rootView setBackgroundColor:[UIColor clearColor]];

    CATransform3D firstTransform = CATransform3DMakeTranslation(0, (rootView.bounds.size.height * _scale), 0);
    for (UIView *view in rootView.subviews) {
        [view.layer setTransform:firstTransform];
    }

    [UIView animateWithDuration:_duration  delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CATransform3D lastTransform = CATransform3DMakeTranslation(0, 0, 0);
        for (UIView *view in rootView.subviews) {
            [view.layer setTransform:lastTransform];
        }

        [rootView setBackgroundColor:_backgorundColor];
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)overlayAnimateDismissViewController:(UIViewController *)dismissViewController
                                 completion:(void (^)(void))completion
{
    UIView *rootView = dismissViewController.view;

    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CATransform3D lastTransform = CATransform3DMakeTranslation(0, (rootView.bounds.size.height * _scale), 0);
        for (UIView *view in rootView.subviews) {
            [view.layer setTransform:lastTransform];
        }
        [rootView setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        completion();
    }];
}

@end
