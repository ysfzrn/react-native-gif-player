import React, {
  createRef,
  type ElementRef,
  Component,
  type ComponentProps,
} from 'react';
import GifPlayerViewNativeComponent from './GifPlayerViewNativeComponent';
import GifPlayerNativeView from './GifPlayerViewNativeComponent';
import type { GifPlayerViewComponent } from './GifPlayerViewNativeComponent';
import { Commands } from './GifPlayerViewNativeComponent';
import type { Int32 } from 'react-native/Libraries/Types/CodegenTypes';
const resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');

type Props = ComponentProps<typeof GifPlayerNativeView>;
interface SourceProps {
  uri?: string;
  type?: string;
}

class GifPlayerView extends Component<Props> {
  private innerRef = createRef<ElementRef<GifPlayerViewComponent>>();

  jumpToFrame = (frameNumber: Int32) => {
    const ref = this.innerRef.current;

    if (ref) {
      Commands.jumpToFrame(ref, frameNumber);
    }
  };

  memoryClear = () => {
    const ref = this.innerRef.current;

    if (ref) {
      Commands.memoryClear(ref);
    }
  };

  render() {
    const { source, paused, loopCount } = this.props || {};

    let resolvedAsset: SourceProps = { uri: '', type: '' };

    if (source?.uri) {
      resolvedAsset = source;
    } else {
      resolvedAsset = resolveAssetSource(source);
    }

    return (
      <GifPlayerViewNativeComponent
        ref={this.innerRef}
        {...this.props}
        source={{
          uri: resolvedAsset?.uri,
          type: source?.type,
          local: source?.uri ? false : true,
        }}
        paused={paused === null ? true : paused}
        loopCount={loopCount || 0}
      />
    );
  }
}

export { GifPlayerView };
