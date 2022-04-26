import 'package:flutter/material.dart';
import 'package:foody_app/data/api/cart.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/orders.dart';
import 'package:foody_app/data/model/cart_product.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/customer/customer_orders.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:foody_app/widgets/map.dart';

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

    final address = await validateInputAddress(
      context,
      _streetField.text,
      _houseNumberField.text,
      _cityField.text,
    );
    if (address != null) {
      try {
        await getIt.get<CustomerOrdersApi>().postOrder(
              address,
              _notesField.text,
            );
        Navigator.pushReplacementNamed(context, CustomerOrdersRoute.routeName);
      } catch (err) {
        handleApiError(err, context);
      }
    }
  }
}
