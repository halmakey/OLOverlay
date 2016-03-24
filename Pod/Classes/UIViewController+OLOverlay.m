//
//  UIViewController+Overlay.m
//  OLOverlay
//
//  Created by halmakey on 2014/05/07.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import "UIViewController+OLOverlay.h"
#import <objc/runtime.h>
#import "OLOverlayProtocol.h"

@interface UIGestureOverlayInterceptor : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic) UILongPressGestureRecognizer *gestureRecognizer;
- (void)addTarget:(id)target action:(SEL)action;
- (void)removeTarget:(id)target action:(SEL)action;
@end

@interface OLOverlayState : NSObject
@property (nonatomic, weak) UIViewController *underViewController;
@property (nonatomic) UIWindow *window;
@property (nonatomic) UIGestureOverlayInterceptor *interceptor;
@property (nonatomic) BOOL isOverlay;
@property (nonatomic) id<OLOverlayAnimator> animator;
@property (nonatomic) BOOL touchToClose;
@property (nonatomic) BOOL isPresented;
@end

@implementation OLOverlayState
- (instancetype)init
{
    self = [super init];
    if (self) {
        _touchToClose = YES;
    }
    return self;
}
@end

@interface UIViewController (OLOverlayPrivate)
@property (nonatomic, readonly) OLOverlayState *overlayState;
@end

@implementation UIViewController (OLOverlay)

+ (void)load
{
    Method overlayDismissMethod = class_getInstanceMethod([self class], @selector(dismissOverlayAnimated:completion:));
    Method originalDismissMethod = class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:));
    method_exchangeImplementations(originalDismissMethod, overlayDismissMethod);
}

+ (NSArray*)overlayViewControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        UIViewController *controller = window.rootViewController;
        if ([controller respondsToSelector:@selector(isOverlay)] &&
            controller.isOverlay) {
            [controllers addObject:controller];
        }
    }
    return controllers.copy;
}

- (void)setOverlayAnimator:(id<OLOverlayAnimator>)overlayAnimator
{
    self.overlayState.animator = overlayAnimator;
}

- (id<OLOverlayAnimator>)overlayAnimator
{
    return self.overlayState.animator;
}

- (OLOverlayState*)overlayState
{
    OLOverlayState *state = objc_getAssociatedObject(self, _cmd);
    if (!state) {
        state = [[OLOverlayState alloc] init];
        objc_setAssociatedObject(self, _cmd, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return state;
}

- (void)showOverlay
{
    [self showOverlayAnimated:YES completion:nil];
}

- (void)showOverlayAnimated:(BOOL)animated completion:(void(^)())completion
{
    if (self.overlayState.isPresented) {
        return;
    }
    self.overlayState.isOverlay = YES;
    self.overlayState.underViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window setWindowLevel:UIWindowLevelNormal];
    [window setBackgroundColor:[UIColor clearColor]];
    [window setRootViewController:self];
    [window makeKeyAndVisible];

    self.overlayState.window = window;

    UIGestureOverlayInterceptor *overlayInterceptor = [[UIGestureOverlayInterceptor alloc] init];
    [overlayInterceptor addTarget:self action:@selector(overlayTouchAction:)];
    [self.view addGestureRecognizer:overlayInterceptor.gestureRecognizer];
    self.overlayState.interceptor = overlayInterceptor;

    id<OLOverlayAnimator> animator = [self overlayAnimator];

    [self.overlayState.underViewController notifyOverlaySelectorToChildlen:@selector(viewWillCoverOverlay)];
    [self notifyOverlaySelectorToChildlen:@selector(viewWillPresentOverlay)];

    self.overlayState.isPresented = YES;

    void (^animatorCompletion)() = ^{

        [self notifyOverlaySelectorToChildlen:@selector(viewDidPresentOverlay)];
        [self.overlayState.underViewController notifyOverlaySelectorToChildlen:@selector(viewDidCoverOverlay)];

        if (completion) {
            completion();
        }
    };

    if (animated && animator) {
        [animator overlayAnimateShowViewController:self completion:animatorCompletion];
    } else {
        animatorCompletion();
    }
}

- (void)dismissOverlayAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    if (!self.isOverlay || self.presentedViewController) {
        [self dismissOverlayAnimated:animated completion:completion];
        return;
    }

    if (!self.overlayState.isPresented) {
        return;
    }

    [self.overlayState.underViewController notifyOverlaySelectorToChildlen:@selector(viewWillClearOverlay)];
    [self notifyOverlaySelectorToChildlen:@selector(viewWillDismissOverlay)];


    self.overlayState.isPresented = NO;

    void (^animatorCompletion)() = ^{
        [self.view removeGestureRecognizer:self.overlayState.interceptor.gestureRecognizer];
        self.overlayState.interceptor = nil;

        [self.overlayState.window setRootViewController:nil];
        self.overlayState.window = nil;

        [self notifyOverlaySelectorToChildlen:@selector(viewDidDismissOverlay)];
        [self.overlayState.underViewController notifyOverlaySelectorToChildlen:@selector(viewDidClearOverlay)];

        self.overlayState.isOverlay = NO;

        if (completion) {
            completion();
        }
    };

    id<OLOverlayAnimator> animator = [self overlayAnimator];
    if (animated && animator) {
        [animator overlayAnimateDismissViewController:self completion:animatorCompletion];
    } else {
        animatorCompletion();
    }
}

- (void)overlayTouchAction:(id)sender
{
    if (!self.overlayState.touchToClose) {
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notifyOverlaySelectorToChildlen:(SEL)selector {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller respondsToSelector:selector]) {
            [controller performSelector:selector];
        }
    }
#pragma clang diagnostic pop
}

@dynamic overlayTouchToClose;
- (BOOL)overlayTouchToClose
{
    return self.overlayState.touchToClose;
}

- (void)setOverlayTouchToClose:(BOOL)overlayTouchToClose
{
    self.overlayState.touchToClose = overlayTouchToClose;
}

- (BOOL)isOverlay
{
    return self.overlayState.isOverlay;
}
@end

@implementation UIGestureOverlayInterceptor
- (instancetype)init
{
    self = [super init];
    if (self) {
        _gestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        _gestureRecognizer.minimumPressDuration = 0;
        [_gestureRecognizer setDelegate:self];

    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (gestureRecognizer.view == touch.view);
}

- (void)addTarget:(id)target action:(SEL)action
{
    [_gestureRecognizer addTarget:target action:action];
}

- (void)removeTarget:(id)target action:(SEL)action
{
    [_gestureRecognizer removeTarget:target action:action];
}

@end