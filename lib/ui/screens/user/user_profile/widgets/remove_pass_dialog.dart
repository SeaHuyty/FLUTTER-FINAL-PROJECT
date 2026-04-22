import 'package:flutter/material.dart';

Future<void> showRemovePassDialog(
  BuildContext context, {
  required Future<void> Function() onConfirmRemove,
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Remove Pass'),
      content: const Text('Are you sure you want to remove your active pass?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await onConfirmRemove();
          },
          child: const Text('Remove', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
