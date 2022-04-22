import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class LoginPasswordForm extends StatefulWidget {
  final String email;

  const LoginPasswordForm({required this.email, Key? key}) : super(key: key);

  @override
  State<LoginPasswordForm> createState() => _LoginPasswordFormState();
}

class _LoginPasswordFormState extends State<LoginPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  String? loginError;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Accedi',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(widget.email),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              label: const Text('Password'),
              filled: true,
              errorText: loginError,
            ),
            validator: fieldValidator(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: LoadingButton(
              label: const Text('ACCEDI'),
              onPressed: () => _submitForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final password = _passwordController.text;

    try {
      await context.read<LoginStatus>().login(widget.email, password);
      Navigator.of(context, rootNavigator: true).pop();
    } catch (err) {
      if (err is NotLoggedInException) {
        setState(() {
          loginError = 'Password errata, riprova';
        });
      } else {
        handleApiError(err, context);
      }
    }
  }
}
