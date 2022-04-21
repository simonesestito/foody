import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/manager.dart';
import 'package:foody_app/data/model/orders_management.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:foody_app/widgets/bottom_sheet.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class EmployeesRoute extends BaseRoute {
  const EmployeesRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    return [
      Text(
        'Impiegati di ${restaurant.name}',
        style: Theme.of(context).textTheme.headline4,
      ),
      _EmployeesContent(restaurant: restaurant),
    ].map((e) => SliverToBoxAdapter(child: e)).toList();
  }
}

class _EmployeesContent extends StatefulWidget {
  final Restaurant restaurant;

  const _EmployeesContent({
    required this.restaurant,
    Key? key,
  }) : super(key: key);

  @override
  State<_EmployeesContent> createState() => _EmployeesContentState();
}

class _EmployeesContentState extends State<_EmployeesContent> {
  Key _listKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrdersManagement>>(
      key: _listKey,
      future: getIt.get<ManagerApi>().getEmployees(widget.restaurant.id),
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

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => showAppBottomSheet(
                context,
                (context) => _buildHiringLayout(widget.restaurant, context),
                isScrollControlled: true,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Assumi'),
            ),
            for (final employee in snap.data!)
              ListTile(
                title: Text(employee.user.fullName + ' ' + employee.user.email),
                subtitle: Text('Assunto il ${employee.startDate}' +
                    (employee.endDate == null
                        ? ''
                        : '\nLicenziato il ${employee.endDate}')),
                trailing: employee.endDate == null &&
                    employee.user.id !=
                        context.read<LoginStatus>().currentUser!.id
                    ? IconButton(
                  onPressed: () => _onFireEmployee(employee),
                  icon: const Icon(Icons.delete),
                )
                    : null,
                leading: employee.endDate == null
                    ? const Icon(Icons.badge)
                    : const Icon(Icons.elderly),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHiringLayout(Restaurant restaurant, BuildContext context) {
    final emailController = TextEditingController();

    return Column(
      children: [
        Text('Assumi dipendente', style: Theme.of(context).textTheme.headline5),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email del nuovo assunto',
            filled: true,
          ),
        ),
        LoadingButton(
          text: const Text('Assumi'),
          icon: const Icon(Icons.badge),
          onTap: () async {
            await getIt.get<ManagerApi>().hireEmployeeByEmail(
                  restaurant.id,
                  emailController.text,
                );
            Navigator.pop(context);
            setState(() {
              _listKey = UniqueKey();
            });
          },
        ),
        Padding(
          padding: MediaQuery.of(context).viewInsets,
        ),
      ],
    );
  }

  void _onFireEmployee(OrdersManagement management) async {
    try {
      await getIt.get<ManagerApi>().fireEmployee(
        management.restaurant,
        management.user.id,
      );
      setState(() {
        _listKey = UniqueKey();
      });
    } catch (e) {
      handleApiError(e, context);
    }
  }
}
