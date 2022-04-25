import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/users.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UsersApi)
class UsersApiImpl implements UsersApi {
  final ApiClient apiClient;

  const UsersApiImpl(this.apiClient);

  @override
  Future<void> deleteUser(int user) async {
    await apiClient.delete('/users/$user');
  }

  @override
  Future<List<User>> listAll() async {
    final result = await apiClient.get('/users/') as List<dynamic>;
    return result.map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<void> updateUser(User user) async {
    await apiClient.post('/users/', user.toJson());
  }
}
