import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/menu.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/manager/edit_category.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class EditMenuRoute extends SingleChildBaseRoute {
  final RestaurantMenu? menu;

  const EditMenuRoute({this.menu, Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurantId = ModalRoute.of(context)!.settings.arguments as int;
    return SliverToBoxAdapter(
      child: _EditMenuContent(menu: menu, restaurantId: restaurantId),
    );
  }
}

class _EditMenuContent extends StatefulWidget {
  final RestaurantMenu? menu;
  final int restaurantId;

  const _EditMenuContent({
    required this.menu,
    required this.restaurantId,
    Key? key,
  }) : super(key: key);

  @override
  State<_EditMenuContent> createState() => _EditMenuContentState();
}

class _EditMenuContentState extends State<_EditMenuContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _publishedCheck = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menu?.title ?? '';
    _publishedCheck = widget.menu?.published ?? false;
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Pubblicato'),
              Switch(
                value: _publishedCheck,
                onChanged: (value) => setState(() {
                  _publishedCheck = value;
                }),
              ),
            ],
          ),
          LoadingButton(
            onTap: () => _onSave(context),
            icon: const Icon(Icons.save),
            text: const Text('Salva'),
          ),
          if (widget.menu != null) ...[
            Text('Categorie', style: Theme.of(context).textTheme.headline6),
            OutlinedButton.icon(
              onPressed: () => _onCreateCategory(context),
              icon: const Icon(Icons.add),
              label: const Text('Crea nuova'),
            ),
            for (final category in widget.menu?.categories ?? [])
              ListTile(
                title: Text(category.title),
                subtitle: Text('${category.products.length} prodotti'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editCategory(context, category),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _deleteCategory(category),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  void _onCreateCategory(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryRoute(menu: widget.menu!),
      ),
    );
    Navigator.pop(context);
  }

  void _editCategory(BuildContext context, MenuCategory category) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryRoute(
          category: category,
          menu: widget.menu!,
        ),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _deleteCategory(MenuCategory category) async {
    try {
      await getIt.get<MenuApi>().removeCategory(category.id!);
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }

  Future<void> _onSave(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text;

    final menu = RestaurantMenu(
        id: widget.menu?.id ?? -1,
        title: name,
        categories: widget.menu?.categories ?? [],
        published: _publishedCheck,
        restaurant: widget.restaurantId);

    try {
      await getIt.get<MenuApi>().addMenu(menu);
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }
}
