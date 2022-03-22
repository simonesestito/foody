// TODO: Dependency injection
import 'package:foody_app/data/model/user.dart';

class UserApi {
  Future<bool> emailExists(String email) async {
    await Future.delayed(const Duration(seconds: 2));
    return false;
  }

  Future<void> registerNewUser(NewUser user) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
