import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:foody_app/data/api/auth.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/login/form/password_form.dart';
import 'package:foody_app/routes/login/form/signup_form.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class LoginMailForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  LoginMailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Continua nel servizio',
            style: Theme.of(context).textTheme.headline5,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              label: Text('Indirizzo e-mail'),
              prefixIcon: Icon(Icons.email),
              helperText:
                  'Inserisci il tuo indirizzo e-mail per accedere o registrarti',
              filled: true,
            ),
            validator: fieldValidator(then: EmailValidator.validate),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: LoadingButton(
              label: const Text('CONTINUA'),
              onPressed: () => _submitForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;

    final email = _emailController.text;
    final Widget Function(BuildContext _) nextRoute;

    final bool userExists;
    try {
      userExists = await getIt.get<AuthApi>().emailExists(email);
    } catch (err) {
      return handleApiError(err, context);
    }

    if (userExists) {
      nextRoute = (_) => LoginPasswordForm(email: email);
    } else {
      nextRoute = (_) => SignUpForm(email: email);
    }

    Navigator.push(context, MaterialPageRoute(builder: nextRoute));
  }
}
