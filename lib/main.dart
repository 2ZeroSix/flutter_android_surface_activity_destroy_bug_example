import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  bool isBareSurfaceViewEnabled = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      value: 1,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// will disappear if NativeSurfaceView is present
                /// but will appear again if we disable it
                ValueListenableBuilder(
                  valueListenable: _controller,
                  child: NativeSurfaceViewLifecycleAware(),
                  builder: (context, value, child) => SizedBox(
                    height: value * 100,
                    child: child,
                  ),
                ),
                if (isBareSurfaceViewEnabled)
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    child: NativeSurfaceView(),
                    builder: (context, value, child) => SizedBox(
                      height: value * 100,
                      child: child,
                    ),
                  ),

                /// !!!!!
                /// measured distance for widget blinking after reattach to view
                /// less: text becomes invisible
                /// more: text is always visible
                /// !!!!!
                SizedBox(height: 1.7861),
                Text('I am blinking'),
              ],
            ),
          ),

          /// overlay widget
          Center(
            child: FloatingActionButton(
              onPressed: () {},
              tooltip: 'I will disappear',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      bottomSheet: TextButton(
        child: Text('toggle bare surface view'),
        onPressed: () {
          setState(() {
            isBareSurfaceViewEnabled = !isBareSurfaceViewEnabled;
          });
        },
      ),
    );
  }
}

class NativeSurfaceViewLifecycleAware extends StatefulWidget {
  const NativeSurfaceViewLifecycleAware({Key key}) : super(key: key);

  @override
  _NativeSurfaceViewLifecycleAwareState createState() =>
      _NativeSurfaceViewLifecycleAwareState();
}

class _NativeSurfaceViewLifecycleAwareState
    extends State<NativeSurfaceViewLifecycleAware> with WidgetsBindingObserver {
  bool wasDetached = false;
  int childKey = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// workaround for detached view
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(describeEnum(state));
    if (state == AppLifecycleState.detached) {
      wasDetached = true;
    } else if (wasDetached && state == AppLifecycleState.resumed) {
      wasDetached = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            ++childKey;
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return NativeSurfaceView(key: ValueKey(childKey));
  }
}

class NativeSurfaceView extends StatefulWidget {
  const NativeSurfaceView({Key key}) : super(key: key);

  @override
  _NativeSurfaceViewState createState() => _NativeSurfaceViewState();
}

class _NativeSurfaceViewState extends State<NativeSurfaceView> {
  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const viewType = 'native_view';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return PlatformViewLink(
      key: widget.key,
      viewType: viewType,
      surfaceFactory:
          (BuildContext context, PlatformViewController controller) {
        return AndroidViewSurface(
          controller: controller,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (PlatformViewCreationParams params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}
