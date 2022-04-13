import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foody_app/data/api/errors/exceptions.dart';
import 'package:http/http.dart';

void handleApiError(dynamic err, BuildContext context) => Future.microtask(() {
      final String errorMessage;

      if (err is RedirectApiException) {
        Navigator.of(context, rootNavigator: true).pushNamed(err.redirectRoute);
        return;
      } else if (err is ApiException) {
        errorMessage = err.displayMessage;
      } else if (err is SocketException || err is TimeoutException) {
        errorMessage = 'Connessione a Internet assente o non funzionante';
      } else if (err is ClientException) {
        debugPrint(err.message);
        errorMessage = 'Errore nella richiesta HTTP al server';
      } else if (err is Error) {
        debugPrintStack(stackTrace: err.stackTrace!);
        errorMessage = 'Errore imprevisto: $err';
      } else {
        errorMessage = err.toString();
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
    });
