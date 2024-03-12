import 'package:flutter/material.dart';
import 'package:intro_flutter/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Cerrar sesión",
    content: "¿Seguro que quieres cerrar sesión?",
    optionsBuilder: () => {
      'Cancelar': false,
      'Salir': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
