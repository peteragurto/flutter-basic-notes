import 'package:flutter/material.dart';
import 'package:intro_flutter/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Borrar nota",
    content: "¿Seguro que quieres borrar esta nota?",
    optionsBuilder: () => {
      'Cancelar': false,
      'Salir': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
