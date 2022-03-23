import 'package:flutter/foundation.dart';
import 'package:foody_app/data/api/auth.dart';
import 'package:foody_app/di.dart';

import '../data/model/user.dart';

class LoginStatus extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;

  LoginStatus() {
    _loadAuthStatus();
  }

  get isLoading => _isLoading;

  get currentUser => _user;

  bool isLoggedIn() => _user != null;

  void _loadAuthStatus() => _withLoading(() async {
        _user = await getIt.get<AuthApi>().getMe();
      });

  Future<void> login(String email, String password) => _withLoading(() async {
        _user = await getIt.get<AuthApi>().login(email, password);
      });

  Future<void> logout() => _withLoading(() async {
        await getIt.get<AuthApi>().logout();
        _user = null;
      });

  Future<void> _withLoading(Future<void> Function() action) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      await action();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
