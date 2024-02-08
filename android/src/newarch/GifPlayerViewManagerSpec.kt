package com.gifplayer

import android.view.View

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.GifPlayerViewManagerDelegate
import com.facebook.react.viewmanagers.GifPlayerViewManagerInterface

abstract class GifPlayerViewManagerSpec<T : View> : SimpleViewManager<T>(), GifPlayerViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = GifPlayerViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? {
    return mDelegate
  }
}
