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
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                "Recuperar contraseña ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.shield_moon_rounded)
            ],
          ),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Si olvidaste tu contraseña, ingresa tu email y te enviaremos un enlace para que la modifiques'),
              //
              const SizedBox(height: 16),
              //
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_email_outlined),
                  hintText: 'Ingresa tu email...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      width: 2.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              //
              const SizedBox(height: 16),
              //
              TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: Text(
                    'Enviar enlace para cambiar contraseña',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber[800],
                    ),
                  )),
              //
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: Text(
                    'Volver al Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber[800],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
