import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<bool?> call(BuildContext context,
      {required String question}) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            question,
            style: const TextStyle(
              fontFamily: 'JosefinSans',
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'NÃO',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: const Text(
                'SIM',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
