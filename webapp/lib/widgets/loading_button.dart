import 'package:flutter/material.dart';

///
/// A Button that, when clicked, performs an async computation.
/// While the computation isn't over, it stays in loading state.
/// After that, it returns to the default button state.
///
class LoadingButton extends StatefulWidget {
  final Widget text;
  final Widget? icon;
  final Future<void> Function() onTap;

  const LoadingButton({
    required this.text,
    required this.onTap,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.square(
        dimension: 36,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    void buttonCallback() {
      setState(() {
        _isLoading = true;
        widget.onTap().then(
          (value) => safeSetState(() {
            _isLoading = false;
          }),
          onError: (err) {
            safeSetState(() {
              _isLoading = false;
            });
            throw err;
          },
        );
      });
    }

    if (widget.icon == null) {
      return ElevatedButton(
        onPressed: buttonCallback,
        child: widget.text,
      );
    } else {
      return ElevatedButton.icon(
        onPressed: buttonCallback,
        icon: widget.icon!,
        label: widget.text,
      );
    }
  }

  void safeSetState(void Function() action) {
    if (mounted) {
      setState(action);
    }
  }
}
