//
//  OLOverlayProtocol.h
//  OLOverlay
//
//  Created by halmakey on 2014/07/07.
//  Copyright (c) 2014年 halmakey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OLOverlayProtocol <NSObject>
@optional
- (void)viewWillPresentOverlay;
- (void)viewDidPresentOverlay;
- (void)viewWillDismissOverlay;
- (void)viewDidDismissOverlay;
- (void)viewWillCoverOverlay;
- (void)viewDidCoverOverlay;
- (void)viewWillClearOverlay;
- (void)viewDidClearOverlay;
@end
