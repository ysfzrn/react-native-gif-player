import {
  Image,
  StyleSheet,
  TouchableOpacity,
  type ImageProps,
  type TouchableOpacityProps,
} from 'react-native';
import React from 'react';

type Props = TouchableOpacityProps &
  ImageProps & {
    icon: any;
    width: number;
    height: any;
    tintColor?: string;
  };

export const IconButton = (props: Props) => {
  const { icon, width, height, onPress, tintColor = 'white' } = props;

  const style = {
    width,
    height,
  };

  return (
    <TouchableOpacity style={[styles.button, style]} onPress={onPress}>
      <Image style={styles.icon} source={icon} tintColor={tintColor} />
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  button: {},
  icon: {
    width: '100%',
    height: '100%',
  },
});
