import 'package:awesome_cafe/global/enum/view_state.dart';
import 'package:awesome_cafe/global/model/cafe_model.dart';
import 'package:awesome_cafe/global/provider/cafe_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
// import 'package:html/dom.dart' show Document;
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CafeProvider()),
        // ChangeNotifierProvider(create: (_) => ParentProvider()),
      ],
      child: MaterialApp(
        title: 'Awesome Cafe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Awesome Cafe'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      context.read<CafeProvider>().getCafe();
    });
    super.initState();
  }

  final controller = MapController(
    location: LatLng(37.566, 126.978),
  );

  final markers = [
    LatLng(35.674, 51.41),
    LatLng(35.678, 51.41),
    LatLng(35.682, 51.41),
    LatLng(35.686, 51.41),
  ];
  void _gotoDefault() {
    controller.center = LatLng(35.68, 51.41);
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color, [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text('You have clicked a marker!'),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<CafeProvider>(builder: (_, watch, __) {
        if (watch.state == ViewState.Busy) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return MapLayoutBuilder(
          controller: controller,
          builder: (context, transformer) {
            final markerPositions = markers.map(transformer.fromLatLngToXYCoords).toList();

            final markerWidgets = markerPositions.map(
              (pos) => _buildMarkerWidget(pos, Colors.red),
            );

            final centerLocation =
                Offset(transformer.constraints.biggest.width / 2, transformer.constraints.biggest.height / 2);

            final centerMarkerWidget = _buildMarkerWidget(centerLocation, Colors.purple);

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: _onDoubleTap,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    final delta = event.scrollDelta;

                    controller.zoom -= delta.dy / 1000.0;
                    setState(() {});
                  }
                },
                child: Stack(
                  children: [
                    Map(
                      controller: controller,
                      builder: (context, x, y, z) {
                        //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                        //Google Maps
                        final url =
                            'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                        return CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    ...markerWidgets,
                    centerMarkerWidget,
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomSheet: Consumer<CafeProvider>(builder: (_, watch, __) {
        if (watch.state == ViewState.Busy) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: watch.cafeList.length,
              itemBuilder: (context, index) {
                CafeModel? item = watch.cafeList[index];
                return Column(
                  children: [Text(item?.name ?? ''), Text(item?.link ?? ''), Text(item?.location ?? '')],
                );
              }),
        );
      }),
    );
  }
}
