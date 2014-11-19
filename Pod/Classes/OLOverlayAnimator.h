//
//  OLOverlayAnimator.h
//  OLOverlay
//
//  Created by halmakey on 2014/06/06.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OLOverlayAnimator <NSObject>
- (void)overlayAnimateShowViewController:(UIViewController*)presentViewController completion:(void(^)(void))completion;
- (void)overlayAnimateDismissViewController:(UIViewController*)dismissViewController completion:(void(^)(void))completion;
@end
