import 'package:flutter/foundation.dart';
import 'package:foody_app/data/api/auth.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';

class LoginStatus extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;

  LoginStatus() {
    _loadAuthStatus();
  }

  bool get isLoading => _isLoading;

  User? get currentUser => _user;

  bool isLoggedIn() => _user != null;

  void _loadAuthStatus() => _withLoading(() async {
        _user = await getIt.get<AuthApi>().getMe();
      });

  Future<void> login(String email, String password) => _withLoading(() async {
        _user = await getIt.get<AuthApi>().login(email, password);
      }, skipLoadingNotification: true);

  Future<void> logout() => _withLoading(() async {
        await getIt.get<AuthApi>().logout();
        _user = null;
      });

  Future<void> _withLoading(Future<void> Function() action,
      {bool skipLoadingNotification = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    if (!skipLoadingNotification) notifyListeners();

    try {
      await action();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
