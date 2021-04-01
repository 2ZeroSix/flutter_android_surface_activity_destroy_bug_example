package com.example.android_destroy_activity

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    flutterEngine.platformViewsController.registry.registerViewFactory(
        "native_view",
        NativeViewFactory()
    )
    flutterEngine.platformViewsController.registry.registerViewFactory(
        "empty_native_view",
        EmptyNativeViewFactory()
    )
  }
}
