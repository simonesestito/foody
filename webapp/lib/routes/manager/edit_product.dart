import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/products.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class EditProductRoute extends SingleChildBaseRoute {
  final MenuProduct? product;

  const EditProductRoute({this.product, Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    return SliverToBoxAdapter(
      child: _EditProductContent(product: product, restaurant: restaurant),
    );
  }
}

class _EditProductContent extends StatefulWidget {
  final MenuProduct? product;
  final Restaurant? restaurant;

  const _EditProductContent({
    required this.product,
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  State<_EditProductContent> createState() => _EditProductContentState();
}

class _EditProductContentState extends State<_EditProductContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _checkedAllergens = List<bool>.filled(Allergen.values.length, false);

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product?.name ?? '';
    _descriptionController.text = widget.product?.description ?? '';
    _priceController.text = widget.product?.price.toStringAsFixed(2) ?? '';
    for (int i = 0; i < Allergen.values.length; i++) {
      _checkedAllergens[i] =
          widget.product?.allergens.contains(Allergen.values[i]) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              prefixIcon: Icon(Icons.restaurant),
              filled: true,
            ),
            validator: fieldValidator(),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrizione',
              prefixIcon: Icon(Icons.notes),
              filled: true,
            ),
          ),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Prezzo',
              prefixIcon: Icon(Icons.euro),
              filled: true,
            ),
            inputFormatters: [
              CurrencyTextInputFormatter(
                decimalDigits: 2,
                name: '',
              )
            ],
            keyboardType: TextInputType.number,
            validator: fieldValidator(
              then: (str) => (double.tryParse(str) ?? 0) > 0,
            ),
          ),
          Text('Allergeni', style: Theme.of(context).textTheme.headline6),
          for (final i in List.generate(Allergen.values.length, (i) => i))
            CheckboxListTile(
              title: Text(Allergen.values[i].displayName),
              value: _checkedAllergens[i],
              onChanged: (check) => setState(() {
                _checkedAllergens[i] = check ?? false;
              }),
            ),
          LoadingButton(
            onTap: () => _onSave(context),
            icon: const Icon(Icons.save),
            text: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text;
    final description = _descriptionController.text.isEmpty
        ? null
        : _descriptionController.text;
    final price = double.parse(_priceController.text);
    final allergens = List<Allergen>.empty(growable: true);
    Allergen.values.asMap().forEach((i, value) {
      if (_checkedAllergens[i]) allergens.add(value);
    });

    final product = MenuProduct(
      id: widget.product?.id ?? -1,
      name: name,
      description: description,
      price: price,
      allergens: allergens,
      restaurant: widget.restaurant!.id,
    );

    try {
      await getIt.get<ProductsApi>().addProduct(product);
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }
}
