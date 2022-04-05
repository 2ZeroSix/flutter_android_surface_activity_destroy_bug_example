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
  bool showBackgroundAndroidView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0.5, 0),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('under background'),
              backgroundColor: Colors.blue.withOpacity(0.5),
            ),
          ),
          if (showBackgroundAndroidView)
            SizedBox.expand(child: EmptyNativeSurfaceView()),
          Center(
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('bottom'),
              backgroundColor: Colors.blue.withOpacity(0.5),
            ),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: const NativeSurfaceView(),
            ),
          ),
          Align(
            alignment: Alignment(0.3, 0.3),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('middle'),
              backgroundColor: Colors.red.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(-0.3, 0.3),
            child: FloatingActionButton(
              onPressed: () {},
              child: Text('middle'),
              backgroundColor: Colors.green.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(0.1, 0.1),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('middle'),
              backgroundColor: Colors.red.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(-0.1, 0.1),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('middle'),
              backgroundColor: Colors.green.withOpacity(0.5),
            ),
          ),
          SizedBox.expand(
            child: ListView.builder(
              itemBuilder: (context, index) => SizedBox(
                height: 200,
                child: index < 5
                    ? null
                    : index % 2 == 0
                        ? const NativeSurfaceView()
                        : ColoredBox(
                            color: Colors.red.withOpacity(0.5),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              // child: TextField(),
                            ),
                          ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.1, -0.1),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('top'),
              backgroundColor: Colors.yellow.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(-0.1, -0.1),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('top'),
              backgroundColor: Colors.orange.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(0.3, -0.3),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('top'),
              backgroundColor: Colors.yellow.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(-0.3, -0.3),
            child: FloatingActionButton(
              elevation: 10,
              onPressed: () {},
              child: Text('top'),
              backgroundColor: Colors.orange.withOpacity(0.5),
            ),
          ),
        ],
      ),
      bottomSheet: TextButton(
        child: Text(
            '${showBackgroundAndroidView ? 'disable' : 'enable'} empty fullscreen  android view'),
        onPressed: () => setState(
            () => showBackgroundAndroidView = !showBackgroundAndroidView),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'floatingActionButton',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
    );
  }
}

class NativeSurfaceView extends StatelessWidget {
  const NativeSurfaceView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const viewType = 'native_view';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller,
              gestureRecognizers: const <
                  Factory<OneSequenceGestureRecognizer>>{},
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
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }
    throw UnsupportedError("Unsupported platform view");
  }
}

class EmptyNativeSurfaceView extends StatelessWidget {
  const EmptyNativeSurfaceView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const viewType = 'empty_native_view';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return PlatformViewLink(
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
