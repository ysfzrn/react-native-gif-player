import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  Double,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';
import type { HostComponent } from 'react-native';
import codegenNativeCommands from 'react-native/Libraries/Utilities/codegenNativeCommands';

interface SourceProps {
  uri?: string;
  type?: string;
  local?: boolean;
}

interface NativeProps extends ViewProps {
  source?: SourceProps;
  paused: boolean;
  loopCount?: Int32;
  onLoad?: DirectEventHandler<
    Readonly<{ duration: Double; frameCount: Int32 }>
  >;
  onStart?: DirectEventHandler<null>;
  onStop?: DirectEventHandler<null>;
  onEnd?: DirectEventHandler<null>;
  onFrame?: DirectEventHandler<Readonly<{ frameNumber: Int32 }>>;
  onError?: DirectEventHandler<Readonly<{ error: string }>>;
}

export type GifPlayerViewComponent = HostComponent<NativeProps>;

export interface GifPlayerViewNativeCommands {
  jumpToFrame: (
    viewRef: React.ElementRef<GifPlayerViewComponent>,
    frameNumber: Int32
  ) => void;
  memoryClear: (viewRef: React.ElementRef<GifPlayerViewComponent>) => void;
}

export const Commands = codegenNativeCommands<GifPlayerViewNativeCommands>({
  supportedCommands: ['jumpToFrame', 'memoryClear'],
});

export default codegenNativeComponent<NativeProps>(
  'GifPlayerView'
) as GifPlayerViewComponent;
