# OLOverlay

[![CI Status](http://img.shields.io/travis/halmakey/OLOverlay.svg?style=flat)](https://travis-ci.org/halmakey/OLOverlay)
[![Version](https://img.shields.io/cocoapods/v/OLOverlay.svg?style=flat)](http://cocoadocs.org/docsets/OLOverlay)
[![License](https://img.shields.io/cocoapods/l/OLOverlay.svg?style=flat)](http://cocoadocs.org/docsets/OLOverlay)
[![Platform](https://img.shields.io/cocoapods/p/OLOverlay.svg?style=flat)](http://cocoadocs.org/docsets/OLOverlay)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.


```
#import <OLOverlay.h>

...

- (void)showChild
{
UIViewController *controller = [[UIViewController alloc] init];
controller.overlayAnimator = [OLZoomOverlayAnimator animator];
controller.overlayTapToClose = YES;

[controller showOverlayAnimated:YES completion:nil];
}
```

## Installation

OLOverlay is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "OLOverlay"

## Author

halmakey, halmakey@cubicplus.net

## License

OLOverlay is available under the MIT license. See the LICENSE file for more info.

