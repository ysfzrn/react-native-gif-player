package com.gifplayer

import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event


class EventManager {

}

data class OnLoadPayloadType(val duration: Double, val frameCount: Int)

open class OnLoadEvent(
  surfaceId: Int,
  viewId: Int,
  private val payload: OnLoadPayloadType
) : Event<OnLoadEvent>(surfaceId, viewId) {
  override fun getEventName() = NAME

  override fun getEventData(): WritableMap? {
    return createPayload()
  }

  private fun createPayload() = Arguments.createMap().apply {
    putDouble("duration", payload.duration)
    putInt("frameCount", payload.frameCount)
  }

  companion object {
    const val NAME = "topLoadEvent"
    const val EVENT_PROP_NAME = "onLoad"
  }
}


open class OnStartEvent(
  surfaceId: Int,
  viewId: Int,
  private val payload: String
) : Event<OnStartEvent>(surfaceId, viewId) {
  override fun getEventName() = NAME

  override fun getEventData(): WritableMap? {
    return createPayload()
  }

  private fun createPayload() = Arguments.createMap().apply {
    putString("arg", payload)
  }

  companion object {
    const val NAME = "topStartEvent"
    const val EVENT_PROP_NAME = "onStart"
  }
}


open class OnStopEvent(
  surfaceId: Int,
  viewId: Int,
  private val payload: String
) : Event<OnStopEvent>(surfaceId, viewId) {
  override fun getEventName() = NAME

  override fun getEventData(): WritableMap? {
    return createPayload()
  }

  private fun createPayload() = Arguments.createMap().apply {
    putString("arg", payload)
  }

  companion object {
    const val NAME = "topStopEvent"
    const val EVENT_PROP_NAME = "onStop"
  }
}

open class OnEndEvent(
  surfaceId: Int,
  viewId: Int,
  private val payload: String
) : Event<OnEndEvent>(surfaceId, viewId) {
  override fun getEventName() = NAME

  override fun getEventData(): WritableMap? {
    return createPayload()
  }

  private fun createPayload() = Arguments.createMap().apply {
    putString("arg", payload)
  }

  companion object {
    const val NAME = "topEndEvent"
    const val EVENT_PROP_NAME = "onEnd"
  }
}


open class OnFrameEvent(
  surfaceId: Int,
  viewId: Int,
  private val payload: Int
) : Event<OnFrameEvent>(surfaceId, viewId) {
  override fun getEventName() = NAME

  override fun getEventData(): WritableMap? {
    return createPayload()
  }

  private fun createPayload() = Arguments.createMap().apply {
    putInt("frameNumber", payload)
  }

  companion object {
    const val NAME = "topFrameEvent"
    const val EVENT_PROP_NAME = "onFrame"
  }
}

open class OnErrorEvent(
  surfaceId: Int,
  viewId: Int,
  private val payload: String
) : Event<OnErrorEvent>(surfaceId, viewId) {
  override fun getEventName() = NAME

  override fun getEventData(): WritableMap? {
    return createPayload()
  }

  private fun createPayload() = Arguments.createMap().apply {
    putString("error", payload)
  }

  companion object {
    const val NAME = "topErrorEvent"
    const val EVENT_PROP_NAME = "onError"
  }
}
