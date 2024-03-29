#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(GifPlayerViewManager, RCTViewManager)

//RCT_EXPORT_VIEW_PROPERTY(color, NSString)
RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)
RCT_EXPORT_VIEW_PROPERTY(loopCount, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(onLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStop, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEnd, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFrame, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)
RCT_EXTERN_METHOD(jumpToFrame:(nonnull NSNumber *) reactTag frameNumber:(NSInteger *)frameNumber)
RCT_EXTERN_METHOD(memoryClear:(nonnull NSNumber *) reactTag)


@end
