import 'package:fitness/services/database_service.dart';
import 'package:flutter/material.dart';


void showSuccessSnackBar(BuildContext context, String message, {
  required VoidCallback onUndo,
}) {
  if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Undo',
        textColor : Colors.white,
        onPressed: onUndo,
      ),
    ),
  );
  }
}

Future<bool> showDeleteDialog(BuildContext context, String itemId) async {
  bool deleted = false;
  final _databaseService = DatabaseService();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Item'),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {

            await _databaseService.deleteItem(itemId);

            if (context.mounted) {
      showSuccessSnackBar(
        context,
        "Item deleted successfully!",
        onUndo: () async {
          await _databaseService.restoreItem(itemId);
          if (context.mounted) {
            showSuccessSnackBar(context, "Undo successful!", onUndo: () {});
          }
        },
      );
    }
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pop(context); 
            });
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  return deleted;
}
