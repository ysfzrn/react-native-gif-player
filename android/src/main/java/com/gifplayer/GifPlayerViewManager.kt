package com.gifplayer

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = GifPlayerViewManager.NAME)
class GifPlayerViewManager :
  GifPlayerViewManagerSpec<GifPlayerView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): GifPlayerView {
    return GifPlayerView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: GifPlayerView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "GifPlayerView"
  }
}
