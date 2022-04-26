import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody_app/data/api/admin_restaurants.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/admin/list_restaurants.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/bottom_sheet.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:foody_app/widgets/map.dart';

class EditRestaurantRoute extends SingleChildBaseRoute {
  static final String routeName =
      UserRole.admin.routePrefix + '/restaurants/details';

  const EditRestaurantRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: _EditRestaurantContent(
        restaurant:
            ModalRoute.of(context)!.settings.arguments as RestaurantWithMenu?,
      ),
    );
  }
}

class _EditRestaurantContent extends StatefulWidget {
  final Restaurant? restaurant;

  const _EditRestaurantContent({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<_EditRestaurantContent> createState() => _EditRestaurantContentState();
}

class _EditRestaurantContentState extends State<_EditRestaurantContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _managerEmailController = TextEditingController();
  final _phones = List<String>.empty(growable: true);
  bool _published = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.restaurant?.name ?? '';
    _streetController.text = widget.restaurant?.address.address ?? '';
    _houseNumberController.text = widget.restaurant?.address.houseNumber ?? '';
    _cityController.text = widget.restaurant?.address.city ?? '';
    _phones.addAll(widget.restaurant?.phoneNumbers ?? []);
    _published = widget.restaurant?.published ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            widget.restaurant == null
                ? 'Crea nuovo ristorante'
                : 'Modifica ristorante #${widget.restaurant!.id}',
            style: Theme.of(context).textTheme.headline5,
          ),
          if (widget.restaurant != null)
            OutlinedButton.icon(
              label: const Text('Elimina ristorante'),
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDeletion(context),
            ),
          TextFormField(
            controller: _nameController,
            validator: fieldValidator(),
            decoration: const InputDecoration(
              label: Text('Nome'),
              filled: true,
            ),
          ),
          const Text('Indirizzo'),
          TextFormField(
            controller: _streetController,
            decoration: const InputDecoration(
              filled: true,
              label: Text('Via'),
            ),
            validator: fieldValidator(),
          ),
          TextFormField(
            controller: _houseNumberController,
            decoration: const InputDecoration(
              filled: true,
              label: Text('Numero civico'),
            ),
          ),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              filled: true,
              label: Text('Città'),
            ),
            validator: fieldValidator(),
          ),
          const Divider(),
          if (widget.restaurant == null)
            TextFormField(
              controller: _managerEmailController,
              validator: fieldValidator(then: EmailValidator.validate),
              decoration: const InputDecoration(
                label: Text('E-mail del primo dipendente'),
                filled: true,
              ),
            ),
          CheckboxListTile(
            value: _published,
            title: const Text('Pubblicato'),
            onChanged: (value) => setState(() {
              _published = value ?? false;
            }),
          ),
          const Text('Numeri di telefono'),
          TextButton.icon(
            onPressed: () => showInputBottomSheet(
              context,
              (_) => InputBottomSheet(
                title: 'Aggiungi telefono',
                label: 'Numero di telefono',
                saveText: 'Aggiungi',
                saveIcon: const Icon(Icons.add),
                autofillHints: const [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.phone,
                validator: fieldValidator(then: phoneValidator),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]')),
                ],
                onSave: (phone) {
                  setState(() {
                    _phones.add(phone);
                  });
                },
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi'),
          ),
          for (final phone in _phones)
            ListTile(
              title: Text(phone),
              trailing: IconButton(
                onPressed: () => setState(() {
                  _phones.remove(phone);
                }),
                icon: const Icon(Icons.close),
              ),
            ),
          LoadingButton(
            label: const Text('Salva'),
            onPressed: () => _onFormSubmit(context),
          ),
        ]));
  }

  void _confirmDeletion(BuildContext context) {
    showAppBottomSheet(context, (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sei sicuro?',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            'Stai per eliminare il ristorante #${widget.restaurant!.id} ${widget.restaurant!.name}',
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ANNULLA'),
              ),
              LoadingButton(
                onPressed: () async {
                  await getIt
                      .get<AdminRestaurantsApi>()
                      .deleteRestaurant(widget.restaurant!.id);
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(ListRestaurantsRoute.routeName),
                  );
                },
                label: const Text('ELIMINA'),
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _onFormSubmit(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final address = await validateInputAddress(
      context,
      _streetController.text,
      _houseNumberController.text,
      _cityController.text,
    );

    if (address == null) return;

    final restaurant = Restaurant(
      id: widget.restaurant?.id ?? -1,
      name: _nameController.text,
      published: _published,
      address: address,
      phoneNumbers: _phones,
      openingHours: [],
      // TODO: Vedere se appare un ristorante cosi
      averageRating: null,
    );

    try {
      if (widget.restaurant == null) {
        await getIt.get<AdminRestaurantsApi>().addRestaurant(
              restaurant,
              _managerEmailController.text,
            );
      } else {
        await getIt.get<AdminRestaurantsApi>().updateRestaurant(restaurant);
      }
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }
}
