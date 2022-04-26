import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/globals.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class AppMapboxMap<T> extends StatefulWidget {
  final GpsLocation zoomLocation;
  final List<LatLng> markers;
  final List<T> markersData;
  final GpsLocation? userLocation;
  final void Function(dynamic item) onMarkerTap;
  final double zoom;
  final double tilt;

  const AppMapboxMap({
    required this.zoomLocation,
    required this.onMarkerTap,
    this.zoom = 15.0,
    this.tilt = 30.0,
    this.markers = const [],
    this.markersData = const [],
    this.userLocation,
    Key? key,
  }) : super(key: key);

  @override
  State<AppMapboxMap> createState() => _AppMapboxMapState<T>();
}

class _AppMapboxMapState<T> extends State<AppMapboxMap> {
  static const markerIcon = 'marker';
  static const userLocationIcon = 'user_location';
  static const symbolDataKey = 'data';
  late MapboxMapController _controller;

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      initialCameraPosition: CameraPosition(
        target: widget.zoomLocation.toLatLng(),
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
  }

  void _onStyleLoaded() async {
    // Add marker icon
    final markerAsset = await rootBundle.load('assets/icons/marker.png');
    _controller.addImage(markerIcon, markerAsset.buffer.asUint8List());
    final userLocationAsset =
        await rootBundle.load('assets/icons/user_location.png');
    _controller.addImage(
        userLocationIcon, userLocationAsset.buffer.asUint8List());

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
    if (widget.userLocation != null) {
      _controller.addSymbol(SymbolOptions(
        geometry: widget.userLocation!.toLatLng(),
        iconImage: userLocationIcon,
      ));
    }
  }

  void _onSymbolTapped(Symbol symbol) {
    void Function(T item) callback = (widget.onMarkerTap);
    final item = symbol.data?[symbolDataKey] as T?;
    if (item != null) callback(item);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

Future<Address?> validateInputAddress(
  BuildContext context,
  String street,
  String houseNumber,
  String city,
) async {
  final fullAddress = '$street, $houseNumber, $city';
  final GpsLocation location;

  try {
    final locationResponse = await http.get(Uri.https(
        'api.mapbox.com', '/geocoding/v5/mapbox.places/$fullAddress.json', {
      'country': 'it',
      'limit': '1',
      'proximity': 'ip',
      'types': 'address',
      'access_token': Globals.mapboxAccessToken,
    }));

    if (locationResponse.statusCode != 200) {
      throw ServerError();
    }

    final jsonBody = json.decode(locationResponse.body) as Map<String, dynamic>;
    final coordinates = jsonBody['features'][0]['center'];
    location = GpsLocation(
      latitude: coordinates[1],
      longitude: coordinates[0],
    );
  } catch (err) {
    handleApiError(err, context);
    return null;
  }

  final address = Address(
    address: street,
    houseNumber: houseNumber,
    city: city,
    location: location,
  );

  return _showAddressConfirmationDialog(context, address);
}

Future<Address?> _showAddressConfirmationDialog(
    BuildContext context, Address address) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Confermi l\'indirizzo e la posizione sulla mappa?\n$address'),
          content: Image.network(
            'https://api.mapbox.com/styles/v1/mapbox/${Theme.of(context).brightness == Brightness.dark ? 'dark-v10' : 'streets-v11'}/static/pin-s+555555(${address.location.longitude},${address.location.latitude})/${address.location.longitude},${address.location.latitude},16.5/600x300?access_token=pk.eyJ1Ijoic2ltb25lLXNlc3RpdG8iLCJhIjoiY2s5b251NzQwMDJoNzNlbnhkOXRtMGRyZSJ9.JPvm9gLEdOvsFgROr36-NQ',
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.cancel),
              label: const Text('Annulla'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, address),
              icon: const Icon(Icons.check),
              label: const Text('Conferma indirizzo'),
            ),
          ],
        );
      });
}
