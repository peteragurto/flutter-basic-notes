import 'package:flutter/material.dart';
import 'package:intro_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: "Un error ocurrió",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
