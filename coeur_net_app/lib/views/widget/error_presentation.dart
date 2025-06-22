import 'package:flutter/material.dart';

class ErrorPresentation extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? errorMessage;

  const ErrorPresentation({
    super.key,
    this.error,
    this.stackTrace,
    this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final message = "Une erreur est survenue.";
    final dimension16 = 16.0;
    return Padding(
      padding: EdgeInsets.all(dimension16),
      child: Column(
        spacing: dimension16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.error,
                size: 48.0,
              ),
              Text(
                "Oups",
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
          Text(
            message,
            style: theme.textTheme.bodyMedium!.copyWith(color: textColor),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: Text("Réessayer")),
        ],
      ),
    );
  }
}
