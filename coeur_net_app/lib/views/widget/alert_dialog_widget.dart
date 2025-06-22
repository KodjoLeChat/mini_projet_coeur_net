import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  const AlertDialogWidget({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Annuler"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Oui"),
        ),
      ],
    );
  }
}
