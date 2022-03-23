import 'package:json_annotation/json_annotation.dart';

part 'user_session.g.dart';

@JsonSerializable()
class UserSession {
  final String token;
  final String userAgent;
  final String lastIpAddress;
  final DateTime creationDate;
  final DateTime lastUsageDate;
  final bool isCurrent;

  const UserSession({
    required this.token,
    required this.userAgent,
    required this.lastIpAddress,
    required this.creationDate,
    required this.lastUsageDate,
    required this.isCurrent,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);
}
