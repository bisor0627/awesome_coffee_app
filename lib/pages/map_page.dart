import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_cafe/global/enum/view_state.dart';
import 'package:awesome_cafe/global/model/cafe_model.dart';
import 'package:awesome_cafe/global/provider/cafe_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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

  void _onDoubleTap() {
    controller.zoom += 0.5;
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

  Widget _buildMarkerWidget(CafeModel cafe, Offset pos, Color color, [IconData icon = CupertinoIcons.placemark_fill]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 5 * (controller.zoom * 1.6),
      height: 5 * (controller.zoom * 1.6),
      child: GestureDetector(
        child: controller.zoom < 15
            ? Icon(icon)
            : Container(
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.7), borderRadius: BorderRadius.circular(10)),
                child: Column(children: [Text(cafe.name), Text(cafe.location)]),
              ),
        onTap: () {
          _launchUrl(Uri.parse(cafe.link));
        },
      ),
    );
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  Widget _myLocation(Offset pos, Color color, [IconData icon = CupertinoIcons.smallcircle_circle_fill]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 30,
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
    return Consumer<CafeProvider>(builder: (_, watch, __) {
      switch (watch.state) {
        case ViewState.Busy:
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        case ViewState.Error:
        case ViewState.Idle:
        default:
          return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: mapBuilder(watch),
              bottomSheet: bottomList(context, watch));
      }
    });
  }

  SizedBox bottomList(BuildContext context, CafeProvider watch) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: watch.cafeList.length,
          itemBuilder: (context, index) {
            CafeModel? item = watch.cafeList[index];
            return InkWell(
              onTap: () {
                _launchUrl(Uri.parse(item?.link ?? ''));
              },
              child: Column(
                children: [Text(item?.name ?? ''), Text(item?.link ?? ''), Text(item?.address.toString() ?? '')],
              ),
            );
          }),
    );
  }

  MapLayoutBuilder mapBuilder(CafeProvider watch) {
    return MapLayoutBuilder(
      controller: controller,
      builder: (context, transformer) {
        late dynamic markerWidgets = [];
        if (watch.state != ViewState.Idle) {
          markerWidgets = watch.cafeList.map(
            (cafe) => _buildMarkerWidget(cafe!, transformer.fromLatLngToXYCoords(cafe.address!.latLng!), Colors.red),
          );
        }

        final centerLocation =
            Offset(transformer.constraints.biggest.width / 2, transformer.constraints.biggest.height / 2);
        final centerMarkerWidget = _myLocation(centerLocation, Colors.purple);

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
                if (watch.state == ViewState.Idle) ...markerWidgets,
                centerMarkerWidget,
              ],
            ),
          ),
        );
      },
    );
  }
}
