import 'package:flutter/foundation.dart';
import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/data/model/user_session.dart';
import 'package:injectable/injectable.dart';

import '../auth.dart';
import '../errors/exceptions.dart';

@Injectable(as: AuthApi)
class AuthApiImpl implements AuthApi {
  final ApiClient apiClient;

  AuthApiImpl(this.apiClient);

  @override
  Future<bool> emailExists(String email) async {
    final result = await apiClient.get('/auth/mail', {'email': email});
    return result as bool;
  }

  @override
  Future<User?> getMe() async {
    final result = await apiClient.get('/auth/me');
    return result == null
        ? null
        : User.fromJson(result as Map<String, dynamic>);
  }

  @override
  Future<List<UserSession>> getSessions() async {
    final result = await apiClient.get('/auth/sessions') as List<dynamic>;
    return result.map((e) => UserSession.fromJson(e)).toList();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      await apiClient.post('/auth/login', {
        'username': email,
        'password': password,
      });
    } catch (e) {
      debugPrint(e.toString());
      throw NotLoggedInException();
    }

    return (await getMe())!;
  }

  @override
  Future<void> logout([String? token]) async {
    final Map<String, dynamic> params = token != null ? {'token': token} : {};
    await apiClient.post('/auth/login', params);
  }

  @override
  Future<User> signUp(NewUser newUser) async {
    await apiClient.post('/auth/signup', newUser.toJson());
    await login(newUser.emailAddress, newUser.password);
    return (await getMe())!;
  }
}
