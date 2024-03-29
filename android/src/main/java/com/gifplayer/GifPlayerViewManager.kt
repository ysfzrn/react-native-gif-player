package com.gifplayer

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.UIManagerHelper
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

  @ReactProp(name = "source")
  override fun setSource(view: GifPlayerView?, value: ReadableMap?) {
    val uri = value?.getString("uri");
    val local = value?.getBoolean("local");

    if (uri != null && local != null) {
      view?.setSource(value)
    }
  }
  @ReactProp(name = "paused")
  override fun setPaused(view: GifPlayerView?, value: Boolean) {
    view?.setPaused(value)
  }

  @ReactProp(name = "loopCount")
  override fun setLoopCount(view: GifPlayerView?, value: Int) {
    view?.setLoopCount(value)
  }

  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any>? {
    return MapBuilder.of(
      OnLoadEvent.NAME,
      MapBuilder.of("registrationName", OnLoadEvent.EVENT_PROP_NAME),
      OnStartEvent.NAME,
      MapBuilder.of("registrationName", OnStartEvent.EVENT_PROP_NAME),
      OnStopEvent.NAME,
      MapBuilder.of("registrationName", OnStopEvent.EVENT_PROP_NAME),
      OnEndEvent.NAME,
      MapBuilder.of("registrationName", OnEndEvent.EVENT_PROP_NAME),
      OnFrameEvent.NAME,
      MapBuilder.of("registrationName", OnFrameEvent.EVENT_PROP_NAME),
      OnErrorEvent.NAME,
      MapBuilder.of("registrationName", OnErrorEvent.EVENT_PROP_NAME)
    )
  }

  override fun addEventEmitters(reactContext: ThemedReactContext, view: GifPlayerView) {
    super.addEventEmitters(reactContext, view)
    view.setOnGifPlayerViewListener(object: GifPlayerView.GifPlayerViewListener{
      override fun onLoad(payload: OnLoadPayloadType) {
        UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
          ?.dispatchEvent(
            OnLoadEvent(
              UIManagerHelper.getSurfaceId(reactContext),
              view.id,
              payload
            )
          )
      }

      override fun onStart(payload: String) {
        UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
          ?.dispatchEvent(
            OnStartEvent(
              UIManagerHelper.getSurfaceId(reactContext),
              view.id,
              payload
            )
          )
      }

      override fun onStop(payload: String) {
        UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
          ?.dispatchEvent(
            OnStopEvent(
              UIManagerHelper.getSurfaceId(reactContext),
              view.id,
              payload
            )
          )
      }

      override fun onEnd(payload: String) {
        UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
          ?.dispatchEvent(
            OnEndEvent(
              UIManagerHelper.getSurfaceId(reactContext),
              view.id,
              payload
            )
          )
      }

      override fun onFrame(payload: Int) {
        UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
          ?.dispatchEvent(
            OnFrameEvent(
              UIManagerHelper.getSurfaceId(reactContext),
              view.id,
              payload
            )
          )
      }

      override fun onError(payload: String) {
        UIManagerHelper.getEventDispatcherForReactTag(reactContext, view.id)
          ?.dispatchEvent(
            OnErrorEvent(
              UIManagerHelper.getSurfaceId(reactContext),
              view.id,
              payload
            )
          )
      }
    })
  }

  override fun receiveCommand(root: GifPlayerView, commandId: String?, args: ReadableArray?) {
    super.receiveCommand(root, commandId, args)
    when(commandId){
      "jumpToFrame" ->  {
        val frameNumber = args?.getInt(0)
        if (frameNumber != null) {
          jumpToFrame(root, frameNumber)
        }
      }
    }
  }

  override fun jumpToFrame(view: GifPlayerView?, frameNumber: Int) {
    view?.jumpToFrame(frameNumber)
  }

  companion object {
    const val NAME = "GifPlayerView"
  }
}
