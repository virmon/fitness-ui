import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertMessageWidget {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String alertTitle,
    required String alertQuestion,
    required VoidCallback onOk,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            alertTitle,
          ),
          content: Text(
            alertQuestion,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOk();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}

