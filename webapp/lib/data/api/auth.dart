import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/data/model/user_session.dart';

abstract class AuthApi {
  Future<User> login(String email, String password);

  Future<void> logout([String? token]);

  Future<User> getMe();

  Future<User> signUp(NewUser newUser);

  Future<List<UserSession>> getSessions();

  Future<bool> emailExists(String email);
}
