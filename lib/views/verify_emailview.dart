//Widget de verificacion de email
import 'package:flutter/material.dart';
import 'package:intro_flutter/constants/routes.dart';
import 'package:intro_flutter/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verificar email"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const Text(
              "Hemos enviado un email de verificación, Por favor, ábrelo para verificar tu cuenta"),
          const Text("Si no has recibido nada, presiona el botón de abajo"),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Enviar verificación de email"),
          ),
          TextButton(
            onPressed: () async {
              AuthService.firebase().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Reiniciar"),
          )
        ],
      ),
    );
  }
}
