//
//  UIViewController+Overlay.h
//  OLOverlay
//
//  Created by halmakey on 2014/05/07.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLOverlayAnimator.h"

@protocol UIViewControllerOverlayDelegate;

@interface UIViewController (Overlay)
@property (nonatomic) id<OLOverlayAnimator> overlayAnimator;
@property (nonatomic) BOOL overlayTapToClose;
@property (nonatomic, readonly) BOOL isOverlay;

+ (NSArray*)overlayViewControllers;
- (void)showOverlayAnimated:(BOOL)animated completion:(void(^)())completion;
@end