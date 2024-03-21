import 'package:flutter/material.dart';
import 'package:intro_flutter/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Cambio de contraseña',
    content:
        'Hemos enviado un enlace para cambiar tu contraseña, revisa tu email',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
