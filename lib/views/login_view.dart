// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_flutter/services/auth/auth_exceptions.dart';
import 'package:intro_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:intro_flutter/services/auth/bloc/auth_event.dart';
import 'package:intro_flutter/services/auth/bloc/auth_state.dart';
import 'package:intro_flutter/utilities/dialogs/error_dialog.dart';

//Widget Home
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Usuario no encontrado');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Credenciales incorrectas');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Error de autenticación');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                "Ingresar ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.login_outlined),
            ],
          ),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Notas Flutter  ",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    ),
                  ),
                  Icon(
                    Icons.note,
                    size: 54,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Ingresa tu email aquí',
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
              const SizedBox(height: 16.0),
              //
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password),
                  hintText: 'Ingresa tu contraseña aquí',
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
              const SizedBox(height: 16.0),
              //
              TextButton(
                onPressed: () async {
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber[800],
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: Text(
                  'Olvidé mi contraseña',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber[800],
                  ),
                ),
              ),
              //
              TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: Text(
                  'No estás registrado aún? Registrate aquí!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber[800],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
