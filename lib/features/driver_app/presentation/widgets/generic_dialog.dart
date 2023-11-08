import 'package:flutter/material.dart';
import 'package:flutter_delivery/core/common/widgets/generic_dialog.dart';

void showStateMessage({
  required String message,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100, right: 20, left: 20),
  ));
}

Future<void> showSuccessDialog({
  required String message,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: "Success",
    content: message,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
