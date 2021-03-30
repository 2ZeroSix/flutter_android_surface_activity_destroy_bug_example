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
  bool isSecondSurfaceViewEnabled = true;

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
                SizedBox(
                  height: 100,
                  child: NativeSurfaceView(),
                ),
                if (isSecondSurfaceViewEnabled)
                  SizedBox(
                    height: 100,
                    child: NativeSurfaceView(),
                  ),
              ],
            ),
          ),

          /// overlay widget
          Center(
            child: FloatingActionButton(
              onPressed: () {},
              tooltip: 'I will render 1 time for every android view',
              child: Icon(Icons.add),
              backgroundColor: Colors.blue.withOpacity(0.5),
            ),
          ),
        ],
      ),
      bottomSheet: TextButton(
        child: Text('toggle second surface view'),
        onPressed: () {
          setState(() {
            isSecondSurfaceViewEnabled = !isSecondSurfaceViewEnabled;
          });
        },
      ),
    );
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
