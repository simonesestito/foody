import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/menu.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:foody_app/data/model/menu_product.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/manager/pick_product.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class EditCategoryRoute extends SingleChildBaseRoute {
  final MenuCategory? category;
  final RestaurantMenu menu;

  const EditCategoryRoute({
    this.category,
    required this.menu,
    Key? key,
  }) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return SliverToBoxAdapter(
      child: _EditCategoryContent(category: category, menu: menu),
    );
  }
}

class _EditCategoryContent extends StatefulWidget {
  final MenuCategory? category;
  final RestaurantMenu menu;

  const _EditCategoryContent({
    required this.category,
    required this.menu,
    Key? key,
  }) : super(key: key);

  @override
  State<_EditCategoryContent> createState() => _EditCategoryContentState();
}

class _EditCategoryContentState extends State<_EditCategoryContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category?.title ?? '';
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
              labelText: 'Titolo',
              prefixIcon: Icon(Icons.restaurant),
              filled: true,
            ),
            validator: fieldValidator(),
          ),
          LoadingButton(
            onTap: () => _onSave(context),
            icon: const Icon(Icons.save),
            text: const Text('Salva'),
          ),
          if (widget.category != null) ...[
            Text('Prodotti', style: Theme.of(context).textTheme.headline6),
            OutlinedButton.icon(
              onPressed: () => _onAddProduct(context),
              icon: const Icon(Icons.add),
              label: const Text('Aggiungi'),
            ),
            for (final product in widget.category?.products ?? [])
              ListTile(
                title: Text(product.name),
                subtitle: Text(product.price.toStringAsFixed(2)),
                trailing: IconButton(
                  onPressed: () => _removeProduct(context, product),
                  icon: const Icon(Icons.delete),
                ),
              ),
          ],
        ],
      ),
    );
  }

  void _onAddProduct(BuildContext context) async {
    final product = await Navigator.push<MenuProduct>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PickProductRoute(restaurantId: widget.menu.restaurant),
        ));

    if (product != null) {
      await getIt.get<MenuApi>().addProductToCategory(
            product.id,
            widget.category!.id!,
          );
      Navigator.pop(context);
    }
  }

  void _removeProduct(BuildContext context, MenuProduct product) async {
    try {
      await getIt.get<MenuApi>().removeProductFromCategory(
            product.id,
            widget.category!.id!,
          );
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text;

    final category = MenuCategory(
      id: widget.category?.id ?? -1,
      products: widget.category?.products ?? [],
      title: name,
      menu: widget.menu.id!,
    );

    try {
      await getIt.get<MenuApi>().addCategory(category);
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }
}
