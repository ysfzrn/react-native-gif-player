import { GifPlayerView } from '../index';
import { Commands } from '../GifPlayerViewNativeComponent';

describe('GifPlayerView', () => {
  it('calls native jumpToFrame command with provided frame', () => {
    const jumpToFrameMock = jest
      .spyOn(Commands, 'jumpToFrame')
      .mockImplementation(jest.fn());

    const component = new GifPlayerView({
      paused: true,
      source: { uri: '' },
    } as any);

    (component as any).innerRef = { current: {} };
    component.render();

    component.jumpToFrame(5);

    expect(jumpToFrameMock).toHaveBeenCalledWith(expect.anything(), 5);
  });
});
