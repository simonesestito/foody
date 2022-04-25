import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/users.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/admin/list_users.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/bottom_sheet.dart';
import 'package:foody_app/widgets/loading_button.dart';

class EditUserRoute extends SingleChildBaseRoute {
  static final String routeName = UserRole.admin.routePrefix + '/users/details';

  const EditUserRoute({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User?;

    if (user == null) {
      Future.microtask(() => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    return SliverToBoxAdapter(
      child: _EditUserContent(user: user),
    );
  }
}

class _EditUserContent extends StatefulWidget {
  final User user;

  const _EditUserContent({Key? key, required this.user}) : super(key: key);

  @override
  State<_EditUserContent> createState() => _EditUserContentState();
}

class _EditUserContentState extends State<_EditUserContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emails = List<String>.empty(growable: true);
  final _phones = List<String>.empty(growable: true);
  bool _rider = false;
  bool _admin = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _surnameController.text = widget.user.surname;
    _emails.addAll(widget.user.emailAddresses);
    _phones.addAll(widget.user.phoneNumbers);
    _rider = widget.user.allowedRoles.contains(UserRole.rider);
    _admin = widget.user.allowedRoles.contains(UserRole.admin);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Modifica utente #${widget.user.id}',
            style: Theme.of(context).textTheme.headline5,
          ),
          OutlinedButton.icon(
            label: const Text('Elimina utente'),
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmUserDeletion(context),
          ),
          TextFormField(
            controller: _nameController,
            validator: fieldValidator(),
            decoration: const InputDecoration(
              label: Text('Nome'),
              filled: true,
            ),
          ),
          TextFormField(
            controller: _surnameController,
            validator: fieldValidator(),
            decoration: const InputDecoration(
              label: Text('Cognome'),
              filled: true,
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              label: Text('Modifica password'),
              filled: true,
            ),
          ),
          CheckboxListTile(
            value: _rider,
            title: const Text('Abilita a rider'),
            onChanged: (value) => setState(() {
              _rider = value ?? false;
            }),
          ),
          CheckboxListTile(
            value: _admin,
            title: const Text('Abilita ad amministratore'),
            onChanged: (value) => setState(() {
              _admin = value ?? false;
            }),
          ),
          const Text('Indirizzi e-mail'),
          TextButton.icon(
            onPressed: () => showInputBottomSheet(
              context,
              (_) => InputBottomSheet(
                title: 'Aggiungi email',
                label: 'Email',
                saveText: 'Aggiungi',
                saveIcon: const Icon(Icons.add),
                validator: fieldValidator(then: EmailValidator.validate),
                onSave: (email) {
                  setState(() {
                    _emails.add(email);
                  });
                },
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi'),
          ),
          for (final email in _emails)
            ListTile(
              title: Text(email),
              trailing: IconButton(
                onPressed: () => setState(() {
                  _emails.remove(email);
                }),
                icon: const Icon(Icons.close),
              ),
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
            onPressed: () => _saveUser(context),
          ),
        ]));
  }

  void _confirmUserDeletion(BuildContext context) {
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
            'Stai per eliminare l\'utente #${widget.user.id} ${widget.user.fullName}',
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
                  await getIt.get<UsersApi>().deleteUser(widget.user.id);
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(ListUsersRoute.routeName),
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

  Future<void> _saveUser(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final editedPassword = _passwordController.text;
    final user = User(
      id: widget.user.id,
      name: _nameController.text,
      surname: _surnameController.text,
      emailAddresses: _emails,
      phoneNumbers: _phones,
      password: editedPassword.isEmpty ? null : editedPassword,
      rider: _rider,
      admin: _admin,
      restaurantsNumber: widget.user.restaurantsNumber,
    );

    try {
      await getIt.get<UsersApi>().updateUser(user);
      Navigator.pop(context);
    } catch (err) {
      handleApiError(err, context);
    }
  }
}
