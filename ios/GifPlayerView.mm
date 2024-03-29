#ifdef RCT_NEW_ARCH_ENABLED
#import "GifPlayerView.h"

#import <React/RCTConversions.h>
#import <RCTTypeSafety/RCTConvertHelpers.h>

#import <react/renderer/components/RNGifPlayerViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNGifPlayerViewSpec/EventEmitters.h>
#import <react/renderer/components/RNGifPlayerViewSpec/Props.h>
#import <react/renderer/components/RNGifPlayerViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "react-native-gif-manager-Swift.h"


using namespace facebook::react;

@interface GifPlayerView () <RCTGifPlayerViewViewProtocol, GifPlayerViewComponentDelegate>

@end

@implementation GifPlayerView {
    GifPlayerViewComponent * _view;
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<GifPlayerViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const GifPlayerViewProps>();
    _props = defaultProps;

    _view = [[GifPlayerViewComponent alloc] init];
    _view.delegate = self;

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<GifPlayerViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<GifPlayerViewProps const>(props);
    
    if (oldViewProps.source.uri != newViewProps.source.uri) {
           NSDictionary *assetSource = @{
               @"uri": RCTNSStringFromString(newViewProps.source.uri),
               @"type": RCTNSStringFromString(newViewProps.source.type)
           };
           
           [_view setSource:assetSource];
    }
       
   if (oldViewProps.paused != newViewProps.paused) {
       [_view setPaused:newViewProps.paused];
   }
    
    if (oldViewProps.loopCount != newViewProps.loopCount) {
        [_view setLoopCount:newViewProps.loopCount];
    }

    [super updateProps:props oldProps:oldProps];
}


- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args{
    RCTGifPlayerViewHandleCommand(self, commandName, args);
}


- (void)handleOnLoadWithDuration:(double)duration frameCount:(NSInteger)frameCount{
    if (_eventEmitter != nil) {
        std::dynamic_pointer_cast<const GifPlayerViewEventEmitter>(_eventEmitter)
            ->onLoad(GifPlayerViewEventEmitter::OnLoad{
                .duration = duration,
                .frameCount = static_cast<int>(frameCount)
            });
    }
}

- (void)handleOnFrameWithFrameNumber:(NSInteger)frameNumber{
    if (_eventEmitter != nil) {
        std::dynamic_pointer_cast<const GifPlayerViewEventEmitter>(_eventEmitter)
            ->onFrame(GifPlayerViewEventEmitter::OnFrame{
                .frameNumber = static_cast<int>(frameNumber)
            });
    }
}

- (void)handleOnErrorWithError:(NSString *)error{
    if (_eventEmitter != nil) {
        const char *cstr = [error cStringUsingEncoding:NSUTF8StringEncoding];
        std::string cppString = cstr;
        
        std::dynamic_pointer_cast<const GifPlayerViewEventEmitter>(_eventEmitter)
            ->onError(GifPlayerViewEventEmitter::OnError{
                .error = cppString
            });
    }
}



- (void)handleOnStart{
    if (_eventEmitter != nil) {
        std::dynamic_pointer_cast<const GifPlayerViewEventEmitter>(_eventEmitter)
            ->onStart(GifPlayerViewEventEmitter::OnStart{});
    }
}


- (void)handleOnStop{
    if (_eventEmitter != nil) {
        std::dynamic_pointer_cast<const GifPlayerViewEventEmitter>(_eventEmitter)
            ->onStop(GifPlayerViewEventEmitter::OnStop{});
    }
}

- (void)handleOnEnd{
    if (_eventEmitter != nil) {
        std::dynamic_pointer_cast<const GifPlayerViewEventEmitter>(_eventEmitter)
            ->onEnd(GifPlayerViewEventEmitter::OnEnd{});
    }
}

- (void)jumpToFrame:(NSInteger)frameNumber{
    [_view jumpToFrameWithFrameNumber:frameNumber];
}


- (void)memoryClear{
    [_view memoryClear];
}


Class<RCTComponentViewProtocol> GifPlayerViewCls(void)
{
    return GifPlayerView.class;
}

@end
#endif
