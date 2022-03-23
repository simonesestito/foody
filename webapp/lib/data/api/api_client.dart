import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApiClient {
  static const httpAuthority =
      kReleaseMode ? 'foody.simonesestito.com' : 'localhost:5000';
  static const httpBasePath = '/api';
  final httpClient = Client();

  Future<String> get(String uri, [Map<String, dynamic>? queryParams]) {
    return httpClient.get(_buildUri(uri, queryParams)).then(_handleResponse);
  }

  Future<String> post(String uri, dynamic body) {
    if (body is! String) {
      body = json.encode(body);
    }

    return httpClient.post(_buildUri(uri), body: body, headers: {
      'Content-Type': 'application/json',
    }).then(_handleResponse);
  }

  Future<void> delete(String uri) {
    return httpClient.delete(_buildUri(uri)).then(_handleResponse);
  }

  String _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body;
      case BadFormException.errorCode:
        throw BadFormException();
      case ConflictDataException.errorCode:
        throw ConflictDataException();
      case NotLoggedInException.errorCode:
        throw NotLoggedInException();
      case UnauthorizedException.errorCode:
        throw UnauthorizedException();
      case NotFoundException.errorCode:
        throw NotFoundException();
      case BadRequestError.errorCode:
        throw BadRequestError();
      case ServerError.errorCode:
        throw ServerError();
      default:
        throw UnknownApiError(response.statusCode);
    }
  }

  Uri _buildUri(String uri, [Map<String, dynamic>? queryParams]) {
    if (kReleaseMode) {
      return Uri.https(httpAuthority, httpBasePath + uri, queryParams);
    } else {
      return Uri.http(httpAuthority, httpBasePath + uri, queryParams);
    }
  }
}
