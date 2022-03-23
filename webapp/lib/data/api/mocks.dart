import 'package:foody_app/data/api/auth.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/data/model/user_session.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthApi)
class AuthApiImpl implements AuthApi {
  @override
  Future<bool> emailExists(String email) async => email == 'mario@rossi.it';

  @override
  Future<User> getMe() async => const User(
        id: 1,
        name: 'Mario',
        surname: 'Rossi',
        emailAddresses: ['mario@rossi.it'],
        phoneNumbers: ['333123123'],
        allowedRoles: [UserRole.customer],
      );

  @override
  Future<List<UserSession>> getSessions() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      UserSession(
        token: 'aaa',
        userAgent: 'Chrome',
        lastIpAddress: '1.1.1.1',
        creationDate:
            DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        lastUsageDate: DateTime.now(),
        isCurrent: true,
      ),
      UserSession(
        token: 'bbb',
        userAgent: 'Firefox',
        lastIpAddress: '1.0.0.1',
        creationDate: DateTime.now().subtract(const Duration(days: 4)),
        lastUsageDate: DateTime.now().subtract(const Duration(days: 2)),
        isCurrent: false,
      ),
    ];
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await getMe();
    if (email == user.email && password == 'ciao') {
      return user;
    } else {
      throw NotLoggedInException();
    }
  }

  @override
  Future<void> logout([String? token]) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<User> signUp(NewUser newUser) => getMe();
}
