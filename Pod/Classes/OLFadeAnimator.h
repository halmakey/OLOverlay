//
//  OLFadeAnimator.h
//  Pods
//
//  Created by Ryo Kikuchi on 2015/05/08.
//
//

#import <UIKit/UIKit.h>
#import "OLOverlayAnimator.h"

@interface OLFadeAnimator : NSObject <OLOverlayAnimator>
@property (nonatomic) NSTimeInterval duration;
+ (instancetype)animator;
@end
