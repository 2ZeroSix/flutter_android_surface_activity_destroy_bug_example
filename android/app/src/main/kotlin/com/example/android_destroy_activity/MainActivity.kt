package com.example.android_destroy_activity

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {
  override fun provideFlutterEngine(context: Context): FlutterEngine? {
    val engineId = "engine_id"
    var cachedEngine: FlutterEngine? = FlutterEngineCache.getInstance().get(engineId)
    if (cachedEngine == null) {
      cachedEngine = FlutterEngine(
          this,
          arrayOf(),
          true,
          false
      )

      FlutterEngineCache.getInstance().put(engineId, cachedEngine)
      cachedEngine.platformViewsController.registry.registerViewFactory(
          "native_view",
          NativeViewFactory()
      )
    }

    return cachedEngine
  }
}
