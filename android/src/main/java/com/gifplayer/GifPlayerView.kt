package com.gifplayer

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.drawable.Animatable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.AttributeSet
import android.util.Log
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.drawee.controller.BaseControllerListener
import com.facebook.drawee.drawable.ScalingUtils
import com.facebook.drawee.view.SimpleDraweeView
import com.facebook.fresco.animation.backend.AnimationBackend
import com.facebook.fresco.animation.backend.AnimationBackendDelegate
import com.facebook.fresco.animation.drawable.AnimatedDrawable2
import com.facebook.imagepipeline.image.ImageInfo
import com.facebook.react.bridge.ReadableMap


class GifPlayerView : SimpleDraweeView {

  interface GifPlayerViewListener {
    fun onLoad(payload: OnLoadPayloadType)
    fun onStart(payload: String)
    fun onStop(payload: String)
    fun onEnd(payload: String)
    fun onFrame(payload: Int)
    fun onError(payload: String)
  }
  constructor(context: Context) : super(context)
  constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)
  constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(
    context,
    attrs,
    defStyleAttr
  )

  private var mListener: GifPlayerViewListener? = null
  private var globalPausedState: Boolean = false
  private var currentFrame: Int = 0
  private var globalLoopCount: Int = AnimationBackendDelegate.LOOP_COUNT_INFINITE

  init {
    Fresco.initialize(context)
  }

  fun setOnGifPlayerViewListener(listener: GifPlayerViewListener?) {
    mListener = listener
  }

  fun sendLoadEvent(payload: OnLoadPayloadType){
    mListener?.onLoad(payload)
  }

  fun sendStartEvent(payload: String){
    mListener?.onStart(payload)
  }

  fun sendStopEvent(payload: String){
    mListener?.onStop(payload)
  }

  fun sendEndEvent(payload: String){
    mListener?.onEnd(payload)
  }

  fun sendFrameEvent(payload: Int){
    mListener?.onFrame(payload)
  }

  fun sendErrorEvent(payload: String){
    mListener?.onError(payload)
  }


  @SuppressLint("DiscouragedApi")
  fun setSource(source: ReadableMap) {
    val uriString = source.getString("uri");
    val local = source.getBoolean("local");

    if(BuildConfig.DEBUG){
      val uriAddress = Uri.parse(uriString)
      val controller = Fresco.newDraweeControllerBuilder()
        .setUri(uriAddress)
        //.setAutoPlayAnimations(true)
        .setControllerListener(controlListener)
        .build();

      this.controller = controller;

    }else{
      if(local){

        val resourceId: Int =  context.resources.getIdentifier(uriString, "drawable", context.packageName)

        val controller = Fresco.newDraweeControllerBuilder()
          .setUri(Uri.parse("res:/$resourceId"))
          //.setAutoPlayAnimations(true)
          .setControllerListener(controlListener)
          .build();

        this.controller = controller;

      }else{
        val uriAddress = Uri.parse(uriString)

        val controller = Fresco.newDraweeControllerBuilder()
          .setUri(uriAddress)
          //.setAutoPlayAnimations(true)
          .setControllerListener(controlListener)
          .build();

        this.controller = controller;
      }

    }
    this.hierarchy.actualImageScaleType = ScalingUtils.ScaleType.FIT_CENTER
  }

  fun setPaused(paused: Boolean) {
    if (paused) {
      globalPausedState = false
      this.controller?.animatable?.stop()
    } else {
      this.controller?.animatable?.start()
      globalPausedState = true
    }
  }

  fun setLoopCount(loopCount: Int) {
    globalLoopCount = loopCount
  }

  fun jumpToFrame(frameNumber: Int) {
    val animatedDrawable = this.controller?.animatable as AnimatedDrawable2
    animatedDrawable.jumpToFrame(frameNumber)
  }




  private val controlListener = object : BaseControllerListener<ImageInfo>() {
    override fun onFailure(id: String?, throwable: Throwable?) {
      super.onFailure(id, throwable)
      if (throwable != null) {
        throwable.localizedMessage?.let { sendErrorEvent(it) }
      }else{
        sendErrorEvent("asset not loaded")
      }
    }

    override fun onFinalImageSet(id: String?, imageInfo: ImageInfo?, animatable: Animatable?) {
      if(animatable == null){
        val payload = OnLoadPayloadType(duration = 0.0, frameCount = 1)
        sendLoadEvent(payload)
        return
      }

      val animatedDrawable = animatable as AnimatedDrawable2

      val payload = OnLoadPayloadType(duration = animatedDrawable.loopDurationMs.toDouble(), frameCount = animatedDrawable.frameCount)
      sendLoadEvent(payload)

      val animationBackend = animatedDrawable.animationBackend
      animatedDrawable.animationBackend = (object :
        AnimationBackendDelegate<AnimationBackend?>(animationBackend) {
        override fun getLoopCount(): Int {
          return globalLoopCount
        }
      });

      if(globalPausedState){
        animatable.start()
      }else{
        animatable.stop()
      }

      animatedDrawable.setAnimationListener(object :
        com.facebook.fresco.animation.drawable.AnimationListener {
        override fun onAnimationFrame(drawable: Drawable, frameNumber: Int) {
          sendFrameEvent(frameNumber + 1)
          currentFrame = frameNumber + 1
          if(animatedDrawable.frameCount == frameNumber + 1){
            sendEndEvent("ended")
          }
        }

        override fun onAnimationRepeat(drawable: Drawable) {
          //Log.d("animation", "onAnimationRepeat")
          //sendRepeatEvent("repeated")
        }

        override fun onAnimationReset(drawable: Drawable) {
          //Log.d("animation", "onAnimationReset")
        }

        override fun onAnimationStart(drawable: Drawable) {
          //Log.d("animation", "onAnimationStart: +$currentFrame")
          sendStartEvent("started")
          if(currentFrame == animatable.frameCount){
            animatable.jumpToFrame(1)
          }
        }

        override fun onAnimationStop(drawable: Drawable) {
          //Log.d("animation", "onAnimationStop")
          sendStopEvent("stopped")
        }

      })
    }
  }
}

