import 'package:foody_app/routes/login/route.dart';

abstract class ApiException implements Exception {
  const ApiException();

  ///
  /// Return the user-friendly message to display.
  /// In a situation with localization, returning the string code would have been ideal.
  ///
  String get displayMessage;
}

abstract class RedirectApiException extends ApiException {
  String get redirectRoute;
}

class BadFormException extends ApiException {
  static const int errorCode = 422;

  @override
  String get displayMessage => 'Errore nell\'input fornito';
}

class ConflictDataException extends ApiException {
  static const int errorCode = 409;
  final String? message;

  const ConflictDataException(this.message) : super();

  @override
  String get displayMessage =>
      message ?? 'Dati da inserire in conflitto con altri già esistenti';
}

class NotLoggedInException extends RedirectApiException {
  static const int errorCode = 401; // Unauthorized

  @override
  String get displayMessage => 'Login richiesto per questa azione';

  @override
  String get redirectRoute => LoginRoute.routeName;
}

class UnauthorizedException extends ApiException {
  static const int errorCode = 403; // Forbidden

  @override
  String get displayMessage => 'Non disponi delle autorizzazioni necessarie';
}

class NotFoundException extends ApiException {
  static const int errorCode = 404;

  @override
  String get displayMessage => 'Elemento non trovato';
}

class BadRequestError extends ApiException {
  static const int errorCode = 400;
  final String? message;

  const BadRequestError(this.message) : super();

  @override
  String get displayMessage => message ?? 'Errore generico lato client';
}

class ServerError extends ApiException {
  static const int errorCode = 500;

  @override
  String get displayMessage => 'Errore lato server';
}

class UnknownApiError extends ApiException {
  final int errorCode;

  UnknownApiError(this.errorCode);

  @override
  String get displayMessage => 'Errore sconosciuto: $errorCode';
}
