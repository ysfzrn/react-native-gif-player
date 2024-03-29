<h1 align="center">
  React Native Gif Player
</h1>

React Native Gif/Animated WebP Player View Component.

</div>
<p align="center" >
  <kbd>
    <img
      src="https://github.com/ysfzrn/react-native-gif-player/blob/main/assets/recordiOS.gif?raw=true"
      title="iOS Demo"
      float="left"
    >
  </kbd>
  <kbd>
    <img
      src="https://github.com/ysfzrn/react-native-gif-player/blob/main/assets/recordAndroid.webm?raw=true"
      title="Android Demo"
      float="right"
    >
  </kbd>
  <br>
  <em>React Native Gif Player Example App</em>
</p>

React Native's Image component can display GIFs but lacks a stop feature. react-native-gif-player comes with a stop feature and additional capabilities.

`react-native-gif-player` is a wrapper around UIImage(iOS) and Fresco (Android).

## Features

- [x] STOP
- [x] Local/Remote GIF Support.
- [x] Local/Remote Image Support.
- [x] Local/Remote Animated WebP Support (iOS has a performance issue with long animated WebP)..
- [x] Watching Frames
- [x] Jump to Frame
- [x] Old/New Architecture Support

## Usage

```bash
yarn add react-native-gif-player
cd ios && pod install
```

```jsx
import { GifPlayerView } from 'react-native-gif-player';

const App = () => {
  const handleOnFrame = (event: any) => {
    const { frameNumber } = event?.nativeEvent || {};
  };

  const handleOnError = (event: any) => {
    setState({ loading: false, error: event?.nativeEvent?.error });
  };

  const handleLoad = (event: any) => {
    const { duration, frameCount } = event?.nativeEvent || {};
  };

  const jumpToFrame = () => {
    gifPlayerRef.current.jumpToFrame(0);
  }

  return (
    <GifPlayerView
      ref={gifPlayerRef}
      style={styles.box}
      source={{ uri: gifSource }}
      paused={paused}
      loopCount={loopCount}
      onStart={handleStart}
      onStop={handleStop}
      onEnd={handleEnd}
      onFrame={handleOnFrame}
      onError={handleOnError}
      onLoad={handleLoad}
    />
  );
};
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
