import 'package:flutter/material.dart';
import 'package:intro_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: "Compartir",
    content: "No puedes compartir una nota vacía :(",
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
