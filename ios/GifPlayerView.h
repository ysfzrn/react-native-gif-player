// This guard prevent this file to be compiled in the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef GifPlayerViewNativeComponent_h
#define GifPlayerViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

@interface GifPlayerView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* GifPlayerViewNativeComponent_h */
#endif /* RCT_NEW_ARCH_ENABLED */
