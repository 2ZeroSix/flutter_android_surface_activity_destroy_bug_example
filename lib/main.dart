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
            child: FloatingActionButton(
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
            alignment: Alignment(0.1, 0.1),
            child: FloatingActionButton(
              onPressed: () {},
              child: Text('middle'),
              backgroundColor: Colors.red.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(-0.1, 0.1),
            child: FloatingActionButton(
              onPressed: () {},
              child: Text('middle'),
              backgroundColor: Colors.green.withOpacity(0.5),
            ),
          ),
          SizedBox.expand(
            child: ListView.builder(
              itemBuilder: (context, index) => SizedBox(
                  height: 200,
                  child: index < 5 ? null : const NativeSurfaceView()),
            ),
          ),
          Align(
            alignment: Alignment(0.1, -0.1),
            child: FloatingActionButton(
              onPressed: () {},
              child: Text('top'),
              backgroundColor: Colors.yellow.withOpacity(0.5),
            ),
          ),
          Align(
            alignment: Alignment(-0.1, -0.1),
            child: FloatingActionButton(
              onPressed: () {},
              child: Text('top'),
              backgroundColor: Colors.orange.withOpacity(0.5),
            ),
          ),
        ],
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
