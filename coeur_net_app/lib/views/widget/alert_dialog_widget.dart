import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final Color? actionColor;
  const AlertDialogWidget({
    required this.title,
    required this.content,
    this.actionColor,
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
          child: Text("Oui", style: TextStyle(color: actionColor)),
        ),
      ],
    );
  }
}
