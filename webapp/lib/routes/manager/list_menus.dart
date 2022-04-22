import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/menu.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/menu.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/manager/edit_menu.dart';

class ListMenusRoute extends BaseRoute {
  const ListMenusRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) {
    final restaurant =
        ModalRoute.of(context)!.settings.arguments as RestaurantWithMenu;
    return [
      Text(
        'Menu di ${restaurant.name}',
        style: Theme.of(context).textTheme.headline4,
      ),
      _ListMenusContent(restaurant: restaurant),
    ].map((e) => SliverToBoxAdapter(child: e)).toList();
  }
}

class _ListMenusContent extends StatefulWidget {
  final RestaurantWithMenu restaurant;

  const _ListMenusContent({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  State<_ListMenusContent> createState() => _ListMenusContentState();
}

class _ListMenusContentState extends State<_ListMenusContent> {
  Key _listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RestaurantWithMenu>(
      key: _listKey,
      future: getIt.get<RestaurantsApi>().getRestaurant(widget.restaurant.id),
      builder: (context, snap) {
        if (snap.hasError) {
          handleApiError(snap.error!, context);
          return ErrorWidget(snap.error!);
        }

        if (!snap.hasData) {
          return const SizedBox.square(
            dimension: 36,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final restaurant = snap.data!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditMenuRoute(),
                    settings: RouteSettings(arguments: restaurant.id),
                  )).then((value) => setState(() {
                    _listKey = UniqueKey();
                  })),
              icon: const Icon(Icons.add),
              label: const Text('Crea nuovo'),
            ),
            for (final menu in restaurant.menus)
              ListTile(
                title: Text(menu.title),
                subtitle: menu.published
                    ? const Text('Pubblicato')
                    : const Text('Bozza'),
                leading: menu.published
                    ? const Icon(Icons.restaurant)
                    : const Icon(Icons.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _onEditMenu(menu),
                      icon: const Icon(Icons.edit),
                    ),
                    if (!menu.published) ...[
                      IconButton(
                        onPressed: () => _onDeleteMenu(menu),
                        icon: const Icon(Icons.delete),
                      ),
                    ]
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  void _onEditMenu(RestaurantMenu menu) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditMenuRoute(menu: menu),
          settings: RouteSettings(arguments: widget.restaurant.id),
        ),
      );
      setState(() {
        _listKey = UniqueKey();
      });
    } catch (e) {
      handleApiError(e, context);
    }
  }

  void _onDeleteMenu(RestaurantMenu menu) async {
    try {
      await getIt.get<MenuApi>().deleteMenu(menu);
      setState(() {
        _listKey = UniqueKey();
      });
    } catch (e) {
      handleApiError(e, context);
    }
  }
}
