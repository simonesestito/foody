import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foody_app/data/api/cart.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/orders.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/cart_product.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/customer_orders.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:http/http.dart' as http;

class OrderConfirm extends SingleChildBaseRoute {
  static final routeName = UserRole.cliente.routePrefix + '/order_confirm';
  final _streetField = TextEditingController();
  final _houseNumberField = TextEditingController();
  final _cityField = TextEditingController();
  final _notesField = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  OrderConfirm({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<CartProduct>>(
        future: getIt.get<CartApi>().getCart(),
        builder: (context, snap) {
          if (snap.hasError) {
            handleApiError(snap.error!, context);
            return ErrorWidget(snap.error!);
          } else if (snap.hasData) {
            return Form(
              key: _formKey,
              child: Column(children: [
                Text(
                  'Conferma indirizzo di spedizione',
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextFormField(
                  controller: _streetField,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Via'),
                  ),
                  validator: fieldValidator(),
                ),
                TextFormField(
                  controller: _houseNumberField,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Numero civico'),
                  ),
                ),
                TextFormField(
                  controller: _cityField,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Città'),
                  ),
                  validator: fieldValidator(),
                ),
                TextFormField(
                  controller: _notesField,
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text('Eventuali note'),
                    prefixIcon: Icon(Icons.notes),
                  ),
                ),
                LoadingButton(
                  onPressed: () => _onOrderConfirm(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Conferma ordine'),
                ),
              ]),
            );
          } else {
            return const SizedBox.square(
              dimension: 36,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Future<void> _onOrderConfirm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final street = _streetField.text;
    final houseNumber = _houseNumberField.text;
    final city = _cityField.text;
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

      final jsonBody =
          json.decode(locationResponse.body) as Map<String, dynamic>;
      final coordinates = jsonBody['features'][0]['center'];
      location = GpsLocation(
        latitude: coordinates[0],
        longitude: coordinates[1],
      );
    } catch (err) {
      handleApiError(err, context);
      return;
    }

    final address = Address(
      address: street,
      houseNumber: houseNumber,
      city: city,
      location: location,
    );

    _showAddressConfirmationDialog(context, address);
  }

  void _showAddressConfirmationDialog(BuildContext context, Address address) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Confermi l\'indirizzo e la posizione sulla mappa?\n$address'),
            content: Image.network(
              'https://api.mapbox.com/styles/v1/mapbox/${Theme.of(context).brightness == Brightness.dark ? 'dark-v10' : 'streets-v11'}/static/pin-s+555555(${address.location.latitude},${address.location.longitude})/${address.location.latitude},${address.location.longitude},16.5/600x300?access_token=pk.eyJ1Ijoic2ltb25lLXNlc3RpdG8iLCJhIjoiY2s5b251NzQwMDJoNzNlbnhkOXRtMGRyZSJ9.JPvm9gLEdOvsFgROr36-NQ',
            ),
            actions: [
              LoadingButton(
                onPressed: () => _onAddressConfirm(context, address),
                icon: const Icon(Icons.check),
                label: const Text('Conferma ordine'),
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.cancel),
                label: const Text('Annulla'),
              ),
            ],
          );
        });
  }

  Future<void> _onAddressConfirm(BuildContext context, Address address) async {
    try {
      await getIt.get<CustomerOrdersApi>().postOrder(address, _notesField.text);
      Navigator.pushReplacementNamed(context, CustomerOrdersRoute.routeName);
    } catch (err) {
      handleApiError(err, context);
    }
  }
}
