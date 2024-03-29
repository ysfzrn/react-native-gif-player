package com.gifplayer

import android.view.View
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager

abstract class GifPlayerViewManagerSpec<T : View> : SimpleViewManager<T>() {
  abstract fun setSource(view: T?, value: ReadableMap?)
  abstract fun setPaused(view: T?, value: Boolean)
  abstract fun setLoopCount(view: T?, value: Int)

  abstract fun jumpToFrame(view: GifPlayerView?, frameNumber: Int)
}
