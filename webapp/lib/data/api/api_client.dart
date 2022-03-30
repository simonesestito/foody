import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ApiClient {
  static const _httpAuthority =
      kReleaseMode ? 'foody.simonesestito.com' : 'localhost:5000';
  static const _httpBasePath = '/api';
  final _httpClient = Client();

  Future<dynamic> get(String uri, [Map<String, dynamic>? queryParams]) {
    return _httpClient.get(_buildUri(uri, queryParams)).then(_handleResponse);
  }

  Future<dynamic> post(String uri, Map<String, dynamic> body) {
    return _httpClient.post(_buildUri(uri), body: json.encode(body), headers: {
      'Content-Type': 'application/json',
    }).then(_handleResponse);
  }

  Future<void> delete(String uri) {
    return _httpClient.delete(_buildUri(uri)).then(_handleResponse);
  }

  dynamic _handleResponse(Response response) {
    if (kDebugMode) {
      print('HTTP Response with status: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
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
    queryParams = queryParams?.map(
      (key, value) => MapEntry(key, [value.toString()]),
    );

    if (kReleaseMode) {
      return Uri.https(_httpAuthority, _httpBasePath + uri, queryParams);
    } else {
      return Uri.http(_httpAuthority, _httpBasePath + uri, queryParams);
    }
  }
}
