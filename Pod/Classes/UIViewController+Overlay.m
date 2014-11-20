//
//  UIViewController+Overlay.m
//  OLOverlay
//
//  Created by halmakey on 2014/05/07.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import "UIViewController+Overlay.h"
#import <objc/runtime.h>
#import "OLOverlayProtocol.h"

// associated property

#define ASSOCIATED_PROPERTY_POLICTY(type, policy, name, Name) \
static char AssociationKey##Name; \
\
- (type)name \
{ \
return (type)objc_getAssociatedObject(self, &(AssociationKey##Name)); \
} \
\
- (void)set##Name:(type)name \
{ \
objc_setAssociatedObject(self, &AssociationKey##Name, name, policy); \
}

#define ASSOCIATED_PROPERTY(type, name, Name) \
ASSOCIATED_PROPERTY_POLICTY(type, OBJC_ASSOCIATION_RETAIN_NONATOMIC, name, Name)

#define ASSOCIATED_PROPERTY_ASSIGN(type, name, Name) \
ASSOCIATED_PROPERTY_POLICTY(type, OBJC_ASSOCIATION_ASSIGN, name, Name)

#define ASSOCIATED_PROPERTY_COPY(type, name, Name) \
ASSOCIATED_PROPERTY_POLICTY(type, OBJC_ASSOCIATION_COPY_NONATOMIC, name, Name)


@interface UIGestureOverlayInterceptor : NSObject <UIGestureRecognizerDelegate>
@property (nonatomic) UIGestureRecognizer *gestureRecognizer;
- (void)addTarget:(id)target action:(SEL)action;
- (void)removeTarget:(id)target action:(SEL)action;
@end

@interface UIViewController (OverlayPrivate)
@property (nonatomic) UIWindow *overlayWindow;
@property (nonatomic) UIGestureOverlayInterceptor *overlayInterceptor;
@property (nonatomic, setter = setOverlay:) BOOL isOverlay;
@end

@implementation UIViewController (Overlay)

ASSOCIATED_PROPERTY(UIWindow*, overlayWindow, OverlayWindow);
ASSOCIATED_PROPERTY(UIGestureOverlayInterceptor*, overlayInterceptor, OverlayInterceptor);
ASSOCIATED_PROPERTY(id<OLOverlayAnimator>, overlayAnimator, OverlayAnimator);
ASSOCIATED_PROPERTY(NSNumber*, overlayTapToCloseNumber, OverlayTapToCloseNumber);
ASSOCIATED_PROPERTY(NSNumber*, overlayFlag, OverlayFlag);

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

- (void)showOverlay
{
    [self showOverlayAnimated:YES completion:nil];
}

- (void)showOverlayAnimated:(BOOL)animated completion:(void(^)())completion
{
    [self setOverlay:YES];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window setWindowLevel:UIWindowLevelNormal];
    [window setBackgroundColor:[UIColor clearColor]];
    [window setRootViewController:self];
    [window makeKeyAndVisible];

    [self setOverlayWindow:window];

    UIGestureOverlayInterceptor *overlayInterceptor = [[UIGestureOverlayInterceptor alloc] init];
    [overlayInterceptor addTarget:self action:@selector(overlayTapAction:)];
    [self.view addGestureRecognizer:overlayInterceptor.gestureRecognizer];
    [self setOverlayInterceptor:overlayInterceptor];

    id<OLOverlayAnimator> animator = [self overlayAnimator];

    if ([self respondsToSelector:@selector(viewWillPresentOverlay)]) {
        [self performSelector:@selector(viewWillPresentOverlay)];
    }

    void (^animatorCompletion)() = ^{

        if ([self respondsToSelector:@selector(viewDidPresentOverlay)]) {
            [self performSelector:@selector(viewDidPresentOverlay)];
        }

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

    if ([self respondsToSelector:@selector(viewWillDismissOverlay)]) {
        [self performSelector:@selector(viewWillDismissOverlay)];
    }

    void (^animatorCompletion)() = ^{
        [self.view removeGestureRecognizer:self.overlayInterceptor.gestureRecognizer];
        [self setOverlayInterceptor:nil];

        [self.overlayWindow setRootViewController:nil];
        [self setOverlayWindow:nil];

        if ([self respondsToSelector:@selector(viewDidDismissOverlay)]) {
            [self performSelector:@selector(viewDidDismissOverlay)];
        }

        [self setOverlay:NO];

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

- (void)overlayTapAction:(id)sender
{
    if ([self respondsToSelector:@selector(overlayTapToClose)]) {
        if (![self overlayTapToClose]) {
            return;
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@dynamic overlayTapToClose;
- (BOOL)overlayTapToClose
{
    NSNumber *number = [self overlayTapToCloseNumber];
    return number ? [number boolValue] : YES;
}

- (void)setOverlayTapToClose:(BOOL)overlayTapToClose
{
    NSNumber *number = [NSNumber numberWithBool:overlayTapToClose];
    [self setOverlayTapToCloseNumber:number];
}

- (BOOL)isOverlay
{
    return [[self overlayFlag] boolValue];
}

- (void)setOverlay:(BOOL)isOverlay
{
    [self setOverlayFlag:[NSNumber numberWithBool:isOverlay]];
}
@end

@implementation UIGestureOverlayInterceptor
- (instancetype)init
{
    self = [super init];
    if (self) {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] init];
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
