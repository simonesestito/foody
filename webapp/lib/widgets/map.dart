import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody_app/globals.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class AppMapboxMap<T> extends StatefulWidget {
  final Future<LatLng> location;
  final List<LatLng> markers;
  final List<T> markersData;
  final void Function(dynamic item) onMarkerTap;
  final double zoom;
  final double tilt;

  const AppMapboxMap({
    required this.location,
    this.zoom = 15.0,
    this.tilt = 30.0,
    this.markers = const [],
    this.markersData = const [],
    required this.onMarkerTap,
    Key? key,
  }) : super(key: key);

  @override
  State<AppMapboxMap> createState() => _AppMapboxMapState<T>();
}

class _AppMapboxMapState<T> extends State<AppMapboxMap> {
  static const markerIcon = 'marker';
  static const symbolDataKey = 'data';
  static const _defaultLocation = LatLng(41.9019257, 12.5147147);
  late MapboxMapController _controller;

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      initialCameraPosition: CameraPosition(
        target: _defaultLocation,
        tilt: widget.tilt,
        zoom: widget.zoom,
      ),
      accessToken: Globals.mapboxAccessToken,
      styleString: Theme.of(context).brightness == Brightness.dark
          ? 'mapbox://styles/mapbox/dark-v10'
          : 'mapbox://styles/mapbox/streets-v11',
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
    );
  }

  void _onMapCreated(MapboxMapController controller) async {
    _controller = controller;

    try {
      final userLocation = await widget.location;
      await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userLocation,
          tilt: widget.tilt,
          zoom: widget.zoom,
        ),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onStyleLoaded() async {
    // Add marker icon
    final asset = await rootBundle.load('assets/icons/marker.png');
    _controller.addImage(markerIcon, asset.buffer.asUint8List());

    _controller.onSymbolTapped.add(_onSymbolTapped);

    // Add actual symbols
    _controller.clearSymbols();
    _controller.addSymbols(
      widget.markers
          .map((e) => SymbolOptions(
                geometry: e,
                iconImage: markerIcon,
              ))
          .toList(),
      widget.markersData.map<Map>((value) => {symbolDataKey: value}).toList(),
    );
  }

  void _onSymbolTapped(Symbol symbol) {
    void Function(T item) callback = (widget.onMarkerTap);
    final T item = symbol.data![symbolDataKey] as T;
    callback(item);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
