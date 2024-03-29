import * as React from 'react';

import {
  Pressable,
  StyleSheet,
  View,
  ActivityIndicator,
  TextInput,
  KeyboardAvoidingView,
  Dimensions,
  Platform,
  Text,
} from 'react-native';
import { GifInfo, IconButton } from './components';
import { GifPlayerView } from 'react-native-gif-player';
import axios from 'axios';
import { combineReducers } from './utils';
const PlayIcon = require('./assets/play.png');
const PauseIcon = require('./assets/pause.png');
const NextIcon = require('./assets/next.png');
const LoopIcon = require('./assets/loop.png');
const ResetIcon = require('./assets/reset.png');

const screenWidth = Dimensions.get('screen').width;
const screenHeight = Dimensions.get('screen').height;
const aspectRatio = screenWidth / screenHeight;

const initialState = {
  paused: false,
  gifSrc: '',
  loading: true,
  searchKey: 'cat',
  duration: 0,
  frameCount: 0,
  currentFrame: 0,
  loopCount: 0,
  error: null,
};

export default function App() {
  const [state, setState] = React.useReducer(combineReducers, initialState);
  const {
    paused,
    gifSrc,
    loading,
    searchKey,
    duration,
    frameCount,
    currentFrame,
    loopCount,
    error,
  } = state || {};
  const gifPlayerRef = React.useRef<GifPlayerView>(null);

  React.useEffect(() => {
    randomGif();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handlePressIn = () => {
    setState({ paused: true });
  };

  const handlePressOut = () => {
    setState({ paused: false });
  };

  const randomGif = async () => {
    const res = await getRandomGif();
    setState({ gifSrc: res });
  };

  const handleStart = () => {
    console.log(Platform.OS, 'animation start');
    setState({ paused: false });
  };

  const handleStop = () => {
    console.log(Platform.OS, 'animation stop');
    setState({ paused: true });
  };

  const handleEnd = () => {
    //console.log(Platform.OS, 'animation end');
  };

  const handleOnFrame = (event: any) => {
    const { frameNumber } = event?.nativeEvent || {};
    setState({ currentFrame: frameNumber });
  };

  const handleOnError = (event: any) => {
    console.log('handleOnError', event?.nativeEvent?.error);
    setState({ loading: false, error: event?.nativeEvent?.error });
  };

  async function getRandomGif(): Promise<string> {
    try {
      const response = await axios.get(
        `https://api.giphy.com/v1/gifs/random?api_key=0UTRbFtkMxAplrohufYco5IY74U8hOes&rating=R&tag=${searchKey}`
      );

      if (response.data) {
        return response.data.data.images.original.url;
      } else {
        throw new Error('GIF URL not found in response');
      }
    } catch (err) {
      throw new Error('Failed to fetch random GIF');
    }
  }

  return (
    <>
      <KeyboardAvoidingView style={styles.container} behavior="height">
        <Pressable onPressIn={handlePressIn} onPressOut={handlePressOut}>
          <View style={styles.gifContainer}>
            <GifPlayerView
              ref={gifPlayerRef}
              style={styles.box}
              source={{ uri: gifSrc }}
              paused={paused}
              loopCount={loopCount}
              onStart={handleStart}
              onStop={handleStop}
              onEnd={handleEnd}
              onFrame={handleOnFrame}
              onError={handleOnError}
              onLoad={(event) => {
                console.log('onLoad', event?.nativeEvent);
                const { duration: newDuration, frameCount: newFrameCount } =
                  event?.nativeEvent || {};
                setState({
                  error: null,
                  loading: false,
                  duration: Math.round(newDuration),
                  frameCount: newFrameCount,
                });
              }}
            />
            {loading ? (
              <View style={styles.loader}>
                <ActivityIndicator size="large" color="white" />
              </View>
            ) : error !== null ? (
              <Text style={styles.error}>{error}</Text>
            ) : null}
          </View>
        </Pressable>
        <View style={styles.footer}>
          <View style={styles.footerTop}>
            <TextInput
              style={styles.textInput}
              value={searchKey}
              onChangeText={(t) => {
                setState({ searchKey: t });
              }}
            />
          </View>
          <View style={styles.footerBottom}>
            <IconButton
              width={40}
              height={33}
              icon={ResetIcon}
              onPress={() => {
                if (gifPlayerRef.current !== null) {
                  gifPlayerRef.current.jumpToFrame(0);
                }
              }}
            />
            <IconButton
              width={60}
              height={60}
              icon={paused ? PauseIcon : PlayIcon}
              onPress={() => {
                setState({ paused: !paused });
              }}
            />
            <IconButton
              width={40}
              height={37}
              icon={NextIcon}
              onPress={async () => {
                setState({ loading: true });
                await randomGif();
                setState({ paused: false });
              }}
            />
            <IconButton
              width={40}
              height={40}
              icon={LoopIcon}
              tintColor={loopCount === 0 ? '#388e3c' : 'white'}
              onPress={() => {
                setState({ loopCount: loopCount === 0 ? 1 : 0 });
              }}
            />
          </View>
        </View>
      </KeyboardAvoidingView>
      <GifInfo
        duration={duration}
        frameCount={frameCount}
        currentFrame={currentFrame}
      />
    </>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'black',
  },
  box: {
    position: 'absolute',
    alignSelf: 'center',
    width: screenWidth,
    height: undefined,
    aspectRatio,
  },
  footer: {
    position: 'absolute',
    bottom: 40,
    flexDirection: 'column',
  },
  footerTop: {
    alignItems: 'center',
  },
  footerBottom: {
    marginTop: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-around',
    backgroundColor: 'black',
    width: '100%',
    borderRadius: 10,
  },
  centerIcon: {
    width: 60,
    height: 60,
  },
  error: {
    color: '#FFF',
    fontSize: 23,
  },
  gifContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loader: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
    top: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  textInput: {
    width: 300,
    height: 50,
    backgroundColor: 'white',
    borderWidth: 1,
    paddingHorizontal: 10,
    borderRadius: 10,
    color: 'black',
  },
});
