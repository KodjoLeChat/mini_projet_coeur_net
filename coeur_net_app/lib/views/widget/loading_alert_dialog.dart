import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String title;
  final String loadingMessage;
  const LoadingAlertDialog({
    required this.title,
    this.loadingMessage = 'Chargement en cours...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: ListTile(
        leading: CircularProgressIndicator(),
        title: Text(loadingMessage),
      ),
    );
  }
}
