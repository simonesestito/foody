import 'package:flutter/material.dart';

class AppSnackbar extends SnackBar {
  AppSnackbar({
    required BuildContext context,
    required String content,
    SnackBarAction? action,
    Key? key,
  }) : super(
          key: key,
          content: Text(
            content,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          action: action == null
              ? null
              : SnackBarAction(
                  label: action.label,
                  onPressed: action.onPressed,
                  textColor:
                      Theme.of(context).colorScheme.onSecondary.withAlpha(200),
                ),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        );
}
