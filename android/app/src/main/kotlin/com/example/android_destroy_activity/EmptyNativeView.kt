package com.example.android_destroy_activity

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class EmptyNativeView(var context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
  val emptyView = View(context)

  override fun getView(): View {
    return emptyView
  }

  override fun dispose() {}

  init {
  }
}

class EmptyNativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val creationParams = args as Map<String?, Any?>?
    return EmptyNativeView(context, viewId, creationParams)
  }
}