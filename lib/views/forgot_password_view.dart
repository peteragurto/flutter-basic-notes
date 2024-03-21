// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:intro_flutter/services/auth/bloc/auth_event.dart';
import 'package:intro_flutter/services/auth/bloc/auth_state.dart';
import 'package:intro_flutter/utilities/dialogs/error_dialog.dart';
import 'package:intro_flutter/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResentDialog(context);
          }

          if (state.exception != null) {
            await showErrorDialog(
              context,
              'No pudimos procesar tu petición. Por favor, asegúrate de haberte registrado, y si no registrate dando un paso atrás',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Recuperar contraseña"),
          backgroundColor: Colors.amber.withAlpha(100),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text(
                'Si olvidaste tu contraseña, ingresa tu email y te enviaremos un enlace para que la modifiques'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              decoration:
                  const InputDecoration(hintText: 'Ingresa tu email...'),
            ),
            //
            TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Enviar enlace para cambiar contraseña')),
            //
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Volver al Login'))
          ]),
        ),
      ),
    );
  }
}
