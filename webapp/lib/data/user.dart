class User {
  // TODO
  final String name = 'Mario';
  final String surname = 'Rossi';
  final String email = 'mario@rossi.it';
  final List<UserRole> allowedRoles = [
    UserRole.admin,
    UserRole.customer,
    UserRole.rider,
  ];

  get fullName => '$name $surname';
}

enum UserRole {
  customer,
  manager,
  admin,
  rider,
}

extension UserRoleExtension on UserRole {
  String get routePrefix {
    switch (this) {
      case UserRole.customer:
        return '/customer';
      case UserRole.manager:
        return '/manager';
      case UserRole.admin:
        return '/admin';
      case UserRole.rider:
        return '/rider';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Cliente';
      case UserRole.manager:
        return 'Manager ristorante';
      case UserRole.admin:
        return 'Admin piattaforma';
      case UserRole.rider:
        return 'Rider consegne';
    }
  }
}
