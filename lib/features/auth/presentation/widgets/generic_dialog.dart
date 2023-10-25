import 'package:flutter/material.dart';
import 'package:flutter_delivery/core/common/widgets/generic_dialog.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';



Future<void> showAuthError({
  required StateException authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: "Some error",
    content: authError.message,
    optionsBuilder: () => {
      'OK': true,
    },
  );
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