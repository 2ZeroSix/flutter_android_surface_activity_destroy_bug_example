package com.example.android_destroy_activity

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class NativeView(var context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
  private val textView = TextView(context)

  override fun getView(): View {
    return textView
  }

  override fun dispose() {}

  init {
    textView.textSize = 12f
    textView.text = "Rendered on a native Android view (id: $id)"
    textView.setBackgroundColor(Color.argb(127, 0, 0, 255))
  }
}

class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val creationParams = args as Map<String?, Any?>?
    return NativeView(context, viewId, creationParams)
  }
}