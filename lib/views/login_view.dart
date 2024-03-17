// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_flutter/constants/routes.dart';
import 'package:intro_flutter/services/auth/auth_exceptions.dart';
import 'package:intro_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:intro_flutter/services/auth/bloc/auth_event.dart';
import 'package:intro_flutter/utilities/dialogs/error_dialog.dart';

//Widget Home
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Introduce tu email",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Para esquinas redondeadas
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: "Introduce tu contraseña",
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Para esquinas redondeadas
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  "Usuario no encontrado",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Contraseña incorrecta",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Error de Autenticación",
                );
              }
            },
            child: const Text("Entrar"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Aún no tienes cuenta? Registrate aquí"))
        ],
      ),
    );
  }
}
