import {
  StyleSheet,
  Text,
  View,
  type TouchableOpacityProps,
} from 'react-native';
import React from 'react';

type Props = TouchableOpacityProps & {
  duration: number;
  frameCount: number;
  currentFrame: number;
};

export const GifInfo = (props: Props) => {
  const { duration, frameCount, currentFrame } = props;
  return (
    <View style={styles.container}>
      <Text style={styles.text}>duration: {duration} MS</Text>
      <Text style={styles.text}>frameCount: {frameCount}</Text>
      <Text style={styles.text}>currentFrame: {currentFrame}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: '#FFF',
    width: 150,
    position: 'absolute',
    top: 150,
    left: 5,
    borderRadius: 5,
    padding: 5,
    opacity: 0.8,
  },
  text: {
    color: 'black',
  },
});
