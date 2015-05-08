//
//  OLFadeAnimator.m
//  Pods
//
//  Created by Ryo Kikuchi on 2015/05/08.
//
//

#import "OLFadeAnimator.h"

@implementation OLFadeAnimator
+ (instancetype)animator
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _duration = 0.2;
    }
    return self;
}

- (void)overlayAnimateShowViewController:(UIViewController *)presentViewController
                              completion:(void (^)(void))completion
{
    UIView *rootView = presentViewController.view;
    rootView.alpha = 0;

    [UIView animateWithDuration:_duration  delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        rootView.alpha = 1;
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)overlayAnimateDismissViewController:(UIViewController *)dismissViewController
                                 completion:(void (^)(void))completion
{
    UIView *rootView = dismissViewController.view;

    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        rootView.alpha = 0;
    } completion:^(BOOL finished) {
        completion();
    }];
}

@end
