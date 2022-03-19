import 'package:flutter/foundation.dart';

import '../data/model/user.dart';

class LoginStatus extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;
  UserRole? _role;

  LoginStatus() {
    _loadAuthStatus();
  }

  get isLoading => _isLoading;

  get currentUser => _user;

  get currentRole => _role;

  bool isLoggedIn() => _user != null;

  void _loadAuthStatus() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    // TODO: Update login status

    await Future.delayed(const Duration(seconds: 1));
    _user = User();

    _isLoading = false;
    notifyListeners();
  }

// TODO: Add login methods
}
