import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String surname;
  final List<String> emailAddresses;
  final List<String> phoneNumbers;
  final List<UserRole> allowedRoles;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.emailAddresses,
    required this.phoneNumbers,
    required this.allowedRoles,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  get fullName => '$name $surname';

  get email => emailAddresses.first;

  get phone => phoneNumbers.first;
}

@JsonSerializable()
class NewUser {
  final String name;
  final String surname;
  final String emailAddress;
  final String password;
  final String phoneNumber;

  const NewUser({
    required this.name,
    required this.surname,
    required this.emailAddress,
    required this.password,
    required this.phoneNumber,
  });

  factory NewUser.fromJson(Map<String, dynamic> json) =>
      _$NewUserFromJson(json);

  Map<String, dynamic> toJson() => _$NewUserToJson(this);
}

enum UserRole {
  cliente,
  manager,
  admin,
  rider,
}

extension UserRoleExtension on UserRole {
  String get routePrefix {
    switch (this) {
      case UserRole.cliente:
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
      case UserRole.cliente:
        return 'Cliente';
      case UserRole.manager:
        return 'Manager ristorante';
      case UserRole.admin:
        return 'Admin piattaforma';
      case UserRole.rider:
        return 'Rider consegne';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.cliente:
        return Icons.shopping_basket;
      case UserRole.manager:
        return Icons.storefront;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.rider:
        return Icons.delivery_dining;
    }
  }
}
