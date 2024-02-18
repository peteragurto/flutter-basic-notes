import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    return Column(
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
              final userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);

              print(userCredential);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print("Usuario no encontrado");
              } else if (e.code == 'wrong-password') {
                print("Contraseña incorrecta");
              }
            }
          },
          child: const Text("Entrar"),
        ),
        TextButton(
            onPressed: () {},
            child: const Text("Aún no tienes cuenta? Registrate aquí"))
      ],
    );
  }
}
