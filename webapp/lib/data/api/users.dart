import 'package:foody_app/data/model/user.dart';

abstract class UsersApi {
  Future<List<User>> listAll();

  Future<void> updateUser(User user);

  Future<void> deleteUser(int user);
}
