import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foody_app/data/api/user.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class SignUpForm extends StatelessWidget {
  final String email;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _telephoneController = TextEditingController();

  SignUpForm({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Registrati come nuovo utente',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(email),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text('Nome'),
              filled: true,
            ),
            validator: fieldValidator(),
          ),
          TextFormField(
            controller: _surnameController,
            decoration: const InputDecoration(
              label: Text('Cognome'),
              filled: true,
            ),
            validator: fieldValidator(),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              label: Text('Password'),
              filled: true,
            ),
            validator: fieldValidator(),
          ),
          TextFormField(
            controller: _telephoneController,
            decoration: const InputDecoration(
              label: Text('Numero di telefono'),
              filled: true,
            ),
            autofillHints: const [AutofillHints.telephoneNumber],
            keyboardType: TextInputType.phone,
            validator: fieldValidator(then: phoneValidator),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]')),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: LoadingButton(
              text: const Text('REGISTRATI'),
              onTap: () => _submitForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final password = _passwordController.text;
    final name = _nameController.text;
    final surname = _surnameController.text;
    final phoneNumber = _telephoneController.text;

    await UserApi().registerNewUser(NewUser(
      name: name,
      surname: surname,
      emailAddress: email,
      password: password,
      phoneNumber: phoneNumber,
    ));

    Navigator.of(context, rootNavigator: true).pop();
  }
}
