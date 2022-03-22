// TODO: Dependency injection
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:foody_app/data/model/user.dart';

class UserApi {
  Future<bool> emailExists(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<void> registerNewUser(NewUser user) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    throw NotLoggedInException();
  }
}
