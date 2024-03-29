export const combineReducers = (state: any, action: any) => ({
  ...state,
  ...(typeof action === 'function' ? action(state) : action),
});
