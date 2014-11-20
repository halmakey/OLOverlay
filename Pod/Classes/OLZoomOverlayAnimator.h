//
//  OLZoomOverlayAnimator.h
//  OLOverlay
//
//  Created by halmakey on 2014/06/06.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLOverlayAnimator.h"

@interface OLZoomOverlayAnimator : NSObject <OLOverlayAnimator>
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) UIColor *backgorundColor;
@property (nonatomic) CGFloat scale;
+ (instancetype)animator;
@end
